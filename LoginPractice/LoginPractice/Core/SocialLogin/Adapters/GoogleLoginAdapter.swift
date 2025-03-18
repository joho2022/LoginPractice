//
//  GoogleLoginAdapter.swift
//  LoginPractice
//
//  Created by 조호근 on 3/19/25.
//

import Foundation
import GoogleSignIn

final class GoogleLoginAdapter: SocialLoginService {
    
    @MainActor
    func login() async throws -> UserInfo {
        return try await withCheckedThrowingContinuation { continuation in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let presentingViewController = windowScene.windows.first?.rootViewController else {
                continuation.resume(throwing: AuthError.loginFailed(service: .google))
                return
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
                if let error = error {
                    print("==== Google Login Error ====")
                    print("Error: \(error.localizedDescription)")
                    print("==============================")
                    
                    continuation.resume(throwing: AuthError.loginFailed(service: .google))
                    return
                }
                
                guard let user = signInResult?.user else {
                    continuation.resume(throwing: AuthError.userInfoNotFound(service: .google))
                    return
                }
                
                let userInfo = UserInfo(
                    id: user.userID ?? "",
                    name: user.profile?.name ?? "Unknown",
                    email: user.profile?.email ?? "Unknown"
                )
                continuation.resume(returning: userInfo)
            }
        }
    }
    
    @MainActor
    func logout() async throws {
        GIDSignIn.sharedInstance.signOut()
    }
    
    func getServiceName() -> String {
        return "Google Auth"
    }
}

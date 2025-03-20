//
//  NaverLoginAdapter.swift
//  LoginPractice
//
//  Created by 조호근 on 3/20/25.
//

import Foundation
import NidThirdPartyLogin

final class NaverLoginAdapter: SocialLoginService {
    
    @MainActor
    func login() async throws -> UserInfo {
        return try await withCheckedThrowingContinuation { continuation in
            NidOAuth.shared.requestLogin { result in
                switch result {
                case .success(let loginResult):
                    let userInfo = UserInfo(
                        id: loginResult.accessToken.tokenString,
                        name: "Naver User",
                        email: "naver@example.com"
                    )
                    
                    continuation.resume(returning: userInfo)
                case .failure(let error):
                    print("==== Naver Login Error ====")
                    print("Error: \(error.localizedDescription)")
                    print("==============================")
                    
                    continuation.resume(throwing: AuthError.loginFailed(service: .naver))
                }
            }
        }
    }
    
    @MainActor
    func logout() async throws {
        NidOAuth.shared.logout()
    }
    
    func getServiceName() -> String {
        return "Naver Auth"
    }
}

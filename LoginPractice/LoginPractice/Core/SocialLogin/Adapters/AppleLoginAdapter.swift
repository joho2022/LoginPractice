//
//  AppleLoginAdapter.swift
//  LoginPractice
//
//  Created by 조호근 on 3/17/25.
//

import Foundation
import AuthenticationServices

final class AppleLoginAdapter: NSObject, SocialLoginService {
    
    private var continuation: CheckedContinuation<UserInfo, Error>?
    
    @MainActor
    func login() async throws -> UserInfo {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
    
    @MainActor
    func logout() async throws {}
    
    func getServiceName() -> String {
        return "Apple Auth"
    }
    
}

extension AppleLoginAdapter: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.givenName ?? "Unknown"
            let email = appleIDCredential.email ?? "Unknown"
            
            let userInfo = UserInfo(id: userId, name: fullName, email: email)
            continuation?.resume(returning: userInfo)
        } else {
            continuation?.resume(throwing: AuthError.userInfoNotFound(service: .apple))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        continuation?.resume(throwing: error)
    }
}

extension AppleLoginAdapter: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            return keyWindow
        }
        return UIWindow()
    }
}

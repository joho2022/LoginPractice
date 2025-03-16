//
//  KakaoLoginAdapter.swift
//  LoginPractice
//
//  Created by 조호근 on 3/11/25.
//

import Foundation
import KakaoSDKUser

final class KakaoLoginAdapter: SocialLoginService {
  
    @MainActor
    func login() async throws -> UserInfo {
        return try await withCheckedThrowingContinuation { continuation in
            
            
            
            UserApi.shared.loginWithKakaoTalk { OAuthToken, error in
                if let error = error {
                    print("==== Kakao Login Error ====")
                    print("Error: \(error.localizedDescription)")
                    print("==============================")
                    
                    continuation.resume(throwing: AuthError.loginFailed(service: .kakao))
                    return
                }
                
                if let token = OAuthToken?.accessToken {
                    print("Access Token Received: \(token)")
                } else {
                    print("Access Token Not Found")
                }
                
                UserApi.shared.me { user, error in
                    if let error = error {
                        print("==== Kakao Login Error ====")
                        print("Error: \(error.localizedDescription)")
                        print("==============================")
                        
                        continuation.resume(throwing: AuthError.loginFailed(service: .kakao))
                        return
                    }
                    
                    guard let user = user,
                          let id = user.id,
                          let name = user.kakaoAccount?.profile?.nickname,
                          let email = user.kakaoAccount?.email else {
                        continuation.resume(throwing: AuthError.userInfoNotFound(service: .kakao))
                        return
                    }
                    
                    let userInfo = UserInfo(
                        id: String(id),
                        name: name,
                        email: email
                    )
                    
                    continuation.resume(returning: userInfo)
                    
                }
            }
        }
    }
    
    @MainActor
    func logout() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.logout { error in
                if let error = error {
                    print("==== Kakao Logout Error ====")
                    print("Error: \(error.localizedDescription)")
                    print("==============================")
                    
                    continuation.resume(throwing: AuthError.logoutFailed(service: .kakao))
                    return
                }
                
                continuation.resume()
            }
        }
    }
    
    func getServiceName() -> String {
        return "Kakao Auth"
    }
    
}

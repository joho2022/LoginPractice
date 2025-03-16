//
//  AuthManager.swift
//  LoginPractice
//
//  Created by 조호근 on 3/12/25.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    private let accessTokenKey: String = "accessToken"
    
    private var loginAdapter: SocialLoginService?
    
    private init() {}
    
    func login(with type: SocialLoginType) async throws -> UserInfo {
        let adapter = await type.getAdapter()
        let userInfo = try await adapter.login()
        
        let tokenData = Data(userInfo.id.utf8)
        
        do {
            try KeychainManager.save(
                service: accessTokenKey,
                account: adapter.getServiceName(),
                data: tokenData
            )
            print("\(type.serviceName) 로그인 성공")
        } catch {
            throw AuthError.tokenSaveFailed
        }
        
        return userInfo
    }
    
    func logout(with type: SocialLoginType) async throws {
        let adapter = await type.getAdapter()
        
        try await adapter.logout()
        
        do {
            try KeychainManager.delete(service: "authService", account: adapter.getServiceName())
        } catch {
            throw AuthError.tokenDeleteFailed
        }
        
        print("\(type.serviceName) 로그아웃 성공")
    }
    
}

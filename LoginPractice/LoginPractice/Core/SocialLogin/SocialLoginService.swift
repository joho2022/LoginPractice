//
//  SocialLoginService.swift
//  LoginPractice
//
//  Created by 조호근 on 3/11/25.
//

import Foundation

protocol SocialLoginService {
    func login() async throws -> UserInfo
    func logout() async throws
    func getServiceName() -> String
}

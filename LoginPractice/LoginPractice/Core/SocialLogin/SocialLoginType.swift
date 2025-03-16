//
//  SocialLoginType.swift
//  LoginPractice
//
//  Created by 조호근 on 3/12/25.
//

import Foundation

enum SocialLoginType {
    case kakao
    
    var serviceName: String {
        switch self {
        case .kakao: return "Kakao"
        }
    }
    
    @MainActor func getAdapter() -> SocialLoginService {
        switch self {
        case .kakao: return KakaoLoginAdapter()
        }
    }
    
}

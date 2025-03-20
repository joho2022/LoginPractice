//
//  SocialLoginType.swift
//  LoginPractice
//
//  Created by 조호근 on 3/12/25.
//

import Foundation

enum SocialLoginType {
    case kakao
    case apple
    case google
    case naver
    
    var serviceName: String {
        switch self {
        case .kakao: return "Kakao"
        case .apple: return "Apple"
        case .google: return "Google"
        case .naver: return "Naver"
        }
    }
    
    @MainActor func getAdapter() -> SocialLoginService {
        switch self {
        case .kakao: return KakaoLoginAdapter()
        case .apple: return AppleLoginAdapter()
        case .google: return GoogleLoginAdapter()
        case .naver: return NaverLoginAdapter()
        }
    }
    
}

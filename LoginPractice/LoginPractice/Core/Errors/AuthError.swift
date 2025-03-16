//
//  AuthError.swift
//  LoginPractice
//
//  Created by 조호근 on 3/12/25.
//

import Foundation

enum AuthError: Error {
    // 로그인
    case loginFailed(service: SocialLoginType)
    case logoutFailed(service: SocialLoginType)
    case userInfoNotFound(service: SocialLoginType)
    
    // 인증 관련 에러
    case noLoginAdapterSet
    case tokenSaveFailed
    case tokenDeleteFailed
    
    // 키체인 관련 에러
    case keychainDuplicateItem
    case keychainItemNotFound
    case keychainDataConversionError
    case keychainSecurityError(OSStatus)
    
    // 기타 에러
    case networkError
    case unknown(Error)
    
    var userMessage: String {
        switch self {
        // 로그인
        case .loginFailed(let service), .userInfoNotFound(let service):
            return "\(service) 로그인에 실패했습니다. 다시 시도해 주세요."
        case .logoutFailed(let service):
            return "\(service) 로그아웃에 실패했습니다."
            
        // 보안
        case .noLoginAdapterSet, .tokenSaveFailed, .tokenDeleteFailed,
                .keychainDuplicateItem, .keychainItemNotFound, .keychainDataConversionError, .keychainSecurityError:
            return "계정 인증에 문제가 발생했습니다. 다시 로그인해 주세요."
            
        case .networkError:
            return "네트워크 연결을 확인해 주세요."
            
        case .unknown:
            return "오류가 발생했습니다. 잠시 후 다시 시도해 주세요."
        }
    }
    
    var developerDescription: String {
        switch self {
        case .loginFailed(let service):
            return "로그인 실패: \(service)"
        case .logoutFailed(let service):
            return "로그아웃 실패: \(service)"
        case .userInfoNotFound(let service):
            return "사용자 정보 찾기 실패: \(service)"
        case .noLoginAdapterSet:
            return "로그인 어댑터 설정 안됨"
        case .tokenSaveFailed:
            return "토큰 저장 실패"
        case .tokenDeleteFailed:
            return "토큰 삭제 실패"
        case .keychainDuplicateItem:
            return "키체인 중복 항목"
        case .keychainItemNotFound:
            return "키체인 항목 없음"
        case .keychainDataConversionError:
            return "키체인 데이터 변환 오류"
        case .keychainSecurityError(let status):
            return "키체인 보안 오류 (코드: \(status))"
        case .networkError:
            return "네트워크 오류"
        case .unknown(let error):
            return "알 수 없는 오류: \(error.localizedDescription)"
        }
    }
    
}

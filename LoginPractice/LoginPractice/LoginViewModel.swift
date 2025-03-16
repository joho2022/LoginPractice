//
//  LoginViewModel.swift
//  LoginPractice
//
//  Created by 조호근 on 3/12/25.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var errorMessage: ErrorMessage?
    @Published var userInfo: UserInfo?
    
    private var lastLoginType: SocialLoginType?
    
    struct ErrorMessage: Identifiable {
        let id = UUID()
        let message: String
    }
    
    func login(with type: SocialLoginType) async {
        self.errorMessage = nil
        self.lastLoginType = type
        
        do {
            let userInfo = try await AuthManager.shared.login(with: type)
            await MainActor.run {
                self.userInfo = userInfo
            }
        } catch let error as AuthError {
            handleError(error)
        } catch {
            handleError(AuthError.unknown(error))
        }
    }
    
    func logout() async {
        guard let loginType = lastLoginType else {
            self.errorMessage = ErrorMessage(message: "로그아웃할 계정이 없습니다.")
            return
        }
        
        self.errorMessage = nil
        
        do {
            try await AuthManager.shared.logout(with: loginType)
            await MainActor.run {
                self.userInfo = nil
                self.lastLoginType = nil
            }
        } catch let error as AuthError {
            handleError(error)
        } catch {
            handleError(AuthError.unknown(error))
        }
    }

    private func handleError(_ error: Error) {
        if let authError = error as? AuthError {
            self.errorMessage = ErrorMessage(message: authError.userMessage)
            print("==== Error Info ====")
            print(authError.developerDescription)
            print("=====================")
        } else {
            let unknownError = AuthError.unknown(error)
            self.errorMessage = ErrorMessage(message: unknownError.userMessage)
            print("==== Unknown Error ====")
            print(unknownError.developerDescription)
            print("=======================")
        }
    }
    
}

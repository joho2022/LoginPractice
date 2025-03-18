//
//  LoginView.swift
//  LoginPractice
//
//  Created by 조호근 on 3/12/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isShowingUserInfo = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("소셜 로그인 테스트")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(spacing: 16) {
                    if let userInfo = viewModel.userInfo {
                        Text("Welcome, \(userInfo.name)")
                        
                        Button {
                            Task {
                                await viewModel.logout()
                            }
                        } label: {
                            Text("Logout")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    } else {
                        SocialLoginButton(type: .kakao) {
                            Task {
                                await viewModel.login(with: .kakao)
                                if viewModel.userInfo != nil {
                                    isShowingUserInfo = true
                                }
                            }
                        }
                        
                        SocialLoginButton(type: .google) {
                            Task {
                                await viewModel.login(with: .google)
                                if viewModel.userInfo != nil {
                                    isShowingUserInfo = true
                                }
                            }
                        }
                        
                        SocialLoginButton(type: .apple) {
                            Task {
                                await viewModel.login(with: .apple)
                                if viewModel.userInfo != nil {
                                    isShowingUserInfo = true
                                }
                            }
                        }
                    }
                }
                .alert(item: $viewModel.errorMessage) { error in
                    Alert(
                        title: Text("오류"),
                        message: Text(error.message),
                        dismissButton: .default(Text("확인"))
                    )
                }
            }
            .navigationDestination(isPresented: $isShowingUserInfo) {
                UserInfoView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    LoginView()
}

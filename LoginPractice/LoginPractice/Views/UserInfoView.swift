//
//  UserInfoView.swift
//  LoginPractice
//
//  Created by 조호근 on 3/12/25.
//

import SwiftUI

struct UserInfoView: View {
    @ObservedObject var viewModel: LoginViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            if let userInfo = viewModel.userInfo {
                VStack(spacing: 16) {
                    Text("사용자 정보")
                        .font(.title)
                        .padding(.bottom, 20)
                    
                    Text("ID: \(userInfo.id)")
                        .font(.headline)
                    
                    Text("이름: \(userInfo.name)")
                        .font(.headline)
                    
                    Text("이메일: \(userInfo.email)")
                        .font(.headline)
                }
                .padding(50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                )
                .padding(.bottom, 30)
                
                
                Button {
                    Task {
                        await viewModel.logout()
                        dismiss()
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
                Text("사용자 정보가 없습니다.")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

#Preview {
    let viewModel = LoginViewModel()
    viewModel.userInfo = UserInfo(id: "12345", name: "홍길동", email: "test@example.com")
    
    return UserInfoView(viewModel: viewModel)
}

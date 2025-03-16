//
//  SocialLoginButton.swift
//  LoginPractice
//
//  Created by 조호근 on 3/12/25.
//

import SwiftUI

struct SocialLoginButton: View {
    let type: SocialLoginType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.serviceName + " Login")
                .font(.system(size: 20, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SocialLoginButton(type: .kakao, action: { })
}

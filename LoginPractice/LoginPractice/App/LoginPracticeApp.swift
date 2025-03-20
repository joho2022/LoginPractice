//
//  LoginPracticeApp.swift
//  LoginPractice
//
//  Created by 조호근 on 3/10/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn
import NidThirdPartyLogin

@main
struct LoginPracticeApp: App {
    
    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        
        NidOAuth.shared.initialize()
        NidOAuth.shared.setLoginBehavior(.appPreferredWithInAppBrowserFallback)
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                    
                    if NidOAuth.shared.handleURL(url) {
                        return
                    }
                    
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}

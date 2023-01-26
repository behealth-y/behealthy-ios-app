//
//  AppDelegate.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/25.
//

import UIKit
import KakaoSDKCommon
import Firebase
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // LaunchScreen 노출 시간 조정
        Thread.sleep(forTimeInterval: 1.0)
        
        // Firebase
        FirebaseApp.configure()
        
        // KAKAO
        KakaoSDK.initSDK(appKey: "3bb94cb0bfaa0d054202fe2cb9548187")
        
        let identifier = Locale.current.identifier
        if let regionCode = Locale.current.regionCode, let languageCode = Locale.current.languageCode {
            print("identifier: \(identifier), regionCode: \(regionCode), languageCode: \(languageCode)")
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
//            switch credentialState {
//            case .authorized:
//                //인증성공 상태
//            case .revoked:
//                //인증만료 상태
//            default:
//                //.notFound 등 이외 상태
//            }
//        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


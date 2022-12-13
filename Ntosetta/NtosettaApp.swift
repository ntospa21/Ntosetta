//
//  NtosettaApp.swift
//  Ntosetta
//
//  Created by Pantos, Thomas on 13/12/22.
//

import SwiftUI
import Firebase

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
           FirebaseApp.configure()
           return true
       }
}
@main
struct PtuxiakiApp: App {
//    @StateObject var firestoreManager = FirestoreManager()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = SessionServiceImpl()
    var body: some Scene {
        WindowGroup {
            switch sessionService.state {
            case .loggedIn:
                SplashScreenView()
                
            case .loggedOut:
                LoginView()
            }
        }
    }
}
 

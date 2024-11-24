//
//  EventualmenteApp.swift
//  Eventualmente
//
//  Created by Inés Carrión on 8/10/24.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        return true
    }
}

@main
struct EventualmenteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var appModel: AppModel

    init() {
        FirebaseApp.configure()
        appModel = AppModel()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
    }
}

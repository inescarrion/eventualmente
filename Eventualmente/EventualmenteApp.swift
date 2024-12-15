import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

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

        UISegmentedControl.appearance().selectedSegmentTintColor = .accent
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 17)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 17)], for: .normal)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .tint(.accent)
                .onAppear {
                    UIView.appearance().tintColor = UIColor(named: "AccentColor")
                }
        }
    }
}

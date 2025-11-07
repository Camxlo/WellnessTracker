import SwiftUI
import UIKit
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}


@main
struct WellnessTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var model = AppModel()
       var body: some Scene {
           WindowGroup {
               RootView()
                   .environmentObject(model)
                   .onAppear { NotificationService.shared.requestAuthorization() }
           }
       }
}

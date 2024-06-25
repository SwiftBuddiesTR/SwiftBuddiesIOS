import SwiftUI
import Map
import SwiftData

@main
struct SwiftBuddiesIOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: EventModel.self)
        
        
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencyContainer: DependencyContainerProtocol!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if let clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String {
            let signInConfig = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = signInConfig
        }
        
        dependencyContainer = DependencyContainer.shared
        dependencyContainer.build()
        
        return true
    }
}

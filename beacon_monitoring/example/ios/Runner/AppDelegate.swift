import UIKit
import Flutter
import beacon_monitoring

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let MINUTES_15: Int = 60*15

    /// Registers all pubspec-referenced Flutter plugins in the given registry.
    static func registerPlugins(with registry: FlutterPluginRegistry) {
            GeneratedPluginRegistrant.register(with: registry)
       }

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupFirebase()
        setupDynamicLinks()
        setupPluginRegistrantCallback()
        setupBackgroundMode()
        setupNotificationService()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Private Methods
    private func setupFirebase() {

    }
    private func setupDynamicLinks() {

    }
    private func setupPluginRegistrantCallback() {
        // Register the app's plugins in the context of a normal run
        AppDelegate.registerPlugins(with: self)

        // The following code will be called upon WorkmanagerPlugin's registration.
        // Note : all of the app's plugins may not be required in this context ;
        // instead of using GeneratedPluginRegistrant.register(with: registry),
        // you may want to register only specific plugins.
        BeaconMonitoringPlugin.setPluginRegistrantCallback { registry in
            AppDelegate.registerPlugins(with: registry)
        }
    }
    private func setupBackgroundMode() {
        UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(MINUTES_15))
    }
    private func setupNotificationService() {
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - UNUserNotificationCenter Delegate Methods
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
        completionHandler([.alert, .sound]) // shows banner even if app is in foreground
    }
}

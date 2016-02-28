import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)

        let agentViewController = AgentViewController(style: .Grouped)
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let navigationController = UINavigationController(rootViewController: agentViewController)
        navigationController.navigationBar.barStyle = .BlackTranslucent
        navigationController.navigationBar.tintColor = .whiteColor()

        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        return true
    }
}


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let agentViewController = AgentViewController()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let navigationController = UINavigationController(rootViewController: agentViewController)

        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        return true
    }
}


import Cocoa

class AppDelegate: NSObject {
    
    let session: ImageAnnotatingSessionProtocol
    let imageAnnotatingRouter: ImageAnnotatingRouter
    
    override init() {
        session = ImageAnnotatingSession()
        let router = ImageAnnotatingRouter(imageAnnotatingSession: session)
        router.manageLabelsRouter = ManageLabelsRouter(imageAnnotatingSession: session)
        imageAnnotatingRouter = router
    }
    
}

extension AppDelegate: NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let window = mainStoryboard().instantiateController(withIdentifier: "MainWindow") as! NSWindowController
        loadMainMenu()
        let mainViewController = imageAnnotatingRouter.createMainViewController()
        
        window.contentViewController = mainViewController
        window.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
}

extension AppDelegate {
    
    func mainStoryboard() -> NSStoryboard {
        return NSStoryboard(name: NSStoryboard.Name("Main"), bundle: Bundle.main)
    }
    
    
    func loadMainMenu() {
        guard let nib = NSNib(nibNamed: NSNib.Name("MainMenu"), bundle: Bundle.main) else {
           fatalError("Resource `MainMenu.xib` is not found in the bundle `\(Bundle.main.bundlePath)`")
        }
        nib.instantiate(withOwner: NSApplication.shared, topLevelObjects: nil)
    }
    
}

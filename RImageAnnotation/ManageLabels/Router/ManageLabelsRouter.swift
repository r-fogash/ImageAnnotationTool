import AppKit

class ManageLabelsRouter {
    
    private let session: ImageAnnotatingSessionProtocol
    private weak var manageLabelsViewController: ManageLabelsViewController?
    
    init(imageAnnotatingSession: ImageAnnotatingSessionProtocol) {
        self.session = imageAnnotatingSession
    }
    
}

extension ManageLabelsRouter: ManageLabelsRouting {
    
    func showManageLabels(parentViewController: NSViewController) {
        let view = mainStoryboard().instantiateController(withIdentifier: "ManageLabelsViewController") as! ManageLabelsViewController
        
        let presenter = ManageLabelsPresenter()
        presenter.addLabel = AddLabel(imageAnnotatingSession: session)
        presenter.removeLabel = RemoveLabel(imageAnnotatingSession: session)
        presenter.labelList = LabelList(imageAnnotatingSession: session)
        
        let labelListDidChange = LabelListDidChange(imageAnnotatingSession: session)
        presenter.labelListChanged = labelListDidChange
        labelListDidChange.output = presenter
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = self
        
        let window = NSWindow(contentViewController: view)
        parentViewController.view.window?.beginSheet(window, completionHandler: nil)
        manageLabelsViewController = view
    }
    
    func closeManageLabels() {
        manageLabelsViewController?.view.window?.close()
    }
    
}

extension ManageLabelsRouter {
    
    func mainStoryboard() -> NSStoryboard {
        return NSStoryboard(name: "Main", bundle: nil)
    }
    
}

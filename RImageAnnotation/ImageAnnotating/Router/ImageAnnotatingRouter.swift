import Foundation
import Cocoa
import AppKit

class ImageAnnotatingRouter {
    
    private weak var viewController: ViewController?
    private weak var presenter: ImageAnnotatingPresentation?
    private var openPanel: NSOpenPanel?
    private var savePanel: NSSavePanel?
    private var imageAnnotatingSession: ImageAnnotatingSessionProtocol
    
    public var manageLabelsRouter: ManageLabelsRouting!
    
    init(imageAnnotatingSession: ImageAnnotatingSessionProtocol) {
        self.imageAnnotatingSession = imageAnnotatingSession
    }
    
}

extension ImageAnnotatingRouter: ImageAnnotatingRouting {
    
    func createMainViewController() -> NSViewController {
        let viewController = mainStoryboard().instantiateController(withIdentifier: "ViewController") as! ViewController
        let presenter = ImageAnnotatingPresenter()
        
        viewController.presenter = presenter
        
        let imageModelBuilder = ImageModelBuilder(imageAnnotatingSession: imageAnnotatingSession)
        let annotationListDidChange = AnnotationListDidChange(imageAnnotatingSession: imageAnnotatingSession, imageModelBuilder: imageModelBuilder)
        let labelListDidChange = LabelListDidChange(imageAnnotatingSession: imageAnnotatingSession)
        
        presenter.view = viewController
        presenter.router = self
        presenter.writeAnnotationsToFile = WriteAnnotationToFile(serialiser: AnnotationListJSONSerialisation(), imageAnnotatingSession: imageAnnotatingSession)
        presenter.applySelectionToImage = ApplySelectionToImage(imageAnnotatingSession: imageAnnotatingSession)
        presenter.openFolder = OpenFolder(imageAnnotatingSession: imageAnnotatingSession, retriveImagesInFolder: RetriveImageFilesFromFolder(), imageModelBuilder: imageModelBuilder)
        presenter.clearSelection = ClearSelection(imageAnnotatingSession: imageAnnotatingSession)
        presenter.fetchSelectionForImage = FetchSelectionForImage(imageAnnotatingSession: imageAnnotatingSession)
        presenter.annotationListDidChange = annotationListDidChange
        presenter.labelListDidChangeObserver = labelListDidChange
        presenter.imageModelListFilterBuilder = ImageModelListFilterBuilder()
        
        self.viewController = viewController
        self.presenter = presenter
        
        annotationListDidChange.output = presenter
        labelListDidChange.output = presenter
        
        return viewController
    }
    
    func showOpenFolderDialog() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.title = "Select a folder"
        openPanel.message = "Select a folder which contains image files. Only JPG image files are allowed"
        
        openPanel.begin { [weak self] (response) in
            guard let self = self else {
                return
            }
            defer {
                self.openPanel = nil
            }
            guard response == NSApplication.ModalResponse.OK else { return }
            guard let url = self.openPanel!.urls.first else { return }
            
            self.presenter?.onOpenFolder(url: url)
        }
        self.openPanel = openPanel
    }
    
    func showSaveFileDialog() {
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.canSelectHiddenExtension = false
        savePanel.allowedFileTypes = ["json"]
        savePanel.message = "Select a folder to save annotation files"
        
        savePanel.begin { [weak self] (response) in
            guard let self = self else {
                return
            }
            defer {
                self.savePanel = nil
            }
            guard response == NSApplication.ModalResponse.OK else { return }
            guard let url = self.savePanel?.url else { return }
            
            self.presenter?.onSaveDialogSelect(url: url)
        }
        self.savePanel = savePanel
    }
    
    func showManageLabels() {
        guard let viewController = self.viewController else {
            return
        }
        manageLabelsRouter.showManageLabels(parentViewController: viewController)
    }
    
    func setWindow(title: String) {
        self.viewController?.view.window?.title = title
    }
}

extension ImageAnnotatingRouter {
    
    func mainStoryboard() -> NSStoryboard {
        return NSStoryboard(name: NSStoryboard.Name("Main"), bundle: Bundle.main)
    }
    
}

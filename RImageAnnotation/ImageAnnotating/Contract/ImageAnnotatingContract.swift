import AppKit

public protocol ImageModelProtocol {
    
    var imageURL: URL {get}
    var label: String? {get}
    
}

public protocol ImageAnnotatingView: class {
    
    func setNavigationBack(enabled: Bool)
    func setNavigationForward(enabled: Bool)
    func setClearSelection(enabled: Bool)
    func setApplySelection(enabled: Bool)
    func show(imageThumbnails: [ImageModelProtocol])
    func showInEditor(imageURL: URL, selectionFrameInImageCoordinates: NSRect?)
    func clearEditor()
    func set(labelList: [String])
    func clearSelection()
    func show(error: NSError)
    func setFilter(enabled: Bool)
    func selectFilterShowAll()
    func set(selectedLabel: String?)
    
}

public protocol ImageAnnotatingPresentation: class {
    
    func onViewDidLoad()
    func onOpenFolder(url: URL)
    func onPressNext()
    func onPressPrevious()
    func onPressImageThumb(url: URL)
    func onCreateSelection()
    func onRemoveSelection()
    func onApply(selectionCoordinates: NSRect?)
    func onSelect(label: String?)
    func onPressClearSelection()
    func onPressOpenFolder()
    func onPressManageLabels()
    func onPressSave()
    func onSaveDialogSelect(url: URL)
    func onFilterAll()
    func onFilterNotMarked()
    func onFilterMarked()
    
}

protocol ImageAnnotatingRouting {
    
    func createMainViewController() -> NSViewController
    func showOpenFolderDialog()
    func showSaveFileDialog()
    func showManageLabels()
    func setWindow(title: String)
    
}

// MARK: - Usecases

protocol AnnotationListSerialisationProtocol {
    
    func serialize(annotationList: [AnnotationModel]) -> Data
    
}

protocol RetriveImageFilesFromFolderProtocol: class {
    
    func imageFiles(folder: URL) -> [URL]
    
}

protocol DataWritterProtocol {

    typealias FinishBlock = (_ success: Bool, _ error: Error?) -> Void
    
    func writeAnnotations(to fileURL: URL, completion: @escaping FinishBlock)
    
}

protocol ApplySelectionToImageProtocol {
    
    func applySelection(inImageCoordinates: NSRect, to imageURL: URL, label: String)
    
}

protocol OpenFolderProtocol {
    
    func openFolder(url: URL) -> [ImageModelProtocol]
    
}

protocol ClearSelectionProtocol {
    
    func clearSelection(imageURL: URL)
    
}

protocol FetchSelectionForImageProtocol {
    
    func selectionRectInImageCoordinatesFor(imageURL: URL) -> NSRect?
    
}

protocol AnnotationListDidChangeProtocol {
    
}

protocol AnnotationListDidChangeOutput: class {
    
    func annotationDidChange(forImage: ImageModelProtocol)
    
}

protocol ImageModelListFilterBuilderProtocol {
    
    func createAllImageFilter(output: ImageModelListFilterOutput) -> ImageModelListFilterProtocol
    func createMarkedImageFilter(output: ImageModelListFilterOutput) -> ImageModelListFilterProtocol
    func createNotMarkedImageFilter(output: ImageModelListFilterOutput) -> ImageModelListFilterProtocol
    
}

protocol ImageModelListFilterProtocol {
    
    func filter(imageModelList: [ImageModelProtocol])
    
}

protocol ImageModelListFilterOutput: class {
    
    func didFilter(imageModelList: [ImageModelProtocol])
    
}

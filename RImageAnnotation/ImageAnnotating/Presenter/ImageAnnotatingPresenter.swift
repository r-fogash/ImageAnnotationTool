import Foundation

class ImageAnnotatingPresenter {
    
    public weak var view: ImageAnnotatingView!
    public var router: ImageAnnotatingRouting!
    public var writeAnnotationsToFile: DataWritterProtocol!
    public var applySelectionToImage: ApplySelectionToImageProtocol!
    public var openFolder: OpenFolderProtocol!
    public var clearSelection: ClearSelectionProtocol!
    public var fetchSelectionForImage: FetchSelectionForImageProtocol!
    public var labelListDidChangeObserver: LabelListDidChangeProtocol!
    public var annotationListDidChange: AnnotationListDidChangeProtocol!
    public var imageModelListFilterBuilder: ImageModelListFilterBuilderProtocol!
    
    private var imageModelList = [ImageModelProtocol]()
    private var filteredModelList = [ImageModelProtocol]()
    private var currentImageIndex = -1
    private var selectionMade = false
    private var selectedLabel: String?
    private var imageModelListFilter: ImageModelListFilterProtocol!
    
}

extension ImageAnnotatingPresenter: ImageAnnotatingPresentation {
    
    public func onViewDidLoad() {
        view.setNavigationBack(enabled: false)
        view.setNavigationForward(enabled: false)
        view.setApplySelection(enabled: false)
        view.setClearSelection(enabled: false)
        view.set(labelList: [])
        view.set(selectedLabel: nil)
        view.setFilter(enabled: false)
    }
    
    public func onOpenFolder(url: URL) {
        imageModelList = openFolder.openFolder(url: url)
        filteredModelList = imageModelList
        view.show(imageThumbnails: filteredModelList)
        
        view.setNavigationBack(enabled: false)
        view.setNavigationForward(enabled: filteredModelList.count != 0)
        view.setApplySelection(enabled: false)
        view.setClearSelection(enabled: false)
        view.setFilter(enabled: filteredModelList.count > 0)
        view.selectFilterShowAll()
        imageModelListFilter = imageModelListFilterBuilder.createAllImageFilter(output: self)
        
        if let firstImageURL = filteredModelList.first?.imageURL {
            fetchAnnotationAndShow(url: firstImageURL)
            currentImageIndex = 0
        }
    }
    
    public func onPressNext() {
        currentImageIndex += 1
        fetchAnnotationAndShow(url: filteredModelList[currentImageIndex].imageURL)
        updateNavigationButtonsState()
    }
    
    public func onPressPrevious() {
        currentImageIndex -= 1
        fetchAnnotationAndShow(url: filteredModelList[currentImageIndex].imageURL)
        updateNavigationButtonsState()
    }
    
    public func onPressImageThumb(url: URL) {
        currentImageIndex = filteredModelList.map{ $0.imageURL }.firstIndex(of: url)!
        fetchAnnotationAndShow(url: url)
        updateNavigationButtonsState()
    }
    
    func onCreateSelection() {
        selectionMade = true
        updateApplyButtonEnabledState()
        view.setClearSelection(enabled: true)
    }
    
    func onRemoveSelection() {
        selectionMade = false
        updateApplyButtonEnabledState()
        view.setClearSelection(enabled: false)
    }
    
    func onApply(selectionCoordinates: NSRect?) {
        let label = selectedLabel!
        let imageURL = filteredModelList[currentImageIndex].imageURL
        applySelectionToImage.applySelection(inImageCoordinates: selectionCoordinates!, to: imageURL, label: label)
    }
    
    func onSelect(label: String?) {
        selectedLabel = label
        updateApplyButtonEnabledState()
    }
    
    func onPressClearSelection() {
        view.clearSelection()
        clearSelection.clearSelection(imageURL: filteredModelList[currentImageIndex].imageURL)
    }
    
    func onPressOpenFolder() {
        router.showOpenFolderDialog()
    }
    
    func onPressManageLabels() {
        router.showManageLabels()
    }
    
    func onPressSave() {
        router.showSaveFileDialog()
    }
    
    func onSaveDialogSelect(url: URL) {
        writeAnnotationsToFile.writeAnnotations(to: url) { [weak self] (success, error) in
            if let self = self, let nserror = error as NSError? {
                self.view.show(error: nserror)
            }
        }
    }
    
    func onFilterAll() {
        imageModelListFilter = imageModelListFilterBuilder.createAllImageFilter(output: self)
        imageModelListFilter.filter(imageModelList: imageModelList)
    }
    
    func onFilterMarked() {
        imageModelListFilter = imageModelListFilterBuilder.createMarkedImageFilter(output: self)
        imageModelListFilter.filter(imageModelList: imageModelList)
    }
    
    func onFilterNotMarked() {
        imageModelListFilter = imageModelListFilterBuilder.createNotMarkedImageFilter(output: self)
        imageModelListFilter.filter(imageModelList: imageModelList)
    }
    
}

extension ImageAnnotatingPresenter: LabelListDidChangeOutput {
    
    func labelListDidChange(newList: [String]) {
        view.set(labelList: newList)
        
        var selectedLabel: String? = newList.first
        if let label = self.selectedLabel, newList.contains(label) {
            selectedLabel = label
        }
        view.set(selectedLabel: selectedLabel)
        self.selectedLabel = selectedLabel
    }
    
}

extension ImageAnnotatingPresenter: AnnotationListDidChangeOutput {
    
    func annotationDidChange(forImage imageModel: ImageModelProtocol) {
        let index = imageModelList.firstIndex { $0.imageURL == imageModel.imageURL }!
        imageModelList[index] = imageModel
        imageModelListFilter.filter(imageModelList: imageModelList)
    }
    
}

extension ImageAnnotatingPresenter: ImageModelListFilterOutput {
    
    func didFilter(imageModelList list: [ImageModelProtocol]) {
        if currentImageIndex > -1 {
            currentImageIndex = list.firstIndex { $0.imageURL == filteredModelList[currentImageIndex].imageURL } ?? 0
        } else {
            currentImageIndex = 0
        }
        
        filteredModelList = list
        
        view.show(imageThumbnails: filteredModelList)
        updateNavigationButtonsState()
        
        if filteredModelList.count > 0 {
            fetchAnnotationAndShow(url: filteredModelList[currentImageIndex].imageURL)
        } else {
            currentImageIndex = -1
            view.clearEditor()
        }
    }
    
}

extension ImageAnnotatingPresenter {
    
    private func updateNavigationButtonsState() {
        view.setNavigationBack(enabled: currentImageIndex > 0)
        view.setNavigationForward(enabled: currentImageIndex < filteredModelList.count - 1)
    }
    
    private func fetchAnnotationAndShow(url: URL) {
        let selectionRect = fetchSelectionForImage.selectionRectInImageCoordinatesFor(imageURL: url)
        view.showInEditor(imageURL: url, selectionFrameInImageCoordinates: selectionRect)
        router.setWindow(title: url.lastPathComponent)
    }
    
    private func updateApplyButtonEnabledState() {
        let enabled = selectionMade && selectedLabel != nil && currentImageIndex >= 0
        view.setApplySelection(enabled: enabled)
    }
    
}

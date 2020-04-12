import XCTest
@testable import ImageMarkTool

class ImageMarkToolTests: XCTestCase {

    var presenter: ImageAnnotatingPresenter!
    var view: ImageAnnotatingViewSpy!
    var router: RouterSpy!
    
    var openFolderStub: OpenFolderStub!
    var fetchSelectionForImageStub: FetchSelectionForImageStub!
    var clearSelectionStub: ClearSelectionStub!
    var applySelectionStub: ApplySelectionStub!
    var imageModelListFilterBuilderMock: ImageModelListFilterBuilderMock!
    
    var stubURL: URL!
    
    override func setUpWithError() throws {
        
        stubURL = URL(string: "https://stubURL/someFolder")
        
        presenter = ImageAnnotatingPresenter()
        view = ImageAnnotatingViewSpy()
        router = RouterSpy()
        
        presenter.view = view
        
        
        // Open folder stub
        openFolderStub = OpenFolderStub()
        openFolderStub.imageModels = [createImageModel(), createImageModel()]
        presenter.openFolder = openFolderStub
        
        // Fetch Selection stub
        fetchSelectionForImageStub = FetchSelectionForImageStub()
        presenter.fetchSelectionForImage = fetchSelectionForImageStub
        
        // Clear Selection Stub
        clearSelectionStub = ClearSelectionStub()
        presenter.clearSelection = clearSelectionStub
        
        // Apply SelectionStub
        applySelectionStub = ApplySelectionStub()
        presenter.applySelectionToImage = applySelectionStub
        
        // Filter
        imageModelListFilterBuilderMock = ImageModelListFilterBuilderMock()
        presenter.imageModelListFilterBuilder = imageModelListFilterBuilderMock
        
        presenter.router = router
        
    }

    func test_setViewDefaults_onVewDidLoad() {
        presenter.onViewDidLoad()
        
        XCTAssertEqual(1, view.numberOfSetNavigationBackEnabledCalls)
        XCTAssertEqual(1, view.numberOfSetNavigationForwardEnabledCalls)
        XCTAssertEqual(1, view.numberOfSetClearSelectionEnabledCalls)
        XCTAssertEqual(1, view.numberOfSetApplySelectionEnabledCalls)
        
        XCTAssertFalse(view.navigationBackEnabled)
        XCTAssertFalse(view.navigationForwardEnabled)
        XCTAssertFalse(view.clearSelectionEnabled)
        XCTAssertFalse(view.applySelectionEnabled)
    }
    
    func test_showImages_whenOpenFolder() {
        presenter.onOpenFolder(url: stubURL)
        
        XCTAssertEqual(1, view.numberOfShowImaheURLsCalls)
        XCTAssertEqual(openFolderStub.imageModels.map{$0.imageURL}, view.showImageURLs)
    }
    
    func test_showImageInEditor_whenOpenFolder() {
        presenter.onOpenFolder(url: stubURL)
        
        XCTAssertEqual(1, view.numberOfShowInEditorImageURLCalls)
        XCTAssertEqual(openFolderStub.imageModels.first!.imageURL, view.showInEditorImageURL!)
    }
    
    func test_setViewState_whenOpenFolder() {
        presenter.onOpenFolder(url: stubURL)
        
        XCTAssertEqual(1, view.numberOfSetNavigationForwardEnabledCalls)
        XCTAssertEqual(1, view.numberOfSetNavigationBackEnabledCalls)
        
        XCTAssertTrue(view.navigationForwardEnabled)
        XCTAssertFalse(view.navigationBackEnabled)
        XCTAssertFalse(view.clearSelectionEnabled)
        XCTAssertFalse(view.applySelectionEnabled)
    }
    
    func test_setViewState_whenOpenEmptyFolder() {
        openFolderStub.returnEmpty = true
        presenter.onOpenFolder(url: stubURL)
        
        XCTAssertEqual(1, view.numberOfSetNavigationForwardEnabledCalls)
        XCTAssertEqual(1, view.numberOfSetNavigationBackEnabledCalls)
        
        XCTAssertFalse(view.navigationForwardEnabled)
        XCTAssertFalse(view.navigationBackEnabled)
        XCTAssertFalse(view.clearSelectionEnabled)
        XCTAssertFalse(view.applySelectionEnabled)
    }
    
    // navigation
    
    func test_switchToNext_whenPressNext() {
        presenter.onOpenFolder(url: stubURL)
        
        presenter.onPressNext()
        XCTAssertEqual(openFolderStub.imageModels[1].imageURL, view.showInEditorImageURL)
    }
    
    func test_switchToNext_activatesBackButton() {
        presenter.onOpenFolder(url: stubURL)
        presenter.onPressNext()
        
        XCTAssertTrue(view.navigationBackEnabled)
    }
    
    func test_nextDisabled_whenSwitchToLastImage() {
        presenter.onOpenFolder(url: stubURL)
        for _ in 0..<openFolderStub.imageModels.count - 1 {
            presenter.onPressNext()
        }
        
        XCTAssertFalse(view.navigationForwardEnabled)
        XCTAssertTrue(view.navigationBackEnabled)
    }
    
    func test_displayPrevImage_whenPressNavigationPrevious() {
        presenter.onOpenFolder(url: stubURL)
        presenter.onPressNext()
        presenter.onPressPrevious()
        
        XCTAssertEqual(view.showInEditorImageURL, openFolderStub.imageModels.first!.imageURL)
    }
    
    func test_backDisabled_whenOnFirstImage() {
        presenter.onOpenFolder(url: stubURL)
        presenter.onPressNext()
        presenter.onPressPrevious()
        
        XCTAssertTrue(view.navigationForwardEnabled)
        XCTAssertFalse(view.navigationBackEnabled)
    }
    
    func test_showImage_whenUserSelectFromThums() {
        presenter.onOpenFolder(url: stubURL)
        presenter.onPressImageThumb(url: openFolderStub.imageModels.last!.imageURL)
        
        XCTAssertEqual(openFolderStub.imageModels.last!.imageURL, view.showInEditorImageURL!)
        XCTAssertFalse(view.navigationForwardEnabled)
        XCTAssertTrue(view.navigationBackEnabled)
        
        presenter.onPressImageThumb(url: openFolderStub.imageModels.first!.imageURL)
        XCTAssertEqual(openFolderStub.imageModels.first!.imageURL, view.showInEditorImageURL!)
        XCTAssertFalse(view.navigationBackEnabled)
        XCTAssertTrue(view.navigationForwardEnabled)
    }
    
    func test_setImageNameAsWindowTitle_whenOpenFolder() {
        presenter.onOpenFolder(url: stubURL)
        
        XCTAssertEqual(1, router.numberOfSetWindowTitleCalls)
        XCTAssertEqual(openFolderStub.imageModels[0].imageURL.lastPathComponent, router.windowTitle)
        
        presenter.onPressNext()
        XCTAssertEqual(2, router.numberOfSetWindowTitleCalls)
        XCTAssertEqual(openFolderStub.imageModels[1].imageURL.lastPathComponent, router.windowTitle)
        
        presenter.onPressPrevious()
        XCTAssertEqual(3, router.numberOfSetWindowTitleCalls)
        XCTAssertEqual(openFolderStub.imageModels[0].imageURL.lastPathComponent, router.windowTitle)
        
        presenter.onPressImageThumb(url: openFolderStub.imageModels[1].imageURL)
        XCTAssertEqual(4, router.numberOfSetWindowTitleCalls)
        XCTAssertEqual(openFolderStub.imageModels[1].imageURL.lastPathComponent, router.windowTitle)
    }
    
    func test_applyEnabled_whenSelectionmadeAndAnnotationSelected() {
        presenter.onOpenFolder(url: stubURL)
        XCTAssertFalse(view.applySelectionEnabled)
        
        presenter.labelListDidChange(newList: ["A"])
        presenter.onSelect(label:"B")
        XCTAssertFalse(view.applySelectionEnabled)
        
        presenter.onCreateSelection()
        XCTAssertTrue(view.applySelectionEnabled)
    }
    
    // Label list
    
    func test_setEmptyLabelList_whenViewDidLoad() {
        presenter.onViewDidLoad()
        
        XCTAssertEqual(1, view.numberOfSetLabelListCalls)
        XCTAssertEqual([], view.labelList)
    }
    
    func test_resetCurrentLabel_whenViewDidLoad() {
        presenter.onViewDidLoad()
        
        XCTAssertEqual(1, view.numberOfSetSelectedLabelCalls)
        XCTAssertNil(view.selectedLabel)
    }
    
    func test_updateLabelList_whenLabelItemAdded() {
        presenter.labelListDidChange(newList: ["A"])

        XCTAssertEqual(1, view.numberOfSetLabelListCalls)
    }
    
    func test_resetSelection_whenLabelListChangedToEmpty() {
        presenter.labelListDidChange(newList: [])
        
        XCTAssertEqual(1, view.numberOfSetSelectedLabelCalls)
        XCTAssertNil(view.selectedLabel)
    }
    
    func test_setFirstItemFromLabelListAsSelectedLabel_whenUpdateLabelList_withNoSelectedLabel() {
        presenter.labelListDidChange(newList: ["A", "B"])

        XCTAssertEqual(1, view.numberOfSetSelectedLabelCalls)
        XCTAssertEqual("A", view.selectedLabel)
        
        presenter.onOpenFolder(url: stubURL)
        presenter.onApply(selectionCoordinates: NSRect.zero)
        XCTAssertEqual("A", applySelectionStub.labelToApply)
    }
    
    func test_persistsAutomaticallySelectedLabel_whenLabelListDidChange_withSelectedLabelInNewLabelList() {
        presenter.labelListDidChange(newList: ["A", "B"])
        presenter.labelListDidChange(newList: ["A", "B", "C"])
        
        XCTAssertEqual(2, view.numberOfSetSelectedLabelCalls)
        XCTAssertEqual("A", view.selectedLabel)
        
        presenter.onOpenFolder(url: stubURL)
        presenter.onApply(selectionCoordinates: NSRect.zero)
        XCTAssertEqual("A", applySelectionStub.labelToApply)
    }
    
    func test_persistsManuallySelectedLabel_whenLabelListDidChange_withSelectedLabelInNewLabelList() {
        presenter.labelListDidChange(newList: ["A", "B"])
        presenter.onSelect(label: "B")
        presenter.labelListDidChange(newList: ["A", "B", "C"])
        
        XCTAssertEqual(2, view.numberOfSetSelectedLabelCalls)
        XCTAssertEqual("B", view.selectedLabel)
        
        presenter.onOpenFolder(url: stubURL)
        presenter.onApply(selectionCoordinates: NSRect.zero)
        XCTAssertEqual("B", applySelectionStub.labelToApply)
    }
    
    func test_selectFirstLabelFromList_onLabelListDidChange_withAutomaticallySelectedLabelNotInNewList() {
        presenter.labelListDidChange(newList: ["A", "B"])
        presenter.labelListDidChange(newList: ["B", "C"])
        
        XCTAssertEqual(2, view.numberOfSetSelectedLabelCalls)
        XCTAssertEqual("B", view.selectedLabel)
        
        presenter.onOpenFolder(url: stubURL)
        presenter.onApply(selectionCoordinates: NSRect.zero)
        XCTAssertEqual("B", applySelectionStub.labelToApply)
    }
    
    func test_selectFirstLabelFromList_onLabelListDidChange_withManuallySelectedLabelNotInNewList() {
        presenter.labelListDidChange(newList: ["A", "B", "C"])
        presenter.onSelect(label: "B")
        presenter.labelListDidChange(newList: ["A", "C"])
        
        XCTAssertEqual(2, view.numberOfSetSelectedLabelCalls)
        XCTAssertEqual("A", view.selectedLabel)
        
        presenter.onOpenFolder(url: stubURL)
        presenter.onApply(selectionCoordinates: NSRect.zero)
        XCTAssertEqual("A", applySelectionStub.labelToApply)
    }
    
    // clear button
    
    func test_clearEnabled_whenSelectionmade() {
        presenter.onCreateSelection()
        
        XCTAssertEqual(1, view.numberOfSetClearSelectionEnabledCalls)
        XCTAssertTrue(view.clearSelectionEnabled)
    }
    
    func test_clearDisabled_whenSelectionDeleted() {
        presenter.onCreateSelection()
        presenter.onRemoveSelection()
        
        XCTAssertEqual(2, view.numberOfSetClearSelectionEnabledCalls)
        XCTAssertFalse(view.clearSelectionEnabled)
    }
    
    func test_clear_whenPressClear() {
        presenter.onOpenFolder(url: stubURL)
        presenter.onPressClearSelection()
        
        XCTAssertEqual(1, clearSelectionStub.numberOfClearSelectionCalls)
        XCTAssertEqual(1, view.numberOfClearSelectionCalls)
    }
    
    // Actions
    
    func test_openFileDialog_whenTriggerOpenFileMenu() {
        presenter.onPressOpenFolder()
        
        XCTAssertEqual(1, router.numberOfOpenFolderDialogCalls)
    }
    
    func test_openManageLabels_whenPressManageLabels() {
        presenter.onPressManageLabels()
        
        XCTAssertEqual(1, router.numberOfManageLabelsCalls)
    }
    
    func test_openSaveDialog_whenSelectSaveMenuItem() {
        presenter.onPressSave()
        
        XCTAssertEqual(1, router.numberOfShowSaveFileDialogCalls)
    }
    
    func test_serealizeAnnotationList_whenSelectSaveFileURL() {
        let writeToFile = WriteToFileSuccessMock()
        presenter.writeAnnotationsToFile = writeToFile
        let url = URL(fileURLWithPath: "abs/file.txt")
        presenter.onSaveDialogSelect(url: url)
        
        XCTAssertEqual(1, writeToFile.numberOfWriteAnnotationCalls)
        XCTAssertEqual(0, view.numberOfShowErrorCalls)
    }
    
    func test_showError_whenWriteToFaileFail() {
        let writeToFile = WriteToFileFailMock()
        presenter.writeAnnotationsToFile = writeToFile
        let url = URL(fileURLWithPath: "abs/file.txt")
        presenter.onSaveDialogSelect(url: url)
        
        XCTAssertEqual(1, writeToFile.numberOfWriteAnnotationCalls)
        XCTAssertEqual(1, view.numberOfShowErrorCalls)
    }
    
    func test_ApplySelection_onApply() {
        presenter.onOpenFolder(url: stubURL)
        
        let label = "A"
        let coordinates = NSRect(x: 10, y: 10, width: 5, height: 4)
        
        presenter.onSelect(label: label)
        presenter.onApply(selectionCoordinates: coordinates)
        
        XCTAssertEqual(1, applySelectionStub.numberOfApplySelectionCalls)
        XCTAssertEqual(label, applySelectionStub.labelToApply)
        XCTAssertEqual(coordinates, applySelectionStub.coordinatesToApply)
    }
    
    func test_updateImageThumb_whenAnnotationChange() {
        presenter.onOpenFolder(url: stubURL)
        
        presenter.annotationDidChange(forImage: openFolderStub.imageModels.first!)
        
        XCTAssertEqual(2, view.numberOfShowImaheURLsCalls)
    }
    
    // Filter control
    
    func test_filterDisabled_onViewDidLoad() {
        presenter.onViewDidLoad()
        
        XCTAssertEqual(1, view.numberOfSetFilterEnabledCalls)
        XCTAssertFalse(view.isFilterEnabled)
    }
    
    func test_filterDisabled_whenOpenEmptyFolder() {
        openFolderStub.imageModels = []
        presenter.onOpenFolder(url: stubURL)
        
        XCTAssertEqual(1, view.numberOfSetFilterEnabledCalls)
        XCTAssertFalse(view.isFilterEnabled)
    }

    func test_filterEnabled_whenOpenNotEmptyFolder() {
        presenter.onOpenFolder(url: stubURL)
        
        XCTAssertEqual(1, view.numberOfSetFilterEnabledCalls)
        XCTAssertTrue(view.isFilterEnabled)
    }
    
    func test_filterAll_whenSelectFilterAll() {
        openFolderStub.imageModels = [createImageModel(isTagged: true), createImageModel(isTagged: false), createImageModel(isTagged: true), createImageModel(isTagged: false)]
        presenter.onOpenFolder(url: stubURL)
        presenter.onFilterAll()
        
        XCTAssertEqual(2, imageModelListFilterBuilderMock.numberOfCreateAllFilterCalls)
        XCTAssertEqual(1, imageModelListFilterBuilderMock.filter.numberOfFilterCalls)
    }
    
    func test_filterMarked_whenSelectFilterMarked() {
        openFolderStub.imageModels = [createImageModel(isTagged: true), createImageModel(isTagged: false), createImageModel(isTagged: true), createImageModel(isTagged: false)]
        presenter.onOpenFolder(url: stubURL)
        presenter.onFilterMarked()
        
        XCTAssertEqual(1, imageModelListFilterBuilderMock.numberOfCreateMarkedFilterCalls)
        XCTAssertEqual(1, imageModelListFilterBuilderMock.filter.numberOfFilterCalls)
    }
    
    func test_filterNotMarked_whenSelectFilterNotmarked() {
        openFolderStub.imageModels = [createImageModel(isTagged: true), createImageModel(isTagged: false), createImageModel(isTagged: true), createImageModel(isTagged: false)]
        presenter.onOpenFolder(url: stubURL)
        presenter.onFilterNotMarked()
        
        XCTAssertEqual(1, imageModelListFilterBuilderMock.numberOfCreateNotMockedFilterCalls)
        XCTAssertEqual(1, imageModelListFilterBuilderMock.filter.numberOfFilterCalls)
    }
    
    func test_selectFilterAll_whenOpenFolder() {
        openFolderStub.imageModels = [createImageModel(isTagged: true), createImageModel(isTagged: false), createImageModel(isTagged: true)]
        presenter.onOpenFolder(url: stubURL)
        
        XCTAssertEqual(1, view.numberOfSelectFilterShowAllCalls)
        XCTAssertEqual(1, view.numberOfShowImaheURLsCalls)
        XCTAssertEqual(openFolderStub.imageModels.map{$0.imageURL}, view.showImageURLs)
    }
    
    func test_showImages_onFilterResult() {
        openFolderStub.imageModels = [createImageModel(isTagged: true), createImageModel(isTagged: false), createImageModel(isTagged: true)]
        let filteredImages = [openFolderStub.imageModels[0], openFolderStub.imageModels[2]]
        presenter.onOpenFolder(url: stubURL)
        presenter.didFilter(imageModelList: filteredImages)
        
        XCTAssertEqual(2, view.numberOfShowImaheURLsCalls)
        XCTAssertEqual(filteredImages.map{$0.imageURL}, view.showImageURLs)
    }
    
    func test_showEmptyAndClearEditor_whenFilterResultEmpty() {
        openFolderStub.imageModels = [createImageModel(isTagged: false), createImageModel(isTagged: false), createImageModel(isTagged: false)]
        presenter.onOpenFolder(url: stubURL)
        presenter.didFilter(imageModelList: [])
        
        XCTAssertEqual(2, view.numberOfShowImaheURLsCalls)
        XCTAssertEqual([], view.showImageURLs)
        XCTAssertEqual(1, view.numberOfClearEditorCalls)
    }
    
    func test_keepCurrentSelectedImage_whenFilterResultContainsSelectedImage() {
        openFolderStub.imageModels = [createImageModel(isTagged: true), createImageModel(isTagged: false), createImageModel(isTagged: true), createImageModel(isTagged: false)]
        let filteredImages = [openFolderStub.imageModels[0], openFolderStub.imageModels[2]]
        let selectedTaggedImageURL = filteredImages.last!.imageURL
        presenter.onOpenFolder(url: stubURL)
        presenter.onPressImageThumb(url: selectedTaggedImageURL)
        presenter.didFilter(imageModelList: filteredImages)
        
        XCTAssertEqual(3, view.numberOfShowInEditorImageURLCalls)
        XCTAssertEqual(selectedTaggedImageURL, view.showInEditorImageURL)
    }
    
    func test_disableNextnavButton_whenFilterSelected_withCurrentSelectedImageIsLastAmongFiltered() {
        openFolderStub.imageModels = [createImageModel(isTagged: true), createImageModel(isTagged: false), createImageModel(isTagged: true), createImageModel(isTagged: false)]
        let filteredImages = [openFolderStub.imageModels[0], openFolderStub.imageModels[2]]
        let selectedTaggedImageURL = openFolderStub.imageModels[2].imageURL
        presenter.onOpenFolder(url: stubURL)
        presenter.onPressImageThumb(url: selectedTaggedImageURL)
        presenter.didFilter(imageModelList: filteredImages)
        
        XCTAssertEqual(3, view.numberOfSetNavigationForwardEnabledCalls)
        XCTAssertFalse(view.navigationForwardEnabled)
        XCTAssertTrue(view.navigationBackEnabled)
    }
    
    func test_disablePrevButton_whenFilterSelect_withCurrentSelectedImageIsFirstAmongFiltered() {
        openFolderStub.imageModels = [createImageModel(isTagged: true), createImageModel(isTagged: false), createImageModel(isTagged: true), createImageModel(isTagged: false)]
        let filteredImages = [openFolderStub.imageModels[0], openFolderStub.imageModels[2]]
        let selectedTaggedImageURL = openFolderStub.imageModels[0].imageURL
        presenter.onOpenFolder(url: stubURL)
        presenter.onPressImageThumb(url: selectedTaggedImageURL)
        presenter.didFilter(imageModelList: filteredImages)
        
        XCTAssertEqual(3, view.numberOfSetNavigationBackEnabledCalls)
        XCTAssertTrue(view.navigationForwardEnabled)
        XCTAssertFalse(view.navigationBackEnabled)
    }
    
    func test_disableAllNavigationButtons_whenSelectFilter_withOnlyOneItemInFilterd() {
        openFolderStub.imageModels = [createImageModel(isTagged: true), createImageModel(isTagged: false)]
        let filteredImages = [openFolderStub.imageModels[0]]
        presenter.onOpenFolder(url: stubURL)
        presenter.didFilter(imageModelList: filteredImages)
        
        XCTAssertEqual(2, view.numberOfSetNavigationBackEnabledCalls)
        XCTAssertFalse(view.navigationForwardEnabled)
        XCTAssertFalse(view.navigationBackEnabled)
    }
    
    func test_showFirstFromFiltered_whenCurrentImageIsNotInFilterResult() {
        openFolderStub.imageModels = [createImageModel(isTagged: true), createImageModel(isTagged: false), createImageModel(isTagged: true)]
        let filteredImages = [openFolderStub.imageModels[0], openFolderStub.imageModels[2]]
        let selectedImageURL = openFolderStub.imageModels[1].imageURL
        presenter.onOpenFolder(url: stubURL)
        presenter.onPressImageThumb(url: selectedImageURL)
        presenter.didFilter(imageModelList: filteredImages)
        
        XCTAssertEqual(3, view.numberOfShowInEditorImageURLCalls)
        XCTAssertEqual(openFolderStub.imageModels.filter{$0.label != nil}.first!.imageURL, view.showInEditorImageURL)
    }
    
    func test_navigationInFilteredList() {
        openFolderStub.imageModels = [createImageModel(isTagged: true), createImageModel(isTagged: false), createImageModel(isTagged: true)]
        let filteredImages = [openFolderStub.imageModels[0], openFolderStub.imageModels[2]]
        presenter.onOpenFolder(url: stubURL)
        presenter.didFilter(imageModelList: filteredImages)
        presenter.onPressNext()
        
        XCTAssertEqual(3, view.numberOfShowInEditorImageURLCalls)
        XCTAssertEqual(openFolderStub.imageModels.last!.imageURL, view.showInEditorImageURL)
        
        presenter.onPressPrevious()
        XCTAssertEqual(4, view.numberOfShowInEditorImageURLCalls)
        XCTAssertEqual(openFolderStub.imageModels.first!.imageURL, view.showInEditorImageURL)
    }
    
    func test_removeImageFromList_whenMarkImage_withFilteredNotMarkedImages() {
        let allImages = [createImageModel(isTagged: false), createImageModel(isTagged: false), createImageModel(isTagged: true)]
        var filteredImages = [allImages[0], allImages[1]]
        
        openFolderStub.imageModels = allImages
        imageModelListFilterBuilderMock.filter.resultImageModelList = allImages
        
        presenter.onOpenFolder(url: stubURL)
        imageModelListFilterBuilderMock.filter.resultImageModelList = filteredImages
        presenter.onFilterNotMarked()

        fetchSelectionForImageStub.selectedRect = NSRect.zero
        filteredImages = [allImages[1]]
        imageModelListFilterBuilderMock.filter.resultImageModelList = filteredImages
        
        let imageModel = ImageModel(imageURL: allImages.first!.imageURL, label: "A")
        presenter.annotationDidChange(forImage: imageModel)
        
        XCTAssertEqual(filteredImages.first!.imageURL, view.showInEditorImageURL)
        XCTAssertEqual(filteredImages.map{$0.imageURL}, view.showImageURLs)
        XCTAssertFalse(view.navigationBackEnabled)
        XCTAssertFalse(view.navigationForwardEnabled)
    }
    
    func test_showEmptyListAndClearEditingWindow_whenAfterMarkFilteredListEmpty() {
        let allImages = [createImageModel(isTagged: false), createImageModel(isTagged: true), createImageModel(isTagged: true)]
        var filteredImages = [allImages[0]]
        
        openFolderStub.imageModels = allImages
        imageModelListFilterBuilderMock.filter.resultImageModelList = allImages
        
        presenter.onOpenFolder(url: stubURL)
        imageModelListFilterBuilderMock.filter.resultImageModelList = filteredImages
        presenter.onFilterNotMarked()

        fetchSelectionForImageStub.selectedRect = NSRect.zero
        filteredImages = []
        imageModelListFilterBuilderMock.filter.resultImageModelList = filteredImages
        
        let imageModel = ImageModel(imageURL: allImages.first!.imageURL, label: "A")
        presenter.annotationDidChange(forImage: imageModel)
        
        XCTAssertEqual(1, view.numberOfClearEditorCalls)
        XCTAssertEqual([], view.showImageURLs)
        XCTAssertFalse(view.navigationBackEnabled)
        XCTAssertFalse(view.navigationForwardEnabled)
    }
    
    func test_switchBetweanEMptyAndFullImageList() {
        let allImages = [createImageModel(isTagged: false), createImageModel(isTagged: false), createImageModel(isTagged: false)]
        var filteredImages = [ImageModelProtocol]()
       
        openFolderStub.imageModels = allImages
        imageModelListFilterBuilderMock.filter.resultImageModelList = allImages
       
        presenter.onOpenFolder(url: stubURL)
        imageModelListFilterBuilderMock.filter.resultImageModelList = filteredImages
        presenter.onFilterMarked()

        XCTAssertEqual(1, view.numberOfClearEditorCalls)
        XCTAssertEqual([], view.showImageURLs)
        
        fetchSelectionForImageStub.selectedRect = NSRect.zero
        filteredImages = allImages
        imageModelListFilterBuilderMock.filter.resultImageModelList = filteredImages
       
        presenter.onFilterAll()
       
        XCTAssertEqual(3, view.numberOfShowImaheURLsCalls)
        XCTAssertEqual(allImages.first!.imageURL, view.showInEditorImageURL)
    }
    
}

class ImageAnnotatingViewSpy: ImageAnnotatingView {
    
    public var numberOfSetNavigationBackEnabledCalls = 0
    public var numberOfSetNavigationForwardEnabledCalls = 0
    public var numberOfSetClearSelectionEnabledCalls = 0
    public var numberOfSetApplySelectionEnabledCalls = 0
    public var numberOfShowImaheURLsCalls = 0
    public var numberOfShowInEditorImageURLCalls = 0
    public var numberOfInstallSeelctionCalls = 0
    public var numberOfSetLabelListCalls = 0
    public var numberOfClearSelectionCalls = 0
    public var numberOfUpdateThumbCalls = 0
    public var numberOfShowErrorCalls = 0
    public var numberOfSetFilterEnabledCalls = 0
    public var numberOfSelectFilterShowAllCalls = 0
    public var numberOfClearEditorCalls = 0
    public var numberOfSetSelectedLabelCalls = 0
    
    public var showInEditorCoordinatesArgument: NSRect?
    public var labelList = [String]()
    
    public var navigationBackEnabled = false
    public var navigationForwardEnabled = false
    public var clearSelectionEnabled = false
    public var applySelectionEnabled = false
    public var showImageURLs = [URL]()
    public var showInEditorImageURL: URL? = nil
    public var isFilterEnabled = false
    public var selectedLabel: String?
    
    func setNavigationBack(enabled: Bool) {
        numberOfSetNavigationBackEnabledCalls += 1
        navigationBackEnabled = enabled
    }
    
    func setNavigationForward(enabled: Bool) {
        numberOfSetNavigationForwardEnabledCalls += 1
        navigationForwardEnabled = enabled
    }
    
    func setClearSelection(enabled: Bool) {
        numberOfSetClearSelectionEnabledCalls += 1
        clearSelectionEnabled = enabled
    }
    
    func setApplySelection(enabled: Bool) {
        numberOfSetApplySelectionEnabledCalls += 1
        applySelectionEnabled = enabled
    }
    
    func show(imageThumbnails: [ImageModelProtocol]) {
        numberOfShowImaheURLsCalls += 1
        showImageURLs = imageThumbnails.map{ $0.imageURL }
    }
    
    func showInEditor(imageURL: URL, selectionFrameInImageCoordinates: NSRect?) {
        numberOfShowInEditorImageURLCalls += 1
        showInEditorImageURL = imageURL
        showInEditorCoordinatesArgument = selectionFrameInImageCoordinates
    }
    
    func set(labelList: [String]) {
        numberOfSetLabelListCalls += 1
        self.labelList = labelList
    }
    
    func clearSelection() {
        numberOfClearSelectionCalls += 1
    }
    
    func show(error: NSError) {
        numberOfShowErrorCalls += 1
    }
    
    func setFilter(enabled: Bool) {
        numberOfSetFilterEnabledCalls += 1
        isFilterEnabled = enabled
    }
    
    func selectFilterShowAll() {
        numberOfSelectFilterShowAllCalls += 1
    }
    
    func clearEditor() {
        numberOfClearEditorCalls += 1
    }
    
    func set(selectedLabel: String?) {
        numberOfSetSelectedLabelCalls += 1
        self.selectedLabel = selectedLabel
    }
}

class RouterSpy: ImageAnnotatingRouting {
    
    public var numberOfCreateSelectionViewCalls = 0
    public var numberOfOpenFolderDialogCalls = 0
    public var numberOfManageLabelsCalls = 0
    public var numberOfShowSaveFileDialogCalls = 0
    public var numberOfSetWindowTitleCalls = 0
    
    public var windowTitle: String?
    
    func showOpenFolderDialog() {
        numberOfOpenFolderDialogCalls += 1
    }
    
    func showSaveFileDialog() {
        numberOfShowSaveFileDialogCalls += 1
    }
    
    func showManageLabels() {
        numberOfManageLabelsCalls += 1
    }
    
    func createMainViewController() -> NSViewController {
        return NSViewController()
    }
    
    func setWindow(title: String) {
        numberOfSetWindowTitleCalls += 1
        windowTitle = title
    }
}

class WriteToFileSuccessMock: DataWritterProtocol {
    
    var numberOfWriteAnnotationCalls = 0
    
    func writeAnnotations(to fileURL: URL, completion: @escaping FinishBlock) {
        numberOfWriteAnnotationCalls += 1
        completion(true, nil)
    }
    
}

class WriteToFileFailMock: DataWritterProtocol {
    
    var numberOfWriteAnnotationCalls = 0
    
    func writeAnnotations(to fileURL: URL, completion: @escaping FinishBlock) {
        numberOfWriteAnnotationCalls += 1
        completion(false, NSError(domain: "test", code: -1, userInfo: nil))
    }
    
}

class OpenFolderStub: OpenFolderProtocol {
    
    var numberOfOpenFolderCalls = 0
    var imageModels: [ImageModelProtocol]!
    
    var returnEmpty = false
    
    func openFolder(url: URL) -> [ImageModelProtocol] {
        return returnEmpty ? [] : imageModels
    }
    
}

class FetchSelectionForImageStub: FetchSelectionForImageProtocol {
    
    var selectedRect: NSRect?
    var numberOfSelectionRectInImageCoordinatesCalls = 0
    
    func selectionRectInImageCoordinatesFor(imageURL: URL) -> NSRect? {
        numberOfSelectionRectInImageCoordinatesCalls += 1
        return selectedRect
    }
    
}

class ClearSelectionStub: ClearSelectionProtocol {
    
    var numberOfClearSelectionCalls = 0
    
    func clearSelection(imageURL: URL) {
        numberOfClearSelectionCalls += 1
    }
    
}

class ApplySelectionStub: ApplySelectionToImageProtocol {
    
    var numberOfApplySelectionCalls = 0
    var coordinatesToApply: NSRect?
    var imageToApply: URL!
    var labelToApply: String!
    
    func applySelection(inImageCoordinates: NSRect, to imageURL: URL, label: String) {
        numberOfApplySelectionCalls += 1
        
        coordinatesToApply = inImageCoordinates
        imageToApply = imageURL
        labelToApply = label
    }
    
}

class ImageModelListFilterBuilderMock: ImageModelListFilterBuilderProtocol {
    
    var filter = ImageModelListFilterMock()
    var numberOfCreateAllFilterCalls = 0
    var numberOfCreateMarkedFilterCalls = 0
    var numberOfCreateNotMockedFilterCalls = 0
    
    func createAllImageFilter(output: ImageModelListFilterOutput) -> ImageModelListFilterProtocol {
        numberOfCreateAllFilterCalls += 1
        filter.output = output
        return filter
    }
    
    func createMarkedImageFilter(output: ImageModelListFilterOutput) -> ImageModelListFilterProtocol {
        numberOfCreateMarkedFilterCalls += 1
        filter.output = output
        return filter
    }
    
    func createNotMarkedImageFilter(output: ImageModelListFilterOutput) -> ImageModelListFilterProtocol {
        numberOfCreateNotMockedFilterCalls += 1
        filter.output = output
        return filter
    }
    
}

class ImageModelListFilterMock: ImageModelListFilterProtocol {
    
    var numberOfFilterCalls = 0
    var resultImageModelList = [ImageModelProtocol]()
    var output: ImageModelListFilterOutput!
    
    func filter(imageModelList: [ImageModelProtocol]) {
        numberOfFilterCalls += 1
        output.didFilter(imageModelList: resultImageModelList)
    }
    
}

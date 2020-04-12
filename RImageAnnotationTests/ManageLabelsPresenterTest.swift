import XCTest
@testable import ImageMarkTool

class ManageLabelsPresenterTest: XCTestCase {

    var presenter: ManageLabelsPresenter!
    var view: ManageLabelsViewMock!
    var router: RouterMock!
    var addLabel: AddLabelMock!
    var removeLabel: RemoveLabelMock!
    var labelList: LabelListMock!
    
    override func setUpWithError() throws {
        
        presenter = ManageLabelsPresenter()
        
        view = ManageLabelsViewMock()
        presenter.view = view
        
        router = RouterMock()
        presenter.router = router
        
        addLabel = AddLabelMock()
        presenter.addLabel = addLabel
        
        removeLabel = RemoveLabelMock()
        presenter.removeLabel = removeLabel
        
        labelList = LabelListMock()
        presenter.labelList = labelList
        
    }
    
    func test_showLabelList_onViewDidLoad() {
        labelList.labelListToReturn = ["A", "B"]
        presenter.onViewDidLoad()
        
        XCTAssertEqual(1, labelList.numberOfLabelListCalls)
        XCTAssertEqual(1, view.numberOfShowLabelListCalls)
        XCTAssertEqual(labelList.labelListToReturn, view.labelList)
    }
    
    func test_disableRemoveButton_onViewDidLoad() {
        presenter.onViewDidLoad()
        
        XCTAssertEqual(1, view.numberOfSetRemoveEnabledCalls)
        XCTAssertFalse(view.isRemoveEnabled)
    }
    
    func test_showDialog_whenPressAddLabel() {
        presenter.onAddLabel()
        
        XCTAssertEqual(1, view.numberOfShowEnterLabelDialogCalls)
    }
    
    func test_addLabel_whenConfirmAdd() {
        presenter.onConfirmAdd(label: "Z")
        
        XCTAssertEqual(1, addLabel.numberOfAddLabelCalls)
        XCTAssertEqual("Z", addLabel.label)
    }
    
    func test_removeLabel_whenPressRemoveLabel() {
        presenter.onRemove(label: "X")
        
        XCTAssertEqual(1, removeLabel.numberOfRemoveLabelCalls)
        XCTAssertEqual("X", removeLabel.label)
    }
    
    func test_enableRemove_whenLabelSelected() {
        presenter.onLabel(selected: true)
        XCTAssertEqual(1, view.numberOfSetRemoveEnabledCalls)
        XCTAssertTrue(view.isRemoveEnabled)
        
        presenter.onLabel(selected: false)
        XCTAssertEqual(2, view.numberOfSetRemoveEnabledCalls)
        XCTAssertFalse(view.isRemoveEnabled)
    }
    
    func test_close_whenPressClose() {
        presenter.onClose()
        
        XCTAssertEqual(1, router.numberOfCloseManagelabelsCalls)
    }
    
    func test_showLabelList_whenLabelListChanged() {
        let list = ["A", "B", "C"]
        presenter.labelListDidChange(newList: list)
        
        XCTAssertEqual(1, view.numberOfShowLabelListCalls)
        XCTAssertEqual(list, view.labelList)
    }

}

class ManageLabelsViewMock: ManageLabelsViewProtocol {
    
    var numberOfShowLabelListCalls = 0
    var numberOfShowEnterLabelDialogCalls = 0
    var numberOfSetRemoveEnabledCalls = 0
    
    var labelList: [String]?
    var isRemoveEnabled = false
    
    func show(labelList: [String]) {
        numberOfShowLabelListCalls += 1
        self.labelList = labelList
    }
    
    func showEnterLabelDialog() { // <-- move to router
        numberOfShowEnterLabelDialogCalls += 1
    }
    
    func setRemove(enabled: Bool) {
        numberOfSetRemoveEnabledCalls += 1
        isRemoveEnabled = enabled
    }
    
}

class AddLabelMock: AddLabelProtocol {
    
    var numberOfAddLabelCalls = 0
    var label: String?
    
    func add(label: String) {
        numberOfAddLabelCalls += 1
        self.label = label
    }
    
}

class RemoveLabelMock: RemoveLabelProtocol {
    
    var numberOfRemoveLabelCalls = 0
    var label: String?
    
    func remove(label: String) {
        numberOfRemoveLabelCalls += 1
        self.label = label
    }
    
}

class LabelListMock: LabelListProtocol {
    
    var labelListToReturn = [String]()
    var numberOfLabelListCalls = 0
    
    func labelList() -> [String] {
        numberOfLabelListCalls += 1
        return labelListToReturn
    }
    
}

class RouterMock: ManageLabelsRouting {
    
    var numberOfCloseManagelabelsCalls = 0
    
    func showManageLabels(parentViewController: NSViewController) {
        
    }
    
    func closeManageLabels() {
        numberOfCloseManagelabelsCalls += 1
    }
    
}


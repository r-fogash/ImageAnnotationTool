import Foundation

class ManageLabelsPresenter {
    
    public weak var view: ManageLabelsViewProtocol!
    public var router: ManageLabelsRouting!
    public var addLabel: AddLabelProtocol!
    public var removeLabel: RemoveLabelProtocol!
    public var labelList: LabelListProtocol!
    public var labelListChanged: LabelListDidChangeProtocol!
    
}

extension ManageLabelsPresenter: ManageLabelsPresenterProtocol {
    
    func onViewDidLoad() {
        view.show(labelList: labelList.labelList())
        view.setRemove(enabled: false)
    }
    
    func onAddLabel() {
        view.showEnterLabelDialog()
    }
    
    func onConfirmAdd(label: String) {
        addLabel.add(label: label)
    }
    
    func onRemove(label: String) {
        removeLabel.remove(label: label)
    }
    
    func onLabel(selected: Bool) {
        view.setRemove(enabled: selected)
    }
    
    func onClose() {
        router.closeManageLabels()
    }
    
}

extension ManageLabelsPresenter: LabelListDidChangeOutput {
    
    func labelListDidChange(newList: [String]) {
        view.show(labelList: newList)
    }
    
}


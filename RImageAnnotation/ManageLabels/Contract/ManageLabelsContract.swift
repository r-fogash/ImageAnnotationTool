import AppKit


public protocol ManageLabelsViewProtocol: class {
    
    func show(labelList: [String])
    func showEnterLabelDialog()
    func setRemove(enabled: Bool)
    
}


protocol ManageLabelsPresenterProtocol {
    
    func onViewDidLoad()
    func onAddLabel()
    func onConfirmAdd(label: String)
    func onRemove(label: String)
    func onLabel(selected: Bool)
    func onClose()
    
}


protocol ManageLabelsRouting {
    
    func showManageLabels(parentViewController: NSViewController)
    func closeManageLabels()
    
}

// Usecases

// Add

protocol AddLabelProtocol {
    
    func add(label: String)
    
}

// Remove

protocol RemoveLabelProtocol {
    
    func remove(label: String)
    
}

// Fetch List

protocol LabelListProtocol {
        
    func labelList() -> [String]
    
}

// List did change

protocol LabelListDidChangeProtocol {
    
}

protocol LabelListDidChangeOutput: class {
    
    func labelListDidChange(newList: [String])
    
}

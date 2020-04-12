import Cocoa

class ManageLabelsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet var tableView: NSTableView!
    @IBOutlet var removeButton: NSButton!
    @IBOutlet var addButton: NSButton!
    
    public var presenter: ManageLabelsPresenterProtocol!
    
    private var labelList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        tableView.intercellSpacing = NSSize.zero
    }
    
    //MARK: NSTableViewDataSource
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return labelList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier("LabelLlistTextCell")
        let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as! LabelLlistTextCell
        cell.setText(labelList[row])
        return cell
    }
    
    //MARK: NSTableViewDelegate
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        presenter.onLabel(selected: tableView.selectedRow >= 0)
    }
    
    //MARK: IBOutler
    
    @IBAction func addLabel(_ sender: NSButton) {
        presenter.onAddLabel()
    }
    
    @IBAction func removeLabel(_ sender: NSButton) {
        presenter.onRemove(label: labelList[tableView.selectedRow])
    }
    
    @IBAction func close(_ sender: NSButton) {
        presenter.onClose()
    }
    
}

extension ManageLabelsViewController: ManageLabelsViewProtocol {
    
    func show(labelList: [String]) {
        self.labelList = labelList
        tableView.reloadData()
    }
    
    func showEnterLabelDialog() {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "Enter label name"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        
        let textField = NSTextField(frame: CGRect(x: 10, y: 20, width: 300, height: 20))
        textField.placeholderString = "Enter label name"
        
        alert.accessoryView = textField
        let result = alert.runModal()
        
        guard result == .alertFirstButtonReturn else {
            return
        }
        guard textField.stringValue.count > 0 else {
            return
        }
        
        presenter.onConfirmAdd(label: textField.stringValue)
    }
    
    func setRemove(enabled: Bool) {
        removeButton.isEnabled = enabled
    }
    
}

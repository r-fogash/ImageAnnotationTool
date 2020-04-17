import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var imageView: SelectableImageView!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var labelListButton: NSComboBox!
    @IBOutlet var applyButton: NSButton!
    @IBOutlet var navigationBackButton: NSButton!
    @IBOutlet var navigationForwardButton: NSButton!
    @IBOutlet var clearSelectionButton: NSButton!
    @IBOutlet var filterSegmentControl: NSSegmentedControl!
    
    public var presenter: ImageAnnotatingPresentation!
    
    let imageColumnIdentifier = NSUserInterfaceItemIdentifier(rawValue: "image_column")
    let imageTitleColumnIdentifier = NSUserInterfaceItemIdentifier(rawValue: "image_title_column")
    
    let imageCellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ImageTableCellView")
    let imageTitleCellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ImageTitleTableCellView")
    
    var imageThumbnails = [ImageModelProtocol]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.delegate = self
        
        let imagePreviewColumnIndex = tableView.column(withIdentifier: imageColumnIdentifier)
        tableView.tableColumns[imagePreviewColumnIndex].headerCell.title = "Preview"
        tableView.tableColumns[imagePreviewColumnIndex].headerCell.alignment = .center
        
        let imageTitleColumnIndex = tableView.column(withIdentifier: imageTitleColumnIdentifier)
        tableView.tableColumns[imageTitleColumnIndex].headerCell.title = "Title"
        tableView.tableColumns[imageTitleColumnIndex].headerCell.alignment = .center
        
        presenter.onViewDidLoad()
    }
    
    //MARK: - IBActions -
    
    @IBAction func apply(_ send: NSButton) {
        presenter.onApply(selectionCoordinates: imageView.selectionFrameInImageCoordinates())
    }
    
    @IBAction func clear(_ sender: NSButton) {
        presenter.onPressClearSelection()
    }
    
    @IBAction func next(_ sender: NSButton) {
        presenter.onPressNext()
    }
    
    @IBAction func prev(_ sender: NSButton) {
        presenter.onPressPrevious()
    }
    
    @IBAction func openFolder(_ sender: AnyObject) {
        presenter.onPressOpenFolder()
    }
    
    @IBAction func showManageLabels(_ sender: AnyObject) {
        presenter.onPressManageLabels()
    }
    
    @IBAction func saveLabelList(_ sender: AnyObject) {
        presenter.onPressSave()
    }
    
    @IBAction func onSelectDropDown(_ sender: NSComboBox) {
        if sender.indexOfSelectedItem == -1 {
            presenter.onSelect(label: nil)
        } else {
            presenter.onSelect(label: sender.objectValues[sender.indexOfSelectedItem] as? String)
        }
    }
    
    @IBAction func onFilterSelect(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            presenter.onFilterAll()
        }
        if sender.selectedSegment == 1 {
            presenter.onFilterMarked()
        }
        if sender.selectedSegment == 2 {
            presenter.onFilterNotMarked()
        }
    }
    
    // need this method to prevent cursor reset when dragging
    override func cursorUpdate(with event: NSEvent)
    { }
    
}

//MARK: - NSTableViewDataSource

extension ViewController: NSTableViewDataSource {
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return imageThumbnails.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn else { return nil }
        
        if (column.identifier == imageColumnIdentifier) {
            let cell = tableView.makeView(withIdentifier: imageCellIdentifier, owner: nil) as! ImageTableCellView
            cell.configure(imageModel: imageThumbnails[row])
            return cell
        }
        else if (column.identifier == imageTitleColumnIdentifier) {
            let cell = tableView.makeView(withIdentifier: imageTitleCellIdentifier, owner: nil) as! ImageTitleTableCellView
            cell.configure(imageModel: imageThumbnails[row])
            return cell
        }
        return nil
    }
}

// MARK: - NSTableViewDelegate

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        guard row != -1 else { return }
        
        presenter.onPressImageThumb(url:imageThumbnails[row].imageURL)
    }
    
}

// MARK: - SelectableImageViewDelegate

extension ViewController: SelectableImageViewDelegate {
    
    func didCreateSelectionView() {
        presenter.onCreateSelection()
    }
    
    func didRemoveSelectionView() {
        presenter.onRemoveSelection()
    }
    
}

// MARK: - ImageAnnotatingView

extension ViewController: ImageAnnotatingView {
    
    func setNavigationBack(enabled: Bool) {
        navigationBackButton.isEnabled = enabled
    }
    
    func setNavigationForward(enabled: Bool) {
        navigationForwardButton.isEnabled = enabled
    }
    
    func setClearSelection(enabled: Bool) {
        clearSelectionButton.isEnabled = enabled
    }
    
    func setApplySelection(enabled: Bool) {
        applyButton.isEnabled = enabled
    }
    
    func show(imageThumbnails: [ImageModelProtocol]) {
        self.imageThumbnails = imageThumbnails
        tableView.reloadData()
    }
    
    func showInEditor(imageURL: URL, selectionFrameInImageCoordinates: NSRect?) {
        imageView.set(imageURL: imageURL, selectionFrameInImageCoordinates: selectionFrameInImageCoordinates)
        let index = imageThumbnails.firstIndex { $0.imageURL == imageURL }!
        tableView.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
    }
    
    func installSelection(frame: NSRect) {
        imageView.createSelection(frame: frame)
    }
    
    func set(labelList: [String]) {
        labelListButton.removeAllItems()
        labelListButton.addItems(withObjectValues: labelList)
    }
    
    func set(selectedLabel: String?) {
        labelListButton.selectItem(withObjectValue: selectedLabel)
        labelListButton.stringValue = selectedLabel ?? ""
    }
    
    func clearSelection() {
        imageView.clearSelection()
    }
    
    func show(error: NSError) {
        let alert = NSAlert(error: error)
        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
    }
    
    func setFilter(enabled: Bool) {
        filterSegmentControl.isEnabled = enabled
    }
    
    func selectFilterShowAll() {
        filterSegmentControl.selectSegment(withTag: 0)
    }
    
    func clearEditor() {
        imageView.clear()
    }
}


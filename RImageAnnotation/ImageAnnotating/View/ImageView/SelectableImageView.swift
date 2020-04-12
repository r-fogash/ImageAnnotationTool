import AppKit


protocol SelectableImageViewDelegate: class {
    
    func didCreateSelectionView()
    func didRemoveSelectionView()
    
}

class SelectableImageView: NSImageView {
    private weak var selectionView: SelectionView?
    
    public var mouseController: MouseController!
    public weak var delegate: SelectableImageViewDelegate?
    public var imageURL: URL?
    public var coordinateTransform = CoordinateTransform()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMouseTracking()
        setupMouseController()
    }
    
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        guard let _ = imageURL else { return }
        
        mouseController.mouseMoved(location: location(event: event))
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        guard let _ = imageURL else { return }
        
        mouseController.mouseDown(location: location(event: event))
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        guard let _ = imageURL else { return }
        
        mouseController.mouseUp(location: location(event: event))
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        guard let _ = imageURL else { return }
        
        mouseController.mouseDragged(location: location(event: event))
    }
    
    override func layout() {
        super.layout()
            
        selectionView?.rectangleConstraint = bounds
    }
    
    public func createSelection(frame: NSRect) {
        selectionView?.removeFromSuperview()
        
        let selectionViewBuilder = SelectionViewBuilder()
        let selectionView = selectionViewBuilder.createSelectionView(location: frame.origin) as! SelectionView
        
        selectionView.rectangleConstraint = bounds
        selectionView.frame = frame
        self.addSubview(selectionView)
        self.selectionView = selectionView
        
        delegate?.didCreateSelectionView()
    }
    
    public func selectionFrameInImageCoordinates() -> NSRect? {
        guard let image = imageURL else {
            return nil
        }
        guard let selectionView = self.selectionView else {
            return nil
        }
        return coordinateTransform.convertToImageCoordinates(selectionInContainerCoordinates: selectionView.frame, containerFrame: bounds, image: image)
    }
    
    public func set(imageURL: URL, selectionFrameInImageCoordinates: NSRect?) {
        if let _ = self.selectionView {
            removeSelectionView()
        }
        
        let data = try! Data(contentsOf: imageURL)
        image = NSImage(dataIgnoringOrientation: data)
        self.imageURL = imageURL
        
        let containerFrame = bounds
        if  let coordinates = selectionFrameInImageCoordinates,
            let frame = coordinateTransform.convertToContainerCoordinates(selectionInImageCoordinates: coordinates, containerFrame: containerFrame, image: imageURL) {
                createSelection(frame: frame)
        }
    }
    
    public func clear() {
        if let _ = self.selectionView {
            removeSelectionView()
        }
        
        imageURL = nil
        image = nil
    }
    
    public func clearSelection() {
        removeSelectionView()
    }
    
    override func setFrameSize(_ newSize: NSSize) {
        var selectionCoordinates: NSRect?
        
        if let selectionView = self.selectionView, let image = imageURL {
            selectionCoordinates = coordinateTransform.convertToImageCoordinates(selectionInContainerCoordinates: selectionView.frame, containerFrame: bounds, image: image)
        }
        
        super.setFrameSize(newSize)
        
        if let coordinates = selectionCoordinates,
            let selectionView = self.selectionView,
            let image = imageURL,
            let selectionFrame = coordinateTransform.convertToContainerCoordinates(selectionInImageCoordinates: coordinates, containerFrame: NSRect(origin: bounds.origin, size: newSize), image: image) {
                selectionView.frame = selectionFrame
        }
    }
    
}

extension SelectableImageView: MouseControllerDelegate {
    
    func createSelectionView(location: CGPoint) -> SelectionViewProtocol {
        selectionView?.removeFromSuperview()
        
        let selectionViewBuilder = SelectionViewBuilder()
        let selectionView = selectionViewBuilder.createSelectionView(location: location) as! SelectionView
        
        selectionView.rectangleConstraint = bounds
        self.addSubview(selectionView)
        self.selectionView = selectionView
        
        delegate?.didCreateSelectionView()
        
        return selectionView
    }
    
    func removeSelectionView() {
        self.selectionView?.removeFromSuperview()
        
        delegate?.didRemoveSelectionView()
    }
    
}

extension SelectableImageView {
    
    private func setupMouseTracking() {
        let trackingOptions: NSTrackingArea.Options = [NSTrackingArea.Options.activeAlways, NSTrackingArea.Options.inVisibleRect, NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.mouseMoved]
        let area = NSTrackingArea(rect: frame, options: trackingOptions, owner: self, userInfo: nil)
        self.addTrackingArea(area)
    }
    
    private func setupMouseController() {
        mouseController = MouseController()
        mouseController.delegate = self
        mouseController.mouseCursor = MouseCursor()
    }
    
    private func location(event: NSEvent) -> NSPoint {
        return convert(event.locationInWindow, from: nil)
    }
    
}

import Cocoa

protocol MouseControllerDelegate: class {
    
    func createSelectionView(location: CGPoint) -> SelectionViewProtocol
    func removeSelectionView()
    
}

class MouseController {
    
    public weak var delegate: MouseControllerDelegate?
    public var mouseCursor: MouseCursorProtocol!
    public private(set) weak var selectionContainerView: NSView?
    
    public weak var selectionView: SelectionViewProtocol?
    
    public func mouseDown(location: CGPoint) {
        if let selectionView = self.selectionView {
            
            if selectionView.leftAnchorRect.contains(location) || selectionView.rightAnchorRect.contains(location) {
                selectionView.beginResizeWidth(mouseLocation: location)
                return
            }
            if selectionView.topAnchorRect.contains(location) || selectionView.bottomAnchorRect.contains(location) {
                selectionView.beginResizeHeight(mouseLocation: location)
                return
            }
            if (selectionView.viewRect.contains(location)) {
                selectionView.beginDrag(mouseLocation: location)
                return
            }
            delegate?.removeSelectionView()
        }
        self.selectionView = delegate?.createSelectionView(location: location)
    }
    
    public func mouseMoved(location: CGPoint) {
        updateMouseCursor(location: location)
    }
    
    public func mouseDragged(location: CGPoint) {
        guard let selectionView = selectionView else {
            return
        }
        selectionView.handleDrag(mouseLocation: location)
    }
    
    public func mouseUp(location: CGPoint) {
        mouseCursor.setDefault()
        if selectionView?.viewRect.size == NSSize.zero {
            self.delegate?.removeSelectionView()
        }
    }
    
}

extension MouseController {
    
    private func updateMouseCursor(location: CGPoint) {
        guard let selectionView = self.selectionView else {
            return
        }
        
        if selectionView.leftAnchorRect.contains(location) || selectionView.rightAnchorRect.contains(location) {
            mouseCursor.setResizeHorizontal()
        }
        else if selectionView.topAnchorRect.contains(location) || selectionView.bottomAnchorRect.contains(location) {
            mouseCursor.setResizeVertical()
        }
        else if selectionView.viewRect.contains(location) {
            mouseCursor.setDragging()
        }
        else {
            resetMouseCursorToDefault()
        }
    }
    
    private func resetMouseCursorToDefault() {
        if NSCursor.current != NSCursor.arrow {
            NSCursor.arrow.set()
        }
    }
}


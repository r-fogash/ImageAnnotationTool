import Cocoa

class MouseCursor: MouseCursorProtocol {
    
    func setResizeHorizontal() {
        NSCursor.resizeLeftRight.set()
    }
    
    func setResizeVertical() {
        NSCursor.resizeUpDown.set()
    }
    
    func setDragging() {
        NSCursor.openHand.set()
    }
    
    func setDefault() {
        
    }
    
}

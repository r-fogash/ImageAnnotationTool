import Cocoa

class SelectionView: NSView, SelectionViewProtocol {
    
    private enum ViewEventType {
        case initialSizing
        case moving
        case resizeLeftRight
        case resizeUpDown
    }
    
    private var previousLocation: CGPoint!
    private var eventType: ViewEventType!
    public var rectangleConstraint: CGRect?
    private let tValue: CGFloat = 3
    
    init(atLocation location: CGPoint) {
        super.init(frame: CGRect(x: location.x, y: location.y, width: 0, height: 0))
        self.previousLocation = location;
        self.eventType = .initialSizing
        self.configureView()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        if (self.layer == nil) {
            self.layer = CALayer()
        }
        
        self.layer!.backgroundColor = NSColor(named: "selectionViewBackground")!.cgColor
        self.layer!.borderWidth = 2
        self.layer!.borderColor = NSColor(named: "selectionViewBorder")!.cgColor
    }
    
    public func handleDrag(mouseLocation: CGPoint) {
        
        switch eventType! {
            case .initialSizing :
                resizeView(mouseLocation: mouseLocation)
            case .moving:
                dragView(mouseLocation: mouseLocation)
            case .resizeLeftRight:
                resizeWidth(mouseLocation: mouseLocation)
            case .resizeUpDown:
                resizeHeight(mouseLocation: mouseLocation)
        }
    }
    
    private func resizeView(mouseLocation: CGPoint) {
        let normalizedLocation = normalizeMouseLocation(mouseLocation)
        
        let originX = frame.minX
        let originY = frame.minY
        let width = frame.width
        let heigh = frame.height
        
        let (newX, newWidth) = newMetricsFor(previousLocation: previousLocation.x, location: normalizedLocation.x, origin: originX, sideSize: width)
        let (newY, newHeight) = newMetricsFor(previousLocation: previousLocation.y, location: normalizedLocation.y, origin: originY, sideSize: heigh)
        
        frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        previousLocation = normalizedLocation
    }
    
    private func newMetricsFor(previousLocation: CGFloat, location: CGFloat, origin: CGFloat, sideSize: CGFloat) -> (newOrigin: CGFloat, newSideSize: CGFloat) {
        
        var newOrigin = origin
        var newSideSize = sideSize
        
        if (previousLocation == origin + sideSize) {
            if (location > origin) {
                newSideSize = location - origin
                newOrigin = origin
            } else {
                newSideSize = sideSize + (origin - location)
                newOrigin = location
            }
        } else {
            if (location > origin) {
                newSideSize = sideSize - (location - origin)
                newOrigin = location
            } else {
                newSideSize = sideSize + (origin - location)
                newOrigin = location
            }
        }
        
        return (newOrigin, newSideSize)
    }
    
    private func dragView(mouseLocation: CGPoint) {
        
        let normalizedLocation = self.normalizeMouseLocation(mouseLocation)
        
        let deltaX = normalizedLocation.x - previousLocation.x
        let deltaY = normalizedLocation.y - previousLocation.y
        
        var newX = frame.origin.x + deltaX
        var newY = frame.origin.y + deltaY
        
        let width = frame.width
        let height = frame.height
        
        if let rectangle = self.rectangleConstraint {
            if newX < rectangle.minX { newX = rectangle.minX }
            if newX + width > rectangle.maxX { newX = rectangle.maxX - width }
            if newY < rectangle.minY { newY = rectangle.minY }
            if newY + height > rectangle.maxY { newY = rectangle.maxY - height }
        }
        
        self.previousLocation = normalizedLocation
        self.frame = CGRect(x: newX, y: newY, width: width, height: height)
    }
    
    private func normalizeMouseLocation(_ location: CGPoint) -> CGPoint {
        var normalizedLocation = location
        guard let rectangle = self.rectangleConstraint else { return normalizedLocation }
        
        if !rectangle.contains(location) {
            var newX = location.x
            var newY = location.y
            
            if location.x >= rectangle.maxX - 1 { newX = rectangle.maxX - 1 }
            if location.x < rectangle.minX { newX = rectangle.minX }
            if location.y >= rectangle.maxY - 1 { newY = rectangle.maxY - 1 }
            if location.y < rectangle.minY { newY = rectangle.minY }
            
            normalizedLocation = CGPoint(x: newX, y: newY)
        }
        return normalizedLocation;
    }
    
    private func resizeWidth(mouseLocation: CGPoint) {
        let deltaX = mouseLocation.x - previousLocation.x
        
        if leftAnchorRect.contains(previousLocation) {
            frame = CGRect(x: frame.minX + deltaX, y: frame.minY, width: frame.width - deltaX, height: frame.height)
        } else {
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width + deltaX, height: frame.height)
        }
        
        previousLocation = mouseLocation
    }
    
    private func resizeHeight(mouseLocation: CGPoint) {
        let deltaY = mouseLocation.y - previousLocation.y
        
        if topAnchorRect.contains(previousLocation) {
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height + deltaY)
        } else {
            frame = CGRect(x: frame.minX, y: frame.minY + deltaY, width: frame.width, height: frame.height - deltaY)
        }
        
        previousLocation = mouseLocation
    }
    
    public func beginDrag(mouseLocation: CGPoint) {
        eventType = .moving
        previousLocation = mouseLocation
    }
    
    public func beginResizeWidth(mouseLocation: CGPoint) {
        eventType = .resizeLeftRight
        previousLocation = mouseLocation
    }
    
    public func beginResizeHeight(mouseLocation: CGPoint) {
        eventType = .resizeUpDown
        previousLocation = mouseLocation
    }
    
    public func remove() {
        removeFromSuperview()
    }
    
    var leftAnchorRect: CGRect {
        get { CGRect(x: frame.minX - tValue, y: frame.minY, width: tValue * 2, height: frame.height) }
    }
    
    var topAnchorRect: CGRect {
        get { CGRect(x: frame.minX, y: frame.maxY - tValue, width: frame.width, height: tValue * 2) }
    }
    
    var rightAnchorRect: CGRect {
        get { CGRect(x: frame.maxX - tValue, y: frame.minY, width: tValue * 2, height: frame.height) }
    }
    
    var bottomAnchorRect: CGRect {
        get { CGRect(x: frame.minX, y: frame.minY - tValue, width: frame.width, height: tValue * 2) }
    }
    
    var viewRect: NSRect {
        return frame
    }
}

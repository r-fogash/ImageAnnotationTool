import XCTest
@testable import RImageAnnotation

class MouseControllerTests: XCTestCase {

    var mouseController: MouseController!
    var selectionViewMock: SelectionViewMock!
    var mouseCursor: MouseCursorMock!
    var mouseControllerDelegate: MouseControllerDelegateSpy!
    
    override func setUpWithError() throws {
        mouseController = MouseController()
        mouseCursor = MouseCursorMock()
        mouseControllerDelegate = MouseControllerDelegateSpy()
        
        mouseController.mouseCursor = mouseCursor
        mouseController.delegate = mouseControllerDelegate
    }

    func test_createSelectionView_whenMouseDownFirstTime() {
        mouseController.mouseDown(location: CGPoint.zero)
        
        XCTAssertEqual(1, mouseControllerDelegate.numberOfCreateSelectionViewCalls)
    }
    
    func test_beginDragging_whenMouseDownInsideSelectionView() {
        mouseController.mouseDown(location: CGPoint.zero)
        mouseController.mouseUp(location: CGPoint.zero)
        mouseController.mouseDown(location: NSPoint(x: 50, y: 50))
        
        XCTAssertEqual(1, mouseControllerDelegate.selectionView.numberOfBeginDraggingCalls)
    }
    
    func test_beginResizeWidth_whenMouseDownLeftEdge() {
        mouseController.mouseDown(location: CGPoint.zero)
        mouseController.mouseUp(location: CGPoint.zero)
        mouseController.mouseDown(location: NSPoint(x: 1, y: 10))
        
        XCTAssertEqual(1, mouseControllerDelegate.selectionView.numberOfBeginResizeWidthCalls)
    }
    
    func test_beginResizeWidth_whenMouseDownRightEdge() {
        mouseController.mouseDown(location: CGPoint.zero)
        mouseController.mouseUp(location: CGPoint.zero)
        mouseController.mouseDown(location: NSPoint(x: 100-1, y: 10))
        
        XCTAssertEqual(1, mouseControllerDelegate.selectionView.numberOfBeginResizeWidthCalls)
    }
    
    func test_beginResizeHeight_whenMouseDownTopEdge() {
        mouseController.mouseDown(location: CGPoint.zero)
        mouseController.mouseUp(location: CGPoint.zero)
        mouseController.mouseDown(location: NSPoint(x: 10, y: 1))
        
        XCTAssertEqual(1, mouseControllerDelegate.selectionView.numberOfBeginResizeHeightCalls)
    }

    func test_beginResizeHeight_whenMouseDownBottomEdge() {
        mouseController.mouseDown(location: CGPoint.zero)
        mouseController.mouseUp(location: CGPoint.zero)
        mouseController.mouseDown(location: NSPoint(x: 10, y: 100 - 1))
        
        XCTAssertEqual(1, mouseControllerDelegate.selectionView.numberOfBeginResizeHeightCalls)
    }
    
    func test_removeSelectionView_whenPressOutsideSelection() {
        mouseController.mouseDown(location: CGPoint.zero)
        mouseController.mouseUp(location: CGPoint.zero)
        mouseController.mouseDown(location: NSPoint(x: 200, y: 200))
        
        XCTAssertEqual(1, mouseControllerDelegate.numberOfRemoveSelectionViewCalls)
    }
    
    // Test mouse move
    func test_setResizingWidth_whenMoveOverLeftEdge() {
        mouseController.mouseDown(location: CGPoint.zero)
        mouseController.mouseUp(location: CGPoint.zero)
        mouseController.mouseMoved(location: CGPoint(x: 1, y: 10))
        
        XCTAssertEqual(1, mouseCursor.numberOfSetResizeHorizontalCalls)
    }
    
    func test_setResizingWidth_whenMoveOverRightEdge() {
        mouseController.mouseDown(location: CGPoint.zero)
        mouseController.mouseUp(location: CGPoint.zero)
        mouseController.mouseMoved(location: CGPoint(x: 100-1, y: 10))
        
        XCTAssertEqual(1, mouseCursor.numberOfSetResizeHorizontalCalls)
    }
    
    func test_setResizingVertical_whenMoveOverTopEdge() {
        mouseController.mouseDown(location: CGPoint.zero)
        mouseController.mouseUp(location: CGPoint.zero)
        mouseController.mouseMoved(location: CGPoint(x: 10, y: 1))
        
        XCTAssertEqual(1, mouseCursor.numberOfSetResizeVerticalCalls)
    }
    
    func test_setResizingVertical_whenMoveOverBottomEdge() {
        mouseController.mouseDown(location: CGPoint.zero)
        mouseController.mouseUp(location: CGPoint.zero)
        mouseController.mouseMoved(location: CGPoint(x: 10, y: 100-1))
        
        XCTAssertEqual(1, mouseCursor.numberOfSetResizeVerticalCalls)
    }
    
    // test drag
    func test_selectionHandleMouseDrag_whenMouseDownInsideView() {
        mouseController.mouseDown(location: CGPoint.zero)
        mouseController.mouseUp(location: CGPoint.zero)
        mouseController.mouseDown(location: CGPoint(x: 10, y: 10))
        mouseController.mouseDragged(location: CGPoint(x: 15, y: 15))
        
        XCTAssertEqual(1, mouseControllerDelegate.selectionView.numberOfHandleMouseDragCalls)
    }
    
    func test_setDefaultCursor_whenMouseUp() {
        mouseController.mouseDown(location: CGPoint.zero)
        mouseController.mouseUp(location: CGPoint.zero)
        
        XCTAssertEqual(1, mouseCursor.numberOfSetDefaultCalls)
    }
}


class SelectionViewMock: SelectionViewProtocol {
    
    public var numberOfBeginResizeWidthCalls = 0
    public var numberOfBeginResizeHeightCalls = 0
    public var numberOfBeginDraggingCalls = 0
    public var numberOfRemoveCalls = 0
    public var numberOfHandleMouseDragCalls = 0
    
    var leftAnchorRect: NSRect {
        return NSRect(x: 0, y: 4, width: 4, height: 100)
    }
    var rightAnchorRect: NSRect {
        return NSRect(x: 100 - 4, y: 4, width: 4, height: 100)
    }
    var topAnchorRect: NSRect {
        return NSRect(x: 4, y: 0, width: 100, height: 4)
    }
    var bottomAnchorRect: NSRect {
        return NSRect(x: 4, y: 100 - 4, width: 100, height: 4)
    }
    var viewRect: NSRect {
        return NSRect(x: 0, y: 0, width: 100, height: 100)
    }
    
    func beginResizeWidth(mouseLocation: NSPoint) {
        numberOfBeginResizeWidthCalls += 1
    }
    func beginResizeHeight(mouseLocation: NSPoint) {
        numberOfBeginResizeHeightCalls += 1
    }
    func beginDrag(mouseLocation: NSPoint) {
        numberOfBeginDraggingCalls += 1
    }
    func remove() {
        numberOfRemoveCalls += 1
    }
    func handleDrag(mouseLocation: NSPoint) {
        numberOfHandleMouseDragCalls += 1
    }
    
}

class MouseCursorMock: MouseCursorProtocol {
    
    public var numberOfSetResizeHorizontalCalls = 0
    public var numberOfSetResizeVerticalCalls = 0
    public var numberOfSetDraggingCalls = 0
    public var numberOfSetDefaultCalls = 0
    
    func setResizeHorizontal() {
        numberOfSetResizeHorizontalCalls += 1
    }
    
    func setResizeVertical() {
        numberOfSetResizeVerticalCalls += 1
    }
    
    func setDragging() {
        numberOfSetDraggingCalls += 1
    }
    
    func setDefault() {
        numberOfSetDefaultCalls += 1
    }
    
}

class MouseControllerDelegateSpy: MouseControllerDelegate {
    
    var selectionView = SelectionViewMock()
    
    var numberOfCreateSelectionViewCalls = 0
    var numberOfRemoveSelectionViewCalls = 0
    
    func createSelectionView(location: CGPoint) -> SelectionViewProtocol {
        numberOfCreateSelectionViewCalls += 1
        selectionView = SelectionViewMock()
        return selectionView
    }
    
    
    func removeSelectionView() {
        numberOfRemoveSelectionViewCalls += 1
    }
    
}

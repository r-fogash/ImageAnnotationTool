import XCTest

class LabelListDidChangeTests: XCTestCase {

    var session: ImageAnnotatingSession!
    var labelListDidChange: LabelListDidChange!
    
    var numberOfLabelListChangeCalls = 0
    var labelList: [String]?
    
    override func setUpWithError() throws {
        session = ImageAnnotatingSession()
        labelListDidChange = LabelListDidChange(imageAnnotatingSession: session)
        labelListDidChange.output = self
    }

    func test_callOutput_whenAddLabel() {
        session.add(label: "A")
        
        XCTAssertEqual(1, numberOfLabelListChangeCalls)
        XCTAssertEqual(["A"], labelList)
        
        session.add(label: "B")
        XCTAssertEqual(2, numberOfLabelListChangeCalls)
        XCTAssertEqual(["A", "B"], labelList)
    }
    
    func test_callOutput_whenRemoveFromLabelList() {
        let list = ["A", "b", "C", "D", "e"]
        list.forEach( session.add(label:) )
        
        session.remove(label: list.last!)
        XCTAssertEqual(list.count + 1, numberOfLabelListChangeCalls)
        XCTAssertEqual(Array(list.dropLast()), labelList)
    }

}

extension LabelListDidChangeTests: LabelListDidChangeOutput {
    
    func labelListDidChange(newList: [String]) {
        numberOfLabelListChangeCalls += 1
        labelList = newList
    }
    
}

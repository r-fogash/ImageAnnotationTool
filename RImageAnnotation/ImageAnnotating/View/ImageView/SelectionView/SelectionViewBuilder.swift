import Foundation

class SelectionViewBuilder: SelectionViewBuilderProtocol {
    
    func createSelectionView(location: NSPoint) -> SelectionViewProtocol {
        return SelectionView(atLocation: location)
    }
    
}

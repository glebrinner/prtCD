
import SwiftUI



class ViewForceReloader: ObservableObject {
    
    /// Just a property to modify to trigger the reload
    @Published private var forceReloadCount = 0
    
    /// Call this method to force a view to reload.
    func forceReload() {
        forceReloadCount += 1
    }
}

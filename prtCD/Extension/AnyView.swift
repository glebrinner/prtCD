

import SwiftUI


extension AnyView {
    
    static var emptyView: AnyView {
        AnyView(EmptyView())
    }
}


extension View {
    
    /// Flat view to `AnyView`.
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    func hidden(_ hidden: Bool) -> some View {
        hidden ? AnyView(EmptyView()) : AnyView(self)
    }
}

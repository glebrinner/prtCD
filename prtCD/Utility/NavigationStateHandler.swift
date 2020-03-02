

import Foundation



class NavigationStateHandler: ObservableObject {
    
    /// A flag to bind with `NavigationLink.isActive`.
    @Published var isPushed = false {
        didSet { state = isPushed ? .pushed : .popped }
    }
    
    /// The state of the navigation.
    private var state: State? = .none {
        didSet {
            switch state {
            case .pushed: onPushed?()
            case .popped: onPopped?()
            case .none: break
            }
        }
    }
    
    /// An action to perform when pushed.
    var onPushed: (() -> Void)?
    
    /// An action to perform when poped.
    var onPopped: (() -> Void)?
    
    func pop() {
        isPushed = false
    }
}


private extension NavigationStateHandler {
    
    enum State {
        case pushed
        case popped
    }
}

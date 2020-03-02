
import Foundation


class NotificationObserver: ObservableObject {
    
    var onReceived: ((Notification) -> Void)?
    
    
    init(name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(receivedNotification), name: name, object: nil)
    }
    
    
    @objc private func receivedNotification(_ notification: Notification) {
        onReceived?(notification)
    }
}

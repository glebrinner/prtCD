
import SwiftUI


extension Alert {
    
    static func createObjectWithoutCurrentStore(object: String) -> Alert {
        Alert(
            title: Text("Cannot Create \(object)"),
            message: Text("Please create or set a current store and try again."),
            dismissButton: Alert.Button.cancel(Text("Dismiss"))
        )
    }
}



import SwiftUI


struct DeleteAlertModifier: ViewModifier {
    
    @Binding var show: Bool
    
    var title: String
    
    var message: String?
    
    var action: () -> Void
    
    
    init(_ show: Binding<Bool>, title: String, message: String? = nil, action: @escaping () -> Void) {
        self._show = show
        self.title = title
        self.message = message
        self.action = action
    }
    
    
    func body(content: Content) -> some View {
        content.alert(isPresented: $show) {
            let titleText = Text(title)
            let messageText = message != nil ? Text(message!) : nil
            let delete = Alert.Button.destructive(Text("Delete"), action: action)
            return Alert(title: titleText, message: messageText, primaryButton: delete, secondaryButton: .cancel())
        }
    }
}

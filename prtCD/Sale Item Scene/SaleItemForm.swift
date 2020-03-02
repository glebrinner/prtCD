

import SwiftUI


struct SaleItemForm: View, MultiPurposeForm {
    
    @Binding var model: SaleItemFormModel
        
    var onCreate: (() -> Void)?
    
    var onUpdate: (() -> Void)?
    
    var onCancel: (() -> Void)?
    
    var enableCreate: Bool?
    
    var enableUpdate: Bool?
    
    var rowActions: [MultiPurposeFormRowAction] = []
    
    
    // MARK: - Body
    
    var body: some View {
        let form = Form {
            // MARK: Name & Price
            Section {
                VerticalTextField(text: $model.name, label: "name", placeholder: "Name")
                HStack {
                    Text("Price")
                    CurrencyTextField(text: $model.price)
                }
            }
            
            setupRowActionSection()
        }
        
        return setupNavItems(forForm: form.eraseToAnyView())
    }
}

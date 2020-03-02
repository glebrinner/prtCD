
import SwiftUI


extension Image {
    
    struct SFCustomer {}
    
    struct SFOrder {}
}


extension Image.SFCustomer {
    
    static let profile = Image(systemName: "person.crop.circle")
    
    static let organization = Image(systemName: "briefcase")
    
    static let phone = Image(systemName: "phone")
    
    static let email = Image(systemName: "paperplane")
    
    static let address = Image(systemName: "mappin.and.ellipse")
}


extension Image.SFOrder {
    
    static let orderDate = Image(systemName: "calendar")
    
    static let deliverDate = Image(systemName: "cube.box.fill")
    
    static let delivered = Image(systemName: "d.circle.fill")
    
    static let totalBeforeDiscount = Image(systemName: "plus.circle")
    
    static let totalAfterDiscount = Image(systemName: "equal.circle")
    
    static let discount = Image(systemName: "minus.circle")
    
    static let note = Image(systemName: "doc.text")
    
    static let addOrderItem = Image(systemName: "cart.badge.plus")
}

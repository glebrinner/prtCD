

import Foundation


struct CustomerFormModel {
    
    weak var customer: Customer?
    
    var familyName = "" {
        didSet { customer?.familyName = familyName.trimmed() }
    }
    
    var givenName = "" {
        didSet { customer?.givenName = givenName.trimmed() }
    }
    
    var organization = "" {
        didSet { customer?.organization = organization.trimmed() }
    }
    
    var address = "" {
        didSet { customer?.address = address.trimmed() }
    }
    
    var email = "" {
        didSet { customer?.email = email.trimmed().lowercased() }
    }
    
    var phone = "" {
        didSet { customer?.phone = phone.trimmed() }
    }
    
    
    init(customer: Customer? = nil) {
        guard let customer = customer else { return }
        self.customer = customer
        familyName = customer.familyName
        givenName = customer.givenName
        organization = customer.organization
        address = customer.address
        email = customer.email
        phone = customer.phone
    }
}

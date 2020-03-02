

import CoreData
import SwiftUI
import Combine


/// A customer of a store.
class Customer: NSManagedObject, ObjectValidatable {
    
    @NSManaged var familyName: String
    @NSManaged var givenName: String
    @NSManaged var organization: String
    @NSManaged var phone: String
    @NSManaged var email: String
    @NSManaged var address: String
    @NSManaged var orders: Set<Order>
    @NSManaged var store: Store?
    
    /// Customer's name or organization.
    var identity: String {
        let formatter = PersonNameComponentsFormatter()
        var components = PersonNameComponents()
        components.givenName = givenName
        components.familyName = familyName
        let identity = formatter.string(from: components)
        return identity.isEmpty ? organization : identity
    }
    
    
    override func willChangeValue(forKey key: String) {
        super.willChangeValue(forKey: key)
        objectWillChange.send()
    }
}


extension Customer {
    
    func isValid() -> Bool {
        hasValidInputs() && store != nil
    }
    
    func hasValidInputs() -> Bool {
        return !familyName.trimmed().isEmpty
            || !givenName.trimmed().isEmpty
            || !organization.trimmed().isEmpty
    }
    
    func hasChangedValues() -> Bool {
        hasPersistentChangedValues
    }
}


// MARK: - Fetch Request

extension Customer {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Customer> {
        return NSFetchRequest<Customer>(entityName: "Customer")
    }
    
    /// A request to fetch customers.
    /// - Parameter predicate: Customer's info to filter. Example name, email, or address.
    static func requestObjects(storeID: String, withInfo predicate: String = "") -> NSFetchRequest<Customer> {
        let request = Customer.fetchRequest() as NSFetchRequest<Customer>
        let storeUID = #keyPath(store.uniqueID)
        
        // fetch all objects when no predicate
        guard !predicate.isEmpty else {
            request.predicate = .init(storeID: storeID, keyPath: storeUID)
            request.sortDescriptors = []
            return request
        }
        
        // fetch all objects with predicate
        let matchInfoQuery = """
        \(#keyPath(familyName)) CONTAINS[c] %@ OR
        \(#keyPath(givenName)) CONTAINS[c] %@ OR
        \(#keyPath(organization)) CONTAINS[c] %@ OR
        \(#keyPath(phone)) CONTAINS[c] %@ OR
        \(#keyPath(email)) CONTAINS[c] %@ OR
        \(#keyPath(address)) CONTAINS[c] %@
        """
        
        let matchInfo = NSPredicate(format: matchInfoQuery, predicate, predicate, predicate, predicate, predicate, predicate)
        request.predicate = NSCompoundPredicate(storeID: storeID, keyPath: storeUID, and: [matchInfo])
        request.sortDescriptors = []
        
        return request
    }
    
    static func requestNoObject() -> NSFetchRequest<Customer> {
        let request = Customer.fetchRequest() as NSFetchRequest<Customer>
        request.predicate = .init(value: false)
        request.sortDescriptors = []
        return request
    }
}

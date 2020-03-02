
//

import CoreData
import CloudKit



class Store: NSManagedObject, ObjectValidatable {
    
    /// The owner's `CKRecord.ID`'s `recordName`.
    @NSManaged private(set) var ownerID: String
    @NSManaged private(set) var uniqueID: String
    @NSManaged var name: String
    @NSManaged var phone: String
    @NSManaged var email: String
    @NSManaged var address: String
    @NSManaged var saleItems: Set<SaleItem>
    @NSManaged var orders: Set<Order>
    @NSManaged var customers: Set<Customer>
    
    /// Check if it is the current store.
    var isCurrent: Bool {
        uniqueID == AppCache.currentStoreUniqueID
    }
    
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        uniqueID = UUID().uuidString
    }
    
    override func willChangeValue(forKey key: String) {
        super.willChangeValue(forKey: key)
        objectWillChange.send()
    }
    
    
    func setOwnerID(with recordID: CKRecord.ID) {
        guard recordID.zoneID.ownerName == CKCurrentUserDefaultName else { return }
        ownerID = recordID.recordName
    }
}


extension Store {
    
    func isValid() -> Bool {
        hasValidInputs() && !ownerID.isEmpty
    }
    
    func hasValidInputs() -> Bool {
        !name.isEmpty
    }
    
    func hasChangedValues() -> Bool {
        hasPersistentChangedValues
    }
}


extension Store {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store")
    }
    
    static func requestObjects() -> NSFetchRequest<Store> {
        let request = Store.fetchRequest() as NSFetchRequest<Store>
        request.predicate = .init(value: true)
        request.sortDescriptors = [.init(key: #keyPath(Store.name), ascending: true)]
        return request
    }
}


extension Store {
    
    static let kCurrentStoreDidChange = "Store.kCurrentStoreDidChange"
    

    /// - Parameter store: The store that will become current store.
    static func setCurrent(_ store: Store?) {
        let storeID = store?.uniqueID
        AppCache.currentStoreUniqueID = storeID
        NotificationCenter.default.post(name: .init(kCurrentStoreDidChange), object: storeID)
    }
    

    static func fetch(storeID: String, from context: NSManagedObjectContext) -> Store? {
        let request = Store.fetchRequest() as NSFetchRequest<Store>
        let storeUID = #keyPath(Store.uniqueID)
        request.predicate = .init(storeID: storeID, keyPath: storeUID)
        let results = try? context.fetch(request)
        return results?.first
    }
    
    static func current(from context: NSManagedObjectContext) -> Store? {
        guard let currentStoreID = AppCache.currentStoreUniqueID else { return nil }
        return fetch(storeID: currentStoreID, from: context)
    }
}

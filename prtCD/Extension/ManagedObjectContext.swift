

import CoreData


extension NSManagedObjectContext {
    
    func newChildContext(type: NSManagedObjectContextConcurrencyType = .mainQueueConcurrencyType, mergesChangesFromParent: Bool = true) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: type)
        context.parent = self
        context.automaticallyMergesChangesFromParent = mergesChangesFromParent
        return context
    }
    
    func quickSave() {
        guard hasChanges else { return }
        do {
            try save()
        } catch {
            fatalError("failed to save context with error: \(error)")
        }
    }
}


extension NSManagedObject {
    
    func get(from context: NSManagedObjectContext) -> Self {
        context.object(with: objectID) as! Self
    }
}

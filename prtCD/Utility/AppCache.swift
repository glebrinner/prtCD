
import Foundation
import CoreData


struct AppCache {
    
    typealias UbiquityIdentityToken = (NSCoding & NSCopying & NSObjectProtocol)
    
    
    @UserDefaultsOptionalValue(forKey: "AppCache.kUbiquityIdentityToken", default: nil)
    static var ubiquityIdentityToken: UbiquityIdentityToken?
    
    @UserDefaultsOptionalValue(forKey: "AppCache.kCurrentStoreUniqueID", default: nil)
    static var currentStoreUniqueID: String?
}

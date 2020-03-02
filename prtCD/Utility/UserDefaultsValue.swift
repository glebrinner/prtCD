

import Foundation


// MARK: - Non Optional Value

@propertyWrapper
struct UserDefaultsValue<T> {
    
    let key: String
    
    let defaultValue: T
    
    var wrappedValue: T {
        set { UserDefaults.standard.set(newValue, forKey: key) }
        get { UserDefaults.standard.value(forKey: key) as? T ?? defaultValue }
    }
    
    
    init(forKey key: String, default value: T) {
        self.key = key
        self.defaultValue = value
    }
}


// MARK: - Optional Value

@propertyWrapper
struct UserDefaultsOptionalValue<T> {
    
    let key: String
    
    let defaultValue: T?
    
    var wrappedValue: T? {
        set { UserDefaults.standard.set(newValue, forKey: key) }
        get { UserDefaults.standard.value(forKey: key) as? T}
    }
    
    
    init(forKey key: String, default value: T?) {
        self.key = key
        self.defaultValue = value
    }
}

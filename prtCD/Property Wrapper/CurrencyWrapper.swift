
import Foundation


@propertyWrapper
struct CurrencyWrapper {
    
    var string: String = ""
    var amount: Cent = 0
    
    var wrappedValue: String {
        get { string }
        set {
            amount = Currency.parseCent(from: newValue)
            string = "\(Currency(amount))"
        }
    }
    
    
    init(amount: Cent = 0) {
        wrappedValue = "\(Currency(amount))"
    }
}


import Foundation


extension String {
    
    /// Get a new string the if empty.
    /// - Parameter replacement: The replacement string.
    func replaceEmpty(with replacement: String) -> String {
        return isEmpty ? replacement : self
    }
    
    /// Trim whitespace and newline.
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

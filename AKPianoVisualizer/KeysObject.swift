
import Foundation
import SwiftUI

/// This class contains all the keys which are pressed.
class Keyboard: ObservableObject {
    @Published var keys: [Key] = makeKeys()
}

// Makes 88 keys for the piano
func makeKeys() -> [Key] {
    var keys: [Key] = [
        Key(isWhiteKey: true), // A0
        Key(isWhiteKey: false), // A#0
        Key(isWhiteKey: true) // B0
    ]
    
    for _ in 1...7 {
        keys.append(Key(isWhiteKey: true))
        keys.append(Key(isWhiteKey: false))
        keys.append(Key(isWhiteKey: true))
        keys.append(Key(isWhiteKey: false))
        keys.append(Key(isWhiteKey: true))
        keys.append(Key(isWhiteKey: true))
        keys.append(Key(isWhiteKey: false))
        keys.append(Key(isWhiteKey: true))
        keys.append(Key(isWhiteKey: false))
        keys.append(Key(isWhiteKey: true))
        keys.append(Key(isWhiteKey: false))
        keys.append(Key(isWhiteKey: true))
    }
    
    keys.append(Key(isWhiteKey: true)) // Top C
    
    return keys
}

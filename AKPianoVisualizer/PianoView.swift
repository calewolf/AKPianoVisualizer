import SwiftUI

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

struct PianoView: View {
    
    let keys: [Key] = makeKeys()
    
    var body: some View {
        ZStack {
            HStack(spacing: 0.0) {
                keys[0]
                keys[2]
                Octave(startingIndex: 3, keys: self.keys)
                Octave(startingIndex: 15, keys: self.keys)
                Octave(startingIndex: 15, keys: self.keys)
                Octave(startingIndex: 15, keys: self.keys)
                Octave(startingIndex: 15, keys: self.keys)
                Octave(startingIndex: 15, keys: self.keys)
                Octave(startingIndex: 15, keys: self.keys)
                keys[87]
            }
            keys[1].offset(x: -475, y: -18)
        }
        
    }
    
    
}

struct Octave: View {
    let startingIndex: Int
    let keys: [Key]
    
    var body: some View {
        ZStack {
            HStack(spacing: 0.0) {
                keys[startingIndex]
                keys[startingIndex + 2]
                keys[startingIndex + 4]
                keys[startingIndex + 5]
                keys[startingIndex + 7]
                keys[startingIndex + 9]
                keys[startingIndex + 11]
            }
            HStack() {
                keys[startingIndex + 1]
                    .offset(x: -13)
                keys[startingIndex + 3]
                    .offset(x: -11)
                keys[startingIndex + 6]
                    .offset(x: 7)
                keys[startingIndex + 8]
                    .offset(x: 10)
                keys[startingIndex + 10]
                    .offset(x: 11.5)
            }.offset(y: -18)
            Text("C")
                .foregroundColor(Color.blue)
                .offset(x: -57, y: 35)
        }
    }
}


struct Key: View {
    let isWhiteKey: Bool
    @State var isPressed = false
    
    var body: some View {
        Rectangle()
            .fill(isPressed ? Color.blue : (isWhiteKey ? Color.white : Color.black))
            .frame(width: isWhiteKey ? 19.0 : 10.0, height: isWhiteKey ? 100.0 : 70.0)
            .border(Color.black, width: 1)
    }
}


struct PianoView_Previews: PreviewProvider {
    static var previews: some View {
        PianoView()
    }
}

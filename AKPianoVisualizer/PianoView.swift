
import SwiftUI

struct PianoView: View {
    
    @EnvironmentObject var keyboard: Keyboard
    
    // Draws a keyboard using repeated octaves
    var body: some View {
        ZStack {
            HStack(spacing: 0.0) {
                keyboard.keys[0]
                keyboard.keys[2]
                Octave(startingIndex: 3, keys: keyboard.keys)
                Octave(startingIndex: 15, keys: keyboard.keys)
                Octave(startingIndex: 27, keys: keyboard.keys)
                Octave(startingIndex: 39, keys: keyboard.keys)
                Octave(startingIndex: 51, keys: keyboard.keys)
                Octave(startingIndex: 63, keys: keyboard.keys)
                Octave(startingIndex: 75, keys: keyboard.keys)
                keyboard.keys[87]
            }
            keyboard.keys[1].offset(x: -475, y: -18)
        }.frame(width: 988, height: 100)
        .clipped()
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
    var isPressed = false
    
    var body: some View {
        Rectangle()
            .fill(isPressed ? Color.blue : (isWhiteKey ? Color.white : Color.black))
            .frame(width: isWhiteKey ? 19.0 : 10.0, height: isWhiteKey ? 100.0 : 70.0)
            .border(Color.black, width: 1)
            //.animation(.default)
    }
}

struct PianoView_Previews: PreviewProvider {
    static var previews: some View {
        PianoView().environmentObject(Keyboard())
    }
}

//
//  ContentView.swift
//  SampleAKProject
//
//  Created by Cale Wolf on 8/8/20.
//  Copyright © 2020 Cale Wolf. All rights reserved.
//

import SwiftUI
import AudioKit

struct ContentView: View {

    @State var midiNums: [MIDINoteNumber] = []
    @State var scale: CGFloat = 1.0
    @State var frameWidth: CGFloat = 1300.0
    @EnvironmentObject var keyboard: Keyboard
    var isPreview: Bool
    var midi = AudioKit.midi
    
    var body: some View {
        VStack() {
             HStack() {
                    Button(action: {
                        self.scale = self.scale * 2
                        self.frameWidth = self.frameWidth * 2
                    }) {
                        Text("Zoom In")
                    }
                    Button(action: {
                        self.scale = self.scale * 0.5
                        self.frameWidth = self.frameWidth * 0.5
                    }) {
                        Text("Zoom Out")
                    }
                }
                .padding(.top, 30.0)
            
            Text(self.midiNums.isEmpty ? " " : numsToString(midiNums: midiNums.sorted()))
                .font(.largeTitle)
                .fontWeight(.regular)
                .frame(width: 1000, height: 50)
                .foregroundColor(Color.white)
            
            ScrollView(.horizontal) {
                PianoView().environmentObject(keyboard)
                    .scaleEffect(scale)
                    .frame(width: self.frameWidth, height: 500)
            }
            
            
        }
        .frame(width: 1300, height: 700)
        .background(VisualEffectView(material: NSVisualEffectView.Material.ultraDark, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
        .onAppear {
          if (!self.isPreview) {
              let engine = AudioEngine()
              self.midi.openInput()
              self.midi.addListener(Listener(midiNums: self.$midiNums, engine: engine, keyboard: self.keyboard))
          }
            
            
            
            
        }
        
    }
    
    func numsToString(midiNums: [MIDINoteNumber]) -> String {
        var ret = ""
        for num in midiNums {
            ret += num.description + " "
        }
        return ret
    }
}


// Recieves MIDI input and triggers notes
struct Listener: AKMIDIListener {
    @Binding var midiNums: [MIDINoteNumber]
    var engine: AudioEngine
    var keyboard: Keyboard
    
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        midiNums.append(noteNumber)
        engine.bank.play(noteNumber: noteNumber, velocity: 80)
        
        // I don't know why this works
        DispatchQueue.main.async {
            self.keyboard.keys[Int(noteNumber) - 21].isPressed = true
        }
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        let index = midiNums.firstIndex(of: noteNumber)
        midiNums.remove(at: index!)
        engine.bank.stop(noteNumber: noteNumber)
        DispatchQueue.main.async {
            self.keyboard.keys[Int(noteNumber) - 21].isPressed = false
        }
    }
}

class AudioEngine {
    let bank = AKOscillatorBank()
    
    // TODO: Edit the sound of the oscillator?
    
    init() {
        AudioKit.output = bank
        do {
            try AudioKit.start()
        } catch {
            print("error starting ak")
        }
    }
}

// The NSVisualEffectView that controls the translucent window
struct VisualEffectView: NSViewRepresentable
{
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView
    {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context)
    {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(midiNums: [60, 64, 68], isPreview: true).environmentObject(Keyboard())
    }
}

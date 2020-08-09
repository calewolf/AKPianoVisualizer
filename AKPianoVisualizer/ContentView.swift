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
    var midi = AudioKit.midi
    var engine = AudioEngine()
    //var currentNotes: [MIDINoteNumber] = []
    
    @State var midiNum: MIDINoteNumber = MIDINoteNumber(5)
    
    var body: some View {
        Text(midiNum.description)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                self.midi.openInput()
                self.midi.addListener(Listener(midiNum: self.$midiNum, engine: self.engine))
            }
    }
}

struct Listener: AKMIDIListener {
    @Binding var midiNum: MIDINoteNumber
    var engine: AudioEngine
    
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        print(noteNumber)
        midiNum = noteNumber
        engine.bank.play(noteNumber: noteNumber, velocity: 80)
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        engine.bank.stop(noteNumber: noteNumber)
    }
}

class AudioEngine {
    let bank = AKOscillatorBank()
    
    init() {
        AudioKit.output = bank
        do {
            try AudioKit.start()
        } catch {
            print("error starting ak")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


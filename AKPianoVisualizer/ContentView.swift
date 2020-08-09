//
//  ContentView.swift
//  SampleAKProject
//
//  Created by Cale Wolf on 8/8/20.
//  Copyright © 2020 Cale Wolf. All rights reserved.
//

import SwiftUI
import AudioKit

struct ContentView: View { // is this over
    var midi = AudioKit.midi
    var engine = AudioEngine()
    
    
    @State var midiNum: MIDINoteNumber = MIDINoteNumber(5)
    
    var body: some View {
        Text(midiNum.description)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                print("hi")
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
        engine.oscillator.frequency = midiNum.midiNoteToFrequency()
        engine.oscillator.amplitude = 0.1
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        engine.oscillator.amplitude = 0
        print("off")
    }
    
    
}

class AudioEngine {
    // creates the oscillator
    var oscillator = AKOscillator(waveform: AKTable(.sine))

    init() {
        AudioKit.output = oscillator
        do {
            try AudioKit.start()
        } catch {
            print("error starting ak")
        }
        oscillator.amplitude = 0.05
        oscillator.play()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


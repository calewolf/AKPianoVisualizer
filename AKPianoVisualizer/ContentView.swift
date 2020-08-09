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
    
    @State var midiNums: [MIDINoteNumber] = []
    
    var body: some View {
        Text(numsToString(midiNums: midiNums.sorted()))
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                self.midi.openInput()
                self.midi.addListener(Listener(midiNums: self.$midiNums, engine: self.engine))
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

struct Listener: AKMIDIListener {
    @Binding var midiNums: [MIDINoteNumber]
    var engine: AudioEngine
    
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        midiNums.append(noteNumber)
        engine.bank.play(noteNumber: noteNumber, velocity: 80)
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        let index = midiNums.firstIndex(of: noteNumber)
        midiNums.remove(at: index!)
        engine.bank.stop(noteNumber: noteNumber)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


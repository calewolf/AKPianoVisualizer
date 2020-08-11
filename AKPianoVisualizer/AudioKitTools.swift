//
//  AudioKitTools.swift
//  AKPianoVisualizer
//
//  Created by Cale Wolf on 8/11/20.
//  Copyright © 2020 Cale Wolf. All rights reserved.
//

import Foundation
import SwiftUI
import AudioKit

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

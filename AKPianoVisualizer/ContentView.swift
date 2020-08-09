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
    @State var midiNum: String = "Num"
    
    var body: some View {
        Text(midiNum)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                self.midi.openInput()
                self.midi.addListener(Listener(midiNum: self.$midiNum))
            }
    }
}

struct Listener: AKMIDIListener {
    @Binding var midiNum: String
    
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel,
                            portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        print(noteNumber)
        midiNum = noteNumber.description
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


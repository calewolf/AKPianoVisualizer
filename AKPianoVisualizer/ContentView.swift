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
    @State var frameWidth: CGFloat = 1100.0
    
    @State var volume: Double = 0.1
    
    @EnvironmentObject var keyboard: Keyboard
    var isPreview: Bool
    var midi = AudioKit.midi
    
    var body: some View {
        VStack(alignment: .center) {
            TitleMenuBar(volume: $volume)
            
            Text(self.midiNums.isEmpty ? " " : numsToString(midiNums: midiNums.sorted()))
                .font(.largeTitle)
                .fontWeight(.regular)
                .frame(height: 50)
                .foregroundColor(Color.white)
                .border(Color.white, width: 1)
            
            //ScrollView(.horizontal) {
                PianoView().environmentObject(keyboard)
                    .scaleEffect(scale)
                    .frame(width: self.frameWidth, height: 200)
            //}.border(Color.white, width: 1)
            
            
        }
        .frame(minWidth: 1100, maxWidth: .infinity)
        //.frame(width: 1300, height: 700)
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

struct TitleMenuBar: View {
    @Binding var volume: Double
    
    var body: some View {
        HStack() {
            VolumeSlider(volume: $volume)
            Spacer()
            Button(action: ({})) {
                Text("Settings")
            }
        }
    }
}

struct VolumeSlider: View {
    @Binding var volume: Double
    var body: some View {
        HStack {
            Text("􀊡")
                .foregroundColor(Color.white)
            Slider(value: $volume, in: 0...0.1)
            Text("􀊩")
                .foregroundColor(Color.white)
        }
        .frame(width: 200.0)
    }
}

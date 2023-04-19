//
//  VoiceOverArticles.swift
//  Ntosetta
//
//  Created by Pantos, Thomas on 15/12/22.
//

import SwiftUI
import AVFoundation

struct VoiceOverArticles: View {
    @ObservedObject private var viewModel = MyArticlesViewModel()

    @State private var stringsToSpeak: [String] = []
    @State var isPaused: Bool = true
    let speechSynthesizer = AVSpeechSynthesizer()

    var body: some View {
        VStack {
                   if isPaused {
                       Button(action: {
                           self.fetchStringsFromAPI()
                           self.isPaused = false
                       }) {
                           Text("Play")
                       }
                   } else {
                     
                   }
            Button(action: {
                self.isPaused = true
                print(isPaused)
                self.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
                  }) {
                      Text("Stop")
                  }
//            Button(action: {
//                self.speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
//                self.isPaused = true
//            }) {
//                Text("Pause")
//            }
        }.onAppear{
                        viewModel.getVoices()
                    }
//        Button(action: {
//            self.fetchStringsFromAPI()
//            tapped.toggle()
//        }) {
//            if tapped == true {
//                Text("Stop Talking")
//            } else{
//                Text("Start")
//            }
//        }.onAppear{
//            viewModel.getVoices()
//        }
    }

    func fetchStringsFromAPI() {
        // Replace this with your actual API fetch logic
        self.stringsToSpeak = viewModel.myVoiceContent as! [String]
        self.speakStrings()
    }

    func speakStrings() {
        for string in stringsToSpeak {
            let speechUtterance = AVSpeechUtterance(string: string)
            speechSynthesizer.speak(speechUtterance)
            sleep(2)
        }
    }
}








struct VoiceOverArticles_Previews: PreviewProvider {
    static var previews: some View {
        VoiceOverArticles()
    }
}

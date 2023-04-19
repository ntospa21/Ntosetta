//
//  NewsArticle.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 22/9/22.
//

import SwiftUI
import CachedAsyncImage
import AVFoundation




struct MyNewsArticle: View {
    let title: String
    let image: String
    let content: String?
    let category: String
    @State var isLiked: Bool = false
    @State var arthra = [MyArticles]()
    @State var isPlaying : Bool = false

    
    var body: some View {
        let synthesizer = AVSpeechSynthesizer()
        ScrollView(.vertical){
            VStack(alignment: .leading){
                
                Text(title)
                    .foregroundColor(.blue)
                    .font(.system(size: 30))
                    .bold()
            }
            
            
            
            HStack(alignment: .center) {
                CachedAsyncImage(url: URL(string: image), transaction: Transaction(animation: .easeInOut)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .transition(.opacity)
                    } else {
                        HStack {
                            // Insert your placeholder here
                            Text("No Image Available")
                        }
                    }
                }
            }
            
            
            
            Text(content ?? "")
                .font(.body)
                .padding(8)
            
            Text(category )
                .font(.subheadline)
                .padding(8)
            HStack{
                Button(action: {self.isLiked.toggle()
                    
                    
                    //                self.arthra.append(MyArticles(title: title, content: content ?? "", image: image, category: category))
                    
                }, label: {
                    Image(systemName: self.isLiked == true ? "suit.heart.fill" : "suit.heart")
                })
                
                Button(action: {
                    let utterance = AVSpeechUtterance(string: content ??  "no content available" )
                    utterance.voice = AVSpeechSynthesisVoice(language: "el-GR")
                    utterance.rate = 0.45
                    synthesizer.speak(utterance)
                }, label: {
                    Image(systemName: "speaker")
                    
                })
            }
        }
    }
}



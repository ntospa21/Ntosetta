//
//  MusicView.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 29/11/22.
//

import SwiftUI
import CachedAsyncImage

struct MusicView: View {
    @ObservedObject private var viewModel = MyArticlesViewModel()

    var body: some View {
        
        
        List(viewModel.myarticles){
            article in
          
                VStack(alignment: .leading){
                    
                    
                    Text(article.title).font(.title)
                    HStack(alignment: .center) {
                        CachedAsyncImage(url: URL(string: article.image), transaction: Transaction(animation: .easeInOut)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                    .transition(.opacity)
                                
                            } else {
                                HStack {
                                    // Insert your placeholder here
                                }
                            }
                        }
                    }
                    
                    
                    
                    Text(article.content )
                        .lineLimit(6)
                        .font(.body)
                        .padding(8)
                    
                    Text(article.category)
                        .font(.subheadline)
                        .padding(8)
                }
            
        }.onAppear(){
            viewModel.getMusicCat()        }
       
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView()
    }
}

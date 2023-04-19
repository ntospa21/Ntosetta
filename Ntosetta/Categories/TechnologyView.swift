//
//  SportsView.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 29/11/22.
//

import SwiftUI
import CachedAsyncImage

struct TechnologyView: View {
    @ObservedObject private var viewModel = MyArticlesViewModel()

    var body: some View {
        
        
        List(viewModel.myarticles , id: \.id){
            article in
            NavigationLink(destination: MyNewsArticle(title: article.title, image: article.image, content: article.content, category: article.category)){
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
                                    
                                    Text("got him")
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
            }
        
            
        }.onAppear(){
            viewModel.getTechnologyCat()        }
       
    }
}

struct TechnologyView_Previews: PreviewProvider {
    static var previews: some View {
        TechnologyView()
    }
}

//
//  NewTry.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 13/11/22.
//

import SwiftUI
import CachedAsyncImage
import Firebase

struct NewTry: View {
    @ObservedObject private var viewModel = MyArticlesViewModel()
    @State private var searchText = ""
    @State var showMenu = false
    @State private var isSideBarOpened = false
    @EnvironmentObject var sessionService: SessionServiceImpl
    let gridLayout: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)

    var body: some View {

        
        if #available(iOS 16.0, *) {
            NavigationStack{
                
                Group {
                    
                    if !isSideBarOpened {
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
                        }
                    } else {
                        NavigationStack{
                            VStack{
                                List{
                                    NavigationLink(destination: SportsView(), label:{
                                        Label("Sports", systemImage: "sportscourt")
//                                            .frame(width: 100, height: 50, alignment: .topLeading)
                                            .foregroundColor(.red)
                                    })
                                    NavigationLink(destination: MusicView(), label:{
                                        Label("Music", systemImage: "music.note")
                                            .foregroundColor(.yellow)
//                                            .frame(width: 100, height: 50)
                                        
                                    })
                                    NavigationLink(destination: GossipView(), label:{
                                        Label("Gossip", systemImage: "person.2.wave.2.fill")
                                            .foregroundColor(.pink)
//                                            .frame(width: 100, height: 50, alignment: .leading)
                                        
                                    })
                                    NavigationLink(destination: TechnologyView(), label:{
                                        Label("Technology", systemImage: "gear")
//                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
//                                            .frame(width: 100, height: 50, alignment: .leading)
                                     
                                    })
//
//                                    NavigationLink(destination: ProfileVieww(), label: {
//                                        Label("Profile", systemImage: "person")
//                                            .foregroundColor(.blue)
//                                    })
//                                    Button(action: logout(), label: {
//                                        Label("Log out", systemName: "rectangle.portrait.and.arrow.right")
//                                    })
                                }
                                
                            }
                            
                        }.background(Color.red)
                        
                    }
                        // Group
                }
                .navigationTitle("Ntosetta")
                
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarLeading){
                        Button("\(Image(systemName: "sidebar.left"))"){
                            isSideBarOpened.toggle()
                        }
                        
                        
                        
                        
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("\(Image(systemName: "rectangle.portrait.and.arrow.right"))"){
                            logout()
                        }
                        
                    }
                    
                    
                    
                }
                
            }
            .onAppear(){
                viewModel.fetchData()
                print("should be fetched")


            }
        } else {
            // Fallback on earlier versions
        }
    }
   
    
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    struct NewTry_Previews: PreviewProvider {
        static var previews: some View {
            NewTry()
                .environmentObject(SessionServiceImpl())
        }
    }
}

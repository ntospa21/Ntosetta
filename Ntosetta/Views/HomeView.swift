//
//  NewTry.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 13/11/22.
//

import SwiftUI
import CachedAsyncImage
import Firebase

struct HomeView: View {
    @ObservedObject private var viewModel = MyArticlesViewModel()
    @State private var searchText = ""
    @State var showMenu = false
    @State private var isSideBarOpened = false
    @EnvironmentObject var sessionService: SessionServiceImpl
    let gridLayout: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    @State private var rotationAngle: Double = 0

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
                                                    
                                                    Text("There's a problem right now ")
                                                    Image(systemName: "gear")
                                                               .font(.system(size: 100))
                                                               .foregroundColor(.blue)
                                                               .rotationEffect(.degrees(rotationAngle))
                                                               .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
                                                               .onAppear {
                                                                   rotationAngle = 360
                                                               }// Insert your placeholder here
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
                            
                            VStack {
                                List(Category.allCases, id: \.self) { category in
                                           NavigationLink(destination: getView(for: category)) {
                                               Label(category.rawValue, systemImage: category.icon)
                                                   .foregroundColor(category.color)
                                           }
                                       }
                                       .navigationTitle("Categories")
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


            }
        } else {
            // Fallback on earlier versions
        }
    }
   
    
    
    func logout() {
        try? Auth.auth().signOut()
    }
    func getView(for category: Category) -> some View {
           switch category {
           case .sports:
               return AnyView(SportsView())
           case .music:
               return AnyView(MusicView())
           case .gossip:
               return AnyView(GossipView())
           case .technology:
               return AnyView(TechnologyView())
           }
       }
    
    enum Category: String, CaseIterable {
        case sports = "Sports"
        case music = "Music"
        case gossip = "Gossip"
        case technology = "Technology"
        
        var icon: String {
            switch self {
            case .sports:
                return "sportscourt"
            case .music:
                return "music.note"
            case .gossip:
                return "person.2.wave.2.fill"
            case .technology:
                return "gear"
            }
        }
        
        var color: Color {
            switch self {
            case .sports:
                return .red
            case .music:
                return .yellow
            case .gossip:
                return .pink
            case .technology:
                return .gray
            }
        }
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
                .environmentObject(SessionServiceImpl())
        }
    }
}

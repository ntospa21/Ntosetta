//
//  TabView.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 14/9/22.
//

import SwiftUI

struct MyTabView: View {
    @StateObject var sessionService = SessionServiceImpl()
    
    var body: some View {
        if #available(iOS 16.0, *) {
            TabView {
                NewTry()
                    
                
                    .tabItem{
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                
                ProfileView(sessionService:sessionService )
                
                    .tabItem{
                        Image(systemName: "person")
                        Text("\(sessionService.userDetails?.firstName ?? "N/A")")
                            .environmentObject(sessionService)
                        
                    }
              
                
            }
        } else {
            TabView {
                
                
                
                ProfileView(sessionService: sessionService)
                
                    .tabItem{
                        Image(systemName: "person")
                        Text("Profile")
                            .environmentObject(sessionService)
                        
                    }
                NewTry()
                
                    .tabItem{
                        Image(systemName: "house")
                        Text("Home")
                    }
                
            }
            // Fallback on earlier versions
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MyTabView()
            
                }
}

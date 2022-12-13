//
//  LoadingScreen.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 5/10/22.
//

import SwiftUI
import CachedAsyncImage

struct SplashScreenView: View {
    @State var isActive : Bool = false
    @State private var size = 0.3
    @State private var opacity = 0.5
    @EnvironmentObject var sessionService: SessionServiceImpl

    var body: some View {
        if isActive {
            MyTabView()
            
        } else {
            ZStack{
                
                
                Color.customRed
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.customDarkGreen)
                Circle()
                    .scale(1.35)
                    .foregroundColor(.customGreen)
                
                
                VStack {
                    
                    VStack {
                        Text("Welcome to Ntosseta")
                            .font(Font.custom("Raleway-Think", size: 30))
                        Spacer()
                            .frame(height: 250)
                        Image( "news")
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red)
                        
                        
                    }
                    
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.6
                            self.opacity = 1.00
                        }
                    }
                }
                
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView().environmentObject(SessionServiceImpl())
    }
}

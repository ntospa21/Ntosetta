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
    @State var progress: Double = 0
    @State var isProgressBarComplete = false
    
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        if isActive {
            
            MyTabView()
            
        } else {
            if isProgressBarComplete == false{
                CircularProgressBar()
                
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.isProgressBarComplete = true
                        }
                        
                    }
                
                
                
                
            } else {
                SplashSplash()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.isActive = true
                        }
                    }
                
            }
        }
    }
}
 
    
struct CircularProgressBar: View {
    @State var progress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: progress/100)
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.customRed)
                .rotationEffect(Angle(degrees: -90.0))
                .animation(.linear(duration: 1.0))
        }
        .frame(width: 100.0, height: 100.0)
        .onAppear {
            progress = 100.0
        }
    }
}


    struct SplashSplash: View {
        @State var isActive : Bool = false
        @State var isProgressBarComplete = false
        
        @State private var size = 0.3
        @State private var opacity = 0.5
        var body: some View {
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
                
                
            }
        }
    }
    struct SplashScreenView_Previews: PreviewProvider {
        static var previews: some View {
            SplashScreenView().environmentObject(SessionServiceImpl())
        }
    }
    


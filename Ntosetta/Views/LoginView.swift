//
//  NewLogin.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 27/11/22.
//

import SwiftUI

struct LoginView: View {
   @State private var email: String = ""
   @State private var password: String = ""
   @State private var showRegistration = false
   @State private var showForgotPassword = false
    
    
    @StateObject private var vm = LoginViewModelmp(service: LoginServiceImpl())
    
    @Environment(\.colorScheme) var colorScheme
    
    var boy: some View {
        Text(colorScheme == .dark ? "In dark mode" : "In light mode")
    }
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
            
            
            VStack(spacing: 10){
                
                Image("news")
                    .resizable()
                    .frame(width:120 , height: 100)
                    
                
                
                if colorScheme == .dark {
                    TextField("Email", text: $vm.credentials.email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black)
                        .border(.red, width: CGFloat(0))
                        .textInputAutocapitalization(.never)
                        .cornerRadius(15)

                    
                    
                    
                    SecureField("Password", text: $vm.credentials.password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black)
                        .border(.red, width: CGFloat(0))
                        .textInputAutocapitalization(.never)
                        .cornerRadius(15)

                    
                } else {
                    TextField("Username", text: $vm.credentials.email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .textInputAutocapitalization(.never)
                        .cornerRadius(15)

                    
                    SecureField("Password", text: $vm.credentials.password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .border(.red, width: CGFloat(0))
                        .textInputAutocapitalization(.never)
                        .cornerRadius(15)

                }
                
                HStack{
                    Spacer()
                    
                    Button(action: {
                        showForgotPassword.toggle()
                    }, label: {
                        Text("Forgot Password?")
                            .font(.system(size: 16, weight: .bold))
                    })
                    
                    .sheet(isPresented: $showForgotPassword, content: {
                        ForgotPassword()
                    })
                }
                VStack(spacing: 15){
                    Button("Login"){
                        vm.login()
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.customRed)
                    .cornerRadius(15)
                    
                    Button("Register"){
                        showRegistration.toggle()
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.customDarkGreen)
                    .cornerRadius(15)
                    .sheet(isPresented: $showRegistration, content:{
                        RegisterView()
                    })
                }
                
            }.navigationTitle("Login")
                .padding(.horizontal, 15)
                .alert(isPresented: $vm.hasError,
                       content: {
                    if case .failed(let error) = vm.state {
                        return Alert(title: Text("Error"),
                                     message: Text(error.localizedDescription))
                    } else {
                        return Alert(title: Text("Error"),
                                     message: Text("Something went wrong"))
                    }
                })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

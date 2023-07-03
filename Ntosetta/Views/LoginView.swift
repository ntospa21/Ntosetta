//
//  NewLogin.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 27/11/22.
//

import SwiftUI

enum ColorSchemeOption: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
}

struct LoginView: View {
   @State private var email: String = ""
   @State private var password: String = ""
   @State private var showRegistration = false
   @State private var showForgotPassword = false
    @FocusState private var keyboardFocused: Bool

    
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
                    
                
                
          
                    TextField("Email", text: $vm.credentials.email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .border(.red, width: CGFloat(0))
                        .textInputAutocapitalization(.never)
                        .cornerRadius(15)
                        .accessibility(identifier: "Email")
                        .focused($keyboardFocused)

                        

                    
                    
                    
                    SecureField("Password", text: $vm.credentials.password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .border(.red, width: CGFloat(0))
                        .textInputAutocapitalization(.never)
                        .cornerRadius(15)
                        .accessibility(identifier: "Password")
                        .focused($keyboardFocused)



                
                HStack{
                    Spacer()
                    
                    Button(action: {
                        showForgotPassword.toggle()
                    }
                        
                           , label: {
                        Text("Forgot Password?")
                            .font(.system(size: 16, weight: .bold))
                    })
                    .accessibilityAddTraits(.isButton)
                    .accessibility(identifier: "Forgot Password?")

                    
                    .sheet(isPresented: $showForgotPassword, content: {
                        ForgotPassword()
                    })
                }
                VStack(spacing: 15){
                    
                    VStack{
                        
                        Button("Login"){
                            vm.login()
                        }                    .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.customRed)
                            .cornerRadius(15)
                    }
                    .accessibility(identifier: "Login")

                    
                    Button("Register"){
                        showRegistration.toggle()
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.customDarkGreen)
                    .cornerRadius(15)
                    .accessibility(identifier: "Register")

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

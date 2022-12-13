//
//  LoginScreen.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 12/9/22.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = RegistrationViewModelImpl(
        service: RegistrationServiceImpl()
    )
    
    var body: some View {
        
        NavigationView {
            ZStack{
                
                
                Color.customRed
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.customDarkGreen)
                Circle()
                    .scale(1.35)
                    .foregroundColor(.customGreen)
                
                VStack(spacing: 32) {
                    
                    VStack(spacing: 16) {
                        TextField("Email", text: $viewModel.userDetails.email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .border(.red, width: CGFloat(0))
                            .textInputAutocapitalization(.never)
                            .cornerRadius(15)

                        
                        SecureField("Password", text: $viewModel.userDetails.password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .border(.red, width: CGFloat(0))
                            .textInputAutocapitalization(.never)
                            .cornerRadius(15)
                        
                        TextField("First", text: $viewModel.userDetails.firstName)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .border(.red, width: CGFloat(0))
                            .textInputAutocapitalization(.never)
                            .cornerRadius(15)
                        
                        TextField("Last", text: $viewModel.userDetails.lastName)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .border(.red, width: CGFloat(0))
                            .textInputAutocapitalization(.never)
                            .cornerRadius(15)
                    }
                    
                    Button("Sign up") {
                        viewModel.register()
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.customDarkGreen)
                    .cornerRadius(15)
                    
                }.navigationTitle("Register")
                    .applyClose()
                    .alert(isPresented: $viewModel.hasError,
                           content: {
                        
                        if case .failed(let error) = viewModel.state {
                            return Alert(
                                title: Text("Error"),
                                message: Text(error.localizedDescription))
                        } else {
                            return Alert(
                                title: Text("Error"),
                                message: Text("Something went wrong"))
                        }
                    })
                
                
            }
        }
           
//            .applyClose()

        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
            RegisterView()
    }
}

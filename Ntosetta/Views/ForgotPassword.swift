//
//  ForgotPassword.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 27/11/22.
//

import SwiftUI

struct ForgotPassword: View {
    @StateObject private var vm = ForgotPasswordViewModelImpl(service: ForgotPasswordServiceImpl())
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            ZStack{
                
                
                Color.customRed
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.customDarkGreen)
                Circle()
                    .scale(1.35)
                    .foregroundColor(.customGreen)
                
                
                VStack(spacing: 15){
                    TextField("Email", text: $vm.email)
                        .accessibility(identifier: "EmailFgt")
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black)
                        .border(.red, width: CGFloat(0))
                        .textInputAutocapitalization(.never)
                        .cornerRadius(15)
                    Button("Send passwordReset"){
                        vm.sendPasswordReset()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .accessibility(identifier: "SendPasswordReset")
                }
            }
        }.padding(.horizontal, 15)
            .navigationTitle("Reset Password")
            .applyClose()
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword()
    }
}

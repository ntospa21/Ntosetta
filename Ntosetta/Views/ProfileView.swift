//
//  ProfileVieww.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 27/11/22.
//

import SwiftUI
import CachedAsyncImage

class FavArticles: ObservableObject {
    @Published var favArts: [String] = []
    
}
struct ProfileView: View {
    @ObservedObject private var viewModel = MyArticlesViewModel()
    @StateObject var sessionService: SessionServiceImpl
    @State private var image = UIImage()
    @State private var showSheet = false
    
    var body: some View {

        if #available(iOS 16.0, *) {
            NavigationStack{
                VStack(alignment: .leading, spacing: 15){
                    
                    VStack{
                        Image(uiImage: self.image)
                                .resizable()
                                .cornerRadius(50)
                                .padding(.all, 4)
                                .frame(width: 100, height: 100)
                                .background(Color.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .padding(8)
                        
                        
                        
                        
                        HStack{
                            Text("\(sessionService.userDetails?.firstName ?? "N/A" )").foregroundColor(.red)
                                .font(.title)
                                .bold()
                            Text("\(sessionService.userDetails?.lastName ?? "N/A" )").foregroundColor(.red)
                                .font(.title)
                                .bold()
                        }
                        HStack{
                            Image(systemName: "envelope")
                            Text("\(sessionService.userDetails?.email ?? "N/A")").foregroundColor(.red)
                        }
                        Spacer().frame(height: 30)
                        
                        Text("Change photo")
                                .font(.headline)
                                .frame(width: 250)
                                .frame(height: 60)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(16)
                                .foregroundColor(.white)
                                .onTapGesture {
                                    showSheet = true
                                }
                                .sheet(isPresented: $showSheet) {
                                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                                }
//                        Button{
//                            print("Updated")
//
//                        } label: {
//                            Text("Update Profile")
//                                .bold()
//                                .frame(width: 260, height: 50)
//                                .background(Color.red)
//                                .foregroundColor(.white)
//                                .cornerRadius(12)
//                        }
                        
                    }
                    
                }.navigationTitle("Profile")
            }
        } else {
            // Fallback on earlier versions
        }
    }
}




        struct ProfileView_Previews: PreviewProvider {
            static var previews: some View {
                ProfileView(sessionService: SessionServiceImpl()).environmentObject(SessionServiceImpl())
            }
        }
    

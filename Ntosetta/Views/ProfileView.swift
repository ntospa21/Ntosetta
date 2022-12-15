//
//  ProfileVieww.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 27/11/22.
//

import SwiftUI
import CachedAsyncImage
import Firebase
import FirebaseStorage



struct ProfileView: View {
    @ObservedObject private var viewModel = MyArticlesViewModel()
    @StateObject var sessionService: SessionServiceImpl
    @State  var image : UIImage?
    @State private var showSheet = false
    @State var StatusMessage = ""
    @State var retrievedImages = UIImage()
    @State var retrieveUID = [String]()
//    @ObservedObject var vm = profileViewModel()
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            NavigationStack{
                VStack(alignment: .leading, spacing: 15){
                    HStack{
                        Text("\(sessionService.userDetails?.firstName ?? "N/A" )").foregroundColor(.red)
                            .font(.title)
                            .bold()
                        Text("\(sessionService.userDetails?.lastName ?? "N/A" )").foregroundColor(.red)
                            .font(.title)
                            .bold()
                    }
                    
                    if image != nil {
                        Image(uiImage: image!)
                            .resizable()
                            .frame(width: 200, height: 200)
                    }
                    Button{
                        showSheet = true
                        
                    } label: {
                        Text("select a Photo")
                    }
                    
                    
                    
                    
                    
                    if image != nil {
                        Button{
                            uploadPhoto()
                        } label: {
                            Text("Upload Photo")
                        }
                    }
                    Divider()
                    HStack{
//                        ForEach(retrievedImages, id: \.self ){
//                            image in
                            
                            Image(uiImage: retrievedImages)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 128, height: 128)
                                .cornerRadius(64)
                            
//                        }
                    }
                    HStack{
                        Image(systemName: "envelope")
                        Text("\(sessionService.userDetails?.email ?? "N/A")").foregroundColor(.red)
                    }
                    Spacer().frame(height: 30)
                    
                    
                    //
                    //                        if image == nil{
                    //                            Image(systemName: "person.fill")
                    //                                .resizable()
                    //                                .scaledToFill()
                    //                                .frame(width: 128, height: 128)
                    //                                .cornerRadius(64)
                    //
                    //                        } else {
                    
                    
//                    List(vm.profileData){
//                        pro in
//                        let uid = Auth.auth().currentUser?.uid
//                        if uid == pro.id{
//                            Text(pro.image)
//
//                        } else {
//                            Text("got you ")
//                        }
//                    }
                    
                   
                    
                    
                }.navigationTitle("Profile")
                    .sheet(isPresented: $showSheet, onDismiss: nil){
                        ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                    }
            }.onAppear{
                retrievePhoto()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func uploadPhoto(){
        // make sure that the selected image property isnt nil
        guard image != nil else {
            return
        }
        // create storage reference
        let storageRef = Storage.storage().reference()
        // turn image into data
        let imageData = image!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        // specify the file path and name
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        // upload thata data
        
        let uploadTask = fileRef.putData(imageData!,metadata: nil) { metadata, error in
            // take the uid
            let uid = Auth.auth().currentUser?.uid
            
            //check for error
            if error == nil && metadata != nil {
                //save reference
                let db = Firestore.firestore()
                db.collection("images").document().setData(["url": path, "uid": uid])
//                x§
            }
        }
    }
    
  
    func retrievePhoto(){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("images").whereField("uid", isEqualTo: uid).limit(to: 1).getDocuments{ snapshot, error in
            if error == nil && snapshot != nil {
                
                var paths = [String]()
                
                for doc in snapshot!.documents {
                        paths.append(doc["url"] as! String)
                    
                    for path in paths {
                        let storageRef = Storage.storage().reference()
                        let fileRef = storageRef.child(path)
                        
                        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                            if error == nil && data != nil {
                                // create a ui Image
                                
                                if let image = UIImage(data: data!){
                                    DispatchQueue.main.async {
                                        
                                        retrievedImages = image

                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    

    
    
    
}


        struct ProfileView_Previews: PreviewProvider {
            static var previews: some View {
                ProfileView(sessionService: SessionServiceImpl()).environmentObject(SessionServiceImpl())
            }
        }
    

//HStack{
//    Text("\(sessionService.userDetails?.firstName ?? "N/A" )").foregroundColor(.red)
//        .font(.title)
//        .bold()
//    Text("\(sessionService.userDetails?.lastName ?? "N/A" )").foregroundColor(.red)
//        .font(.title)
//        .bold()
//}
//HStack{
//    Image(systemName: "envelope")
//    Text("\(sessionService.userDetails?.email ?? "N/A")").foregroundColor(.red)
//}
//Spacer().frame(height: 30)

//
//                        Text("Change photo")
//                                .font(.headline)
//                                .frame(width: 250)
//                                .frame(height: 60)
//                                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
//                                .cornerRadius(16)
//                                .foregroundColor(.white)
//                                .onTapGesture {
//                                    showSheet = true
//                                }
//                                .sheet(isPresented: $showSheet) {
//                                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
//
//                                }
//
//                        Button("UploadPhoto"){
//                            persistImageToStorage()
//                        }
                        
//    private func persistImageToStorage() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let ref = Storage.storage().reference(withPath: uid)
//        guard let imageData = self.image.jpegData(compressionQuality: 0.5) else { return }
//        ref.putData(imageData, metadata: nil) { metadata, err in
//            if let err = err {
//                self.StatusMessage = "Failed to push image to Storage: \(err)"
//                return
//            }
//
//            ref.downloadURL { url, err in
//                if let err = err {
//                    self.StatusMessage = "Failed to retrieve downloadURL: \(err)"
//                    print("nope")
//                    return
//                }
//
//                self.StatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
//                print("succesful")
//                print(url?.absoluteString as Any)
//
//            }
//        }
//    }

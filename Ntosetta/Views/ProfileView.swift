
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
    @State var retrievedImage: UIImage? // Replace `@State var retrievedImages = UIImage()` with this line
    @State private var isLikedByUser = false
    @State private var likedArticles: [(String, String, String, String)] = []
    let databaseRef = Database.database().reference()
    @State private var imageScale: CGFloat = 1.0
    @State private var isBouncing = false
    @State private var offset: CGFloat = 200.0

    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            NavigationStack{
                ScrollView{
                    Spacer()
                    VStack(alignment: .center, spacing: 15) {
                        HStack {
                            Text("\(sessionService.userDetails?.firstName ?? "N/A")")
                                .foregroundColor(.red)
                                .font(.title)
                                .bold()
                            Text("\(sessionService.userDetails?.lastName ?? "N/A")")
                                .foregroundColor(.red)
                                .font(.title)
                                .bold()
                                .animation(Animation.easeInOut(duration: 10), value: offset)

                        }
                        
//                        Group {
//
//                            HStack{
//
//                                Image(uiImage: retrievedImages)
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 128, height: 128)
//                                    .cornerRadius(64)
//
//                            }
//                                                    if let image = image {
//                                                        Image(uiImage: image)
//                                                            .resizable()
//                                                            .scaledToFill()
//                                                            .frame(width: 200, height: 200)
//                                                            .cornerRadius(100)
//                                                            .shadow(radius: 10)
//                                                            .scaleEffect(isBouncing ? 0.9 : 1.0)
//                                                        Button{
//                                                            uploadPhoto()
//                                                        } label: {
//                                                            Text("Upload Photo")
//                                                        }
//                                                    } else if let retrievedImage = retrievedImage {
//                                                        Image(uiImage: retrievedImage)
//                                                            .resizable()
//                                                            .scaledToFill()
//                                                            .frame(width: 200, height: 200)
//                                                            .cornerRadius(100)
//                                                            .shadow(radius: 10)
//                                                            .scaleEffect(isBouncing ? 0.9 : 1.0)
//                                                    } else {
//                                                        Color.clear // Placeholder view when both images are nil
//                                                    }
//                                                }
//                                                .id(UUID().uuidString) // Add unique ID to force view update
//
//                                                // ...
//
//                                                Button {
//                                                    showSheet = true
//                                                } label: {
//                                                    Text("Select a Photo")
//                                                        .foregroundColor(.white)
//                                                        .padding()
//                                                        .background(
//                                                            RoundedRectangle(cornerRadius: 10)
//                                                                .foregroundColor(.blue)
//                                                        )
//                                                }
//                                                .padding()
//
//
//
//
//
////                        if image != nil {
////                            Button{
////                                uploadPhoto()
////                            } label: {
////                                Text("Upload Photo")
////                            }
////                        }
                     
                        Spacer()
                        HStack{
                            Image(systemName: "envelope")
                            Text("\(sessionService.userDetails?.email ?? "N/A")").foregroundColor(.red)
                        }
                        Divider()
                        
                        // Inside the ForEach loop
                        Text("Αγαπημένα άρθρα")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 16)
                        LazyVStack(alignment: .leading, spacing: 8) {
                            ForEach(likedArticles, id: \.0) { article in
                                let destinationView = MyNewsArticle(title: article.0, image: article.2, content: article.1, category: article.3)
                                
                                NavigationLink(destination: destinationView) {
                                    VStack {
                                        ZStack(alignment: .bottomLeading) {
                                            CachedAsyncImage(url: URL(string: article.2), transaction: Transaction(animation: .easeInOut)) { phase in
                                                if let image = phase.image {
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .cornerRadius(8)
                                                } else {
                                                    // Placeholder image or loading indicator
                                                    ProgressView()
                                                }
                                            }
                                            
                                            Text(article.0)
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .italic()
                                                .padding()
                                                .foregroundColor(.white)
                                                .background(
                                                    LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
                                                        .opacity(0.8)
                                                )
                                                .transition(.opacity)
                                        }
                                    }
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                }
                            }
                        }

                        
                        
                        
                        
                        
                        
                    }.navigationTitle("Profile")
                        .sheet(isPresented: $showSheet, onDismiss: nil){
                            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                        }
                }
                .onAppear{
                    retrievePhoto()
                    observeLikedArticles()
                    
                }
                .onChange(of: image) { (retrievedImages) in
                    self.image = retrievedImages
                }
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
    func observeLikedArticles() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        databaseRef.child("users").child(userID).child("liked_articles").observe(.value) { snapshot in
            if let likedArticlesDict = snapshot.value as? [String: Any] {
                let articles: [(String, String, String, String)] = likedArticlesDict.compactMap { articleID, articleData in
                    guard let articleDataDict = articleData as? [String: Any],
                          let title = articleDataDict["title"] as? String,
                          let content = articleDataDict["content"] as? String,
                          let image = articleDataDict["image"] as? String,
                          let category = articleDataDict["category"] as? String else {
                        return nil
                    }
                    return (title, content, image, category)
                }
                self.likedArticles = articles.map { ($0.0, $0.1, $0.2, $0.3) }
            } else {
                self.likedArticles = []
            }
        }
    }

    
    
    
    
    
    
    func uploadPhoto() {
        // Make sure that the selected image property isn't nil
        guard let image = image else {
            return
        }
        
        // Convert image into data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        // Specify the file path and name
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        // Upload data to Firebase Storage
        let _ = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                // Handle the error
                print("Error uploading photo to Firebase Storage: \(error.localizedDescription)")
            } else {
                // Update the profile image on Firebase Firestore
                if let uid = Auth.auth().currentUser?.uid {
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).updateData(["profileImage": path]) { error in
                        if let error = error {
                            // Handle the error
                            print("Error updating profile image on Firestore: \(error.localizedDescription)")
                        } else {
                            print("Profile image updated successfully")
                            
                            // Update the image on the UI
                            DispatchQueue.main.async {
                                self.image = image
                            }
                        }
                    }
                }
            }
        }
    }



    
        func retrievePhoto(){
            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser?.uid
    
    
            db.collection("images").whereField("uid", isEqualTo: uid!).limit(to: 1).getDocuments{ snapshot, error in
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
    
    
   
    //
    
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(sessionService: SessionServiceImpl()).environmentObject(SessionServiceImpl())
    }
}


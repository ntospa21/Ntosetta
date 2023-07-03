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
    @State var retrievedImage: UIImage? // Replace `@State var retrievedImages = UIImage()` with this line
    @State private var isLikedByUser = false
    @State private var selectedLikedArticle: String? = nil
    @State private var likedArticles: [String] = []
    let databaseRef = Database.database().reference()

    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            NavigationStack{
                ScrollView{
                    Spacer()
                    VStack(alignment: .center, spacing: 15){
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
                        HStack{
                            
                            Image(uiImage: retrievedImages)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 128, height: 128)
                                .cornerRadius(64)
                            
                        }
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
                            ForEach(likedArticles, id: \.self) { articleTitle in
                                Text(articleTitle)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 16)

                                          
                        
                      
                        
                        
                        
                      
                        
                        
                        
                        
                    }.navigationTitle("Profile")
                        .sheet(isPresented: $showSheet, onDismiss: nil){
                            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                        }
                }
                .onAppear{
                    retrievePhoto()
                    retrieveLikedArticles()
                    
                }
                .onChange(of: image) { (retrievedImages) in
                    self.image = retrievedImages
                }
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
   
    func retrieveLikedArticles() {
            guard let userID = Auth.auth().currentUser?.uid else {
                print("User is not logged in")
                return
            }
            
            databaseRef.child("users").child(userID).child("liked_articles").observe(.value) { snapshot in
                if let likedArticlesDict = snapshot.value as? [String: Any] {
                    self.likedArticles = Array(likedArticlesDict.keys)
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
        let uploadTask = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                // Handle the error
                print("Error uploading photo to Firebase Storage: \(error.localizedDescription)")
            } else {
                // Update the profile image locally
                retrievedImage = image
                
                // Update the profile image on Firebase Firestore
                if let uid = Auth.auth().currentUser?.uid {
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).updateData(["profileImage": path]) { error in
                        if let error = error {
                            // Handle the error
                            print("Error updating profile image on Firestore: \(error.localizedDescription)")
                        } else {
                            print("Profile image updated successfully")
                        }
                    }
                }
            }
        }
    }


    
    
//    func uploadPhoto(){
//        // make sure that the selected image property isnt nil
//        guard image != nil else {
//            return
//        }
//        // create storage reference
//        let storageRef = Storage.storage().reference()
//        // turn image into data
//        let imageData = image!.jpegData(compressionQuality: 0.8)
//        guard imageData != nil else {
//            return
//        }
//        // specify the file path and name
//        let path = "images/\(UUID().uuidString).jpg"
//        let fileRef = storageRef.child(path)
//        // upload thata data
//
//        let uploadTask = fileRef.putData(imageData!,metadata: nil) { metadata, error in
//            // take the uid
//            let uid = Auth.auth().currentUser?.uid
//
//            //check for error
//            if error == nil && metadata != nil {
//                //save reference
//                let db = Firestore.firestore()
//                db.collection("images").document().setData(["url": path, "uid": uid!])
//            }
//        }
//    }
    
    
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
    
    func fetchLikedArticleTitles() {
            // Assuming you have a user ID to associate the liked articles with
            guard let userID = Auth.auth().currentUser?.uid else {
                print("User is not logged in")
                return
            }

            databaseRef.child("users").child(userID).child("liked_articles").observeSingleEvent(of: .value) { snapshot in
                if let likedArticlesDict = snapshot.value as? [String: Any] {
                    let likedArticleIDs = Array(likedArticlesDict.keys)
                    var fetchedLikedArticles: [String] = []

                    for articleID in likedArticleIDs {
                        // Assuming you have a "articles" node in your Firebase database
                        databaseRef.child("articles").child(articleID).child("title").observeSingleEvent(of: .value) { snapshot in
                            if let articleTitle = snapshot.value as? String {
                                fetchedLikedArticles.append(articleTitle)

                                // Update the likedArticles array when all titles are fetched
                                if fetchedLikedArticles.count == likedArticleIDs.count {
                                    likedArticles = fetchedLikedArticles
                                }
                            }
                        }
                    }
                }
            }
        }

    func checkIfLikedByUser() {
            // Assuming you have a user ID to associate the liked articles with
            guard let userID = Auth.auth().currentUser?.uid else {
                print("User is not logged in")
                return
            }
            
            // Observe changes in the liked articles
            databaseRef.child("users").child(userID).child("liked_articles").observe(.value) { snapshot in
                if let likedArticlesDict = snapshot.value as? [String: Any] {
                    self.likedArticles = Array(likedArticlesDict.keys)
                    
                    // Update the selectedLikedArticle if it is not in the updated list
                    if let selectedLikedArticle = self.selectedLikedArticle,
                       !self.likedArticles.contains(selectedLikedArticle) {
                        self.selectedLikedArticle = nil
                    }
                } else {
                    self.likedArticles = []
                    self.selectedLikedArticle = nil
                }
            }
        }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(sessionService: SessionServiceImpl()).environmentObject(SessionServiceImpl())
    }
}



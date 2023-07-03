//
//  NewsArticle.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 22/9/22.
//

import SwiftUI
import CachedAsyncImage
import AVFoundation
import Firebase

struct MyNewsArticle: View {
    let title: String
    let image: String
    let content: String?
    let category: String
    let databaseRef = Database.database().reference()
    @State private var isLikedByUser = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.blue)
                    .font(.system(size: 30))
                    .bold()
            }
            
            HStack(alignment: .center) {
                CachedAsyncImage(url: URL(string: image), transaction: Transaction(animation: .easeInOut)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .transition(.opacity)
                    } else {
                        HStack {
                            Text("No Image Available")
                        }
                    }
                }
            }
            
            Text(content ?? "")
                .font(.body)
                .padding(8)
            
            Text(category)
                .font(.subheadline)
                .padding(8)
            
            HStack {
                Button(action: {
                    let utterance = AVSpeechUtterance(string: content ?? "No content available")
                    utterance.voice = AVSpeechSynthesisVoice(language: "el-GR")
                    utterance.rate = 0.45
                    AVSpeechSynthesizer().speak(utterance)
                }) {
                    Image(systemName: "speaker")
                }
                
                Button(action: {
                    toggleLike()
                }) {
                    Image(systemName: isLikedByUser ? "heart.fill" : "heart")
                        .foregroundColor(isLikedByUser ? .red : .gray)
                }
            }
        }
        .onAppear {
            checkIfLikedByUser()
        }
    }
    
    func checkIfLikedByUser() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        let sanitizedTitle = sanitizeTitle(title)
        
        databaseRef.child("users").child(userID).child("liked_articles").child(sanitizedTitle).observe(.value) { snapshot in
            isLikedByUser = snapshot.exists()
        }
    }
    
    func toggleLike() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        let sanitizedTitle = sanitizeTitle(title)
        
        if isLikedByUser {
            databaseRef.child("users").child(userID).child("liked_articles").child(sanitizedTitle).removeValue()
            print("is not  liked article")
        } else {
            databaseRef.child("users").child(userID).child("liked_articles").child(sanitizedTitle).setValue(true)
            print("is liked article")

        }
        
        isLikedByUser.toggle()
    }
    
    func sanitizeTitle(_ title: String) -> String {
        var sanitizedTitle = title
        let restrictedCharacters: [Character] = [".", "#", "$", "[", "]"]
        for character in restrictedCharacters {
            sanitizedTitle = sanitizedTitle.replacingOccurrences(of: String(character), with: "")
        }
        return sanitizedTitle
    }
}



//struct MyNewsArticle: View {
//    let title: String
//    let image: String
//    let content: String?
//    let category: String
//    @State var isLiked: Bool = false
//    @State var arthra = [MyArticles]()
//    @State var isPlaying : Bool = false
//    let databaseRef = Database.database().reference()
//    @State private var isLikedByUser = false
//
//
//
//
//    var body: some View {
//        let synthesizer = AVSpeechSynthesizer()
//        ScrollView(.vertical){
//            VStack(alignment: .leading){
//
//                Text(title)
//                    .foregroundColor(.blue)
//                    .font(.system(size: 30))
//                    .bold()
//            }
//
//
//
//            HStack(alignment: .center) {
//                CachedAsyncImage(url: URL(string: image), transaction: Transaction(animation: .easeInOut)) { phase in
//                    if let image = phase.image {
//                        image
//                            .resizable()
//                            .scaledToFit()
//                            .clipShape(RoundedRectangle(cornerRadius: 25))
//                            .transition(.opacity)
//                    } else {
//                        HStack {
//                            // Insert your placeholder here
//                            Text("No Image Available")
//                        }
//                    }
//                }
//            }
//
//
//
//            Text(content ?? "")
//                .font(.body)
//                .padding(8)
//
//            Text(category )
//                .font(.subheadline)
//                .padding(8)
//            HStack{
//
//                Button(action: {
//                    let utterance = AVSpeechUtterance(string: content ??  "no content available" )
//                    utterance.voice = AVSpeechSynthesisVoice(language: "el-GR")
//                    utterance.rate = 0.45
//                    synthesizer.speak(utterance)
//                }, label: {
//                    Image(systemName: "speaker")
//
//                })
//
//                Button(action: {
//                    if isLikedByUser {
//                        // Remove the article from liked articles
//                        guard let userID = Auth.auth().currentUser?.uid else {
//                            print("User is not logged in")
//                            return
//                        }
//                        let sanitizedTitle = sanitizeTitle(title)
//                        databaseRef.child("users").child(userID).child("liked_articles").child(sanitizedTitle).removeValue()
//                    } else {
//                        // Add the article to liked articles
//                        guard let userID = Auth.auth().currentUser?.uid else {
//                            print("User is not logged in")
//                            return
//                        }
//                        let sanitizedTitle = sanitizeTitle(title)
//                        databaseRef.child("users").child(userID).child("liked_articles").child(sanitizedTitle).setValue(true)
//                    }
//                    // Toggle the liked status
//                    isLikedByUser.toggle()
//                }) {
//                    Image(systemName: isLikedByUser ? "heart.fill" : "heart")
//                        .foregroundColor(isLikedByUser ? .red : .gray)
//                }
//                .onAppear {
//                    checkIfLikedByUser()
//                }
//            }
//        }
//        .onAppear{
//            checkIfLikedByUser()
//        }
//    }
//
//    // Function to check if the article is liked by the user
//    func checkIfLikedByUser() {
//            // Assuming you have a user ID to associate the liked articles with
//            guard let userID = Auth.auth().currentUser?.uid else {
//                print("User is not logged in")
//                return
//            }
//
//            // Observe changes in the liked articles
//            databaseRef.child("users").child(userID).child("liked_articles").observe(.value) { snapshot in
//                if let likedArticlesDict = snapshot.value as? [String: Any] {
//                    self.isLikedByUser = likedArticlesDict.keys.contains(self.title)
//                    self.isLikedByUser = true
//                    print("Liked article")
//                } else {
//                    self.isLikedByUser = false
//                    print("Not liked article")
//                }
//            }
//        }
//
//
//
//    // Function to sanitize the title value by removing restricted characters
//    func sanitizeTitle(_ title: String) -> String {
//        var sanitizedTitle = title
//
//        // Remove restricted characters from the title
//        let restrictedCharacters: [Character] = [".", "#", "$", "[", "]"]
//        for character in restrictedCharacters {
//            sanitizedTitle = sanitizedTitle.replacingOccurrences(of: String(character), with: "")
//        }
//
//        return sanitizedTitle
//    }
//
//    // Function to add the article to liked articles
//    func likeArticle() {
//        // Assuming you have a user ID to associate the liked articles with
//        guard let userID = Auth.auth().currentUser?.uid else {
//            print("User is not logged in")
//            return
//        }
//
//        let sanitizedTitle = sanitizeTitle(title)
//
//        // Add the article to liked articles
//        databaseRef.child("users").child(userID).child("liked_articles").child(sanitizedTitle).setValue(true)
//
//        // Toggle the liked status
//        isLikedByUser = true
//    }
//
//    // Function to remove the article from liked articles
//    func unlikeArticle() {
//        // Assuming you have a user ID to associate the liked articles with
//        guard let userID = Auth.auth().currentUser?.uid else {
//            print("User is not logged in")
//            return
//        }
//
//        let sanitizedTitle = sanitizeTitle(title)
//
//        // Remove the article from liked articles
//        databaseRef.child("users").child(userID).child("liked_articles").child(sanitizedTitle).removeValue()
//
//        // Toggle the liked status
//        isLikedByUser = false
//    }
//
//
//}
//
//

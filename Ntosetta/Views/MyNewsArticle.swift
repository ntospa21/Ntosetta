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
            databaseRef.child("users").child(userID).child("liked_articles").child(sanitizedTitle).removeValue { error, _ in
                if let error = error {
                    print("Error removing liked article: \(error.localizedDescription)")
                } else {
                    print("Successfully removed liked article")
                }
            }
        } else {
            let articleData: [String: Any] = [
                "title": title,
                "image": image,
                "content": content ?? "",
                "category": category
            ]
            
            databaseRef.child("users").child(userID).child("liked_articles").child(sanitizedTitle).setValue(articleData) { error, _ in
                if let error = error {
                    print("Error saving liked article: \(error.localizedDescription)")
                } else {
                    print("Successfully saved liked article")
                }
            }
        }
        
        isLikedByUser.toggle()
    }



//    func saveImageUrl() {
//        guard let userID = Auth.auth().currentUser?.uid else {
//            print("User is not logged in")
//            return
//        }
//        
//        let sanitizedTitle = sanitizeTitle(title)
//        
//        let likedArticleRef = databaseRef.child("users").child(userID).child("liked_articles").child(sanitizedTitle)
//        
//        let imageData: [String: Any] = [
//            "image": image
//        ]
//        
//        likedArticleRef.updateChildValues(imageData) { error, _ in
//            if let error = error {
//                print("Error saving image URL: \(error.localizedDescription)")
//            } else {
//                print("Successfully saved image URL")
//            }
//        }
//    }

    func sanitizeTitle(_ title: String) -> String {
        var sanitizedTitle = title
        let restrictedCharacters: [Character] = [".", "#", "$", "[", "]"]
        for character in restrictedCharacters {
            sanitizedTitle = sanitizedTitle.replacingOccurrences(of: String(character), with: "")
        }
        return sanitizedTitle
    }
}


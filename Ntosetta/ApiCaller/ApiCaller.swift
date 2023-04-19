//
//  MyApiCall.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 6/11/22.
//

import Foundation
//import FirebaseFirestore
import Firebase



 class MyArticlesViewModel:  ObservableObject {
    @Published var myarticles : [MyArticles] = []
     @Published var myVoiceContent: [String] = []
     @Published var likedArticles: [MyNewsArticle] = []
     
    private var db = Firestore.firestore()

    init(){
        fetchData()
    }
    
    func fetchData() {
        db.collection("art").addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no docs")
                return
            }
            
            self.myarticles = documents.map{ (QueryDocumentSnapshot) -> MyArticles in
                let data = QueryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let content = data["content"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                return MyArticles(title: title, content: content, image: image, category: category)
            }
        }
    }
     

     func getVoices(){
         db.collection("art").addSnapshotListener{ (querySnapshot, error) in
             guard let documents = querySnapshot?.documents else {
                 print("no docs")
                 return
             }
             self.myVoiceContent = documents.map{ (QueryDocumentSnapshot) -> String in
                 let data = QueryDocumentSnapshot.data()
                 let title = data["title"] as? String ?? ""
                 let content = data["content"] as? String ?? ""
                 return content
             }
         }
     }
    
    
    func getSportsCat(){
        db.collection("art").whereField("category", isEqualTo: "sports").addSnapshotListener{(querySnapshot, error ) in
            guard let documents = querySnapshot?.documents else {
                print("no docs")
                return
            }
            self.myarticles = documents.map{(QueryDocumentSnapshot) -> MyArticles in
                let data = QueryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let content = data["content"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                return MyArticles(title: title, content: content, image: image, category: category)
            }
        }
    }
    func getMusicCat(){
        db.collection("art").whereField("category", isEqualTo: "music").addSnapshotListener{(querySnapshot, error ) in
            guard let documents = querySnapshot?.documents else {
                print("no docs")
                return
            }
            self.myarticles = documents.map{(QueryDocumentSnapshot) -> MyArticles in
                let data = QueryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let content = data["content"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                return MyArticles(title: title, content: content, image: image, category: category)
            }
        }
    }
    func getTechnologyCat(){
        db.collection("art").whereField("category", isEqualTo: "technology").addSnapshotListener{(querySnapshot, error ) in
            guard let documents = querySnapshot?.documents else {
                print("no docs")
                return
            }
            self.myarticles = documents.map{(QueryDocumentSnapshot) -> MyArticles in
                let data = QueryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let content = data["content"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                return MyArticles(title: title, content: content, image: image, category: category)
            }
        }
    }
    func getGossipCat(){
        db.collection("art").whereField("category", isEqualTo: "gossip").addSnapshotListener{(querySnapshot, error ) in
            guard let documents = querySnapshot?.documents else {
                print("no docs")
                return
            }
            self.myarticles = documents.map{(QueryDocumentSnapshot) -> MyArticles in
                let data = QueryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let content = data["content"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                return MyArticles(title: title, content: content, image: image, category: category)
            }
        }
    }
}


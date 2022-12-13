//
//  MyArticles.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 6/11/22.
//

import SwiftUI

struct MyArticles: Codable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var content: String
    var image: String
    var category: String
}

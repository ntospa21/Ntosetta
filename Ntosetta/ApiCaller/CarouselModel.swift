//
//  CarouselModel.swift
//  Ntosetta
//
//  Created by Pantos, Thomas on 4/7/23.
//

import Foundation

struct MiniArticle :  Codable, Identifiable {
    
    var id: String = UUID().uuidString
    var title: String
    var image: String

}

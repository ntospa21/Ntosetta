//
//  VoiceContent.swift
//  Ntosetta
//
//  Created by Pantos, Thomas on 2/2/23.
//

import Foundation

struct VoiceContent : Codable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var content: String
}

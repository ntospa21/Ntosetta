//
//  RegistrationDetails.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 27/11/22.
//

import Foundation

struct RegistrationDetails {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    
}

extension RegistrationDetails {
    static var new: RegistrationDetails {
        RegistrationDetails(email: "", password: "", firstName: "", lastName: "")
    }
}

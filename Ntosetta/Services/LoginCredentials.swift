//
//  LoginCredentials.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 27/11/22.
//

import Foundation

struct LoginCredentials{
    var email: String
    var password: String
}
extension LoginCredentials {
    static var new: LoginCredentials {
        LoginCredentials(email: "", password: "")
    }
}

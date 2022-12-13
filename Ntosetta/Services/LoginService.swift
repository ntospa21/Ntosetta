//
//  LoginService.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 27/11/22.
//

import Foundation
import Combine
import Firebase

protocol LoginService{
    func login(with credentials: LoginCredentials) -> AnyPublisher<Void, Error>
    
}

final class LoginServiceImpl: LoginService {
    func login(with credentials: LoginCredentials) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth.auth()
                    .signIn(withEmail: credentials.email, password: credentials.password){
                        res, error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}

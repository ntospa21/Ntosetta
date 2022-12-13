//
//  ForgotPasswordViewModel.swift
//  Ptuxiaki
//
//  Created by Pantos, Thomas on 27/11/22.
//

import Foundation
import Combine

protocol ForgotPasswordViewModel{
    func sendPasswordReset()
    var service: ForgotPasswordService { get }
    var email: String { get }
    init(service: ForgotPasswordService)
}

final class ForgotPasswordViewModelImpl: ForgotPasswordViewModel, ObservableObject {
    @Published var email: String = ""
    private var subscriptions = Set<AnyCancellable>()
    let service: ForgotPasswordService
    init(service: ForgotPasswordService ){
        self.service = service
    }
    
    func sendPasswordReset(){
        service
            .sendPasswordReset(to: email)
            .sink{ res in
                switch res {
                case .failure(let err):
                    print("Failed \(err)")
                default: break
                }
            } receiveValue: {
                print("Sent password reset request")
            }
            .store(in: &subscriptions)
    }
}

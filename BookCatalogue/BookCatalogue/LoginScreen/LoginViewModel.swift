//
//  LoginViewModel.swift
//  BookCatalogue
//
//  Created by pc on 23/05/23.
//

import Foundation
import Firebase

class LoginViewModel {
    
    init() { }
    
    var prefilledFormFieldValuesHandler: (()->())?
    var email: String?
    var password: String?

    func registerUser(completionHandler: @escaping (AuthDataResult?, Error?)->())  {
        guard let email = email?.lowercased(), let password = password else {
            return
        }
        NetworkManager.shared.registerUser(email: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error registering user: \(error.localizedDescription)")
                completionHandler(nil, error)
            } else {
                print("User registered successfully.")
                completionHandler(authResult, nil)
                // Handle successful user registration, such as navigating to the main app screen
            }
        }
    }

    func loginUser(completionHandler: @escaping (AuthDataResult?, Error?)->())  {
        guard let email = email?.lowercased(), let password = password else {
            return
        }

        NetworkManager.shared.loginUser(email: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                completionHandler(nil, error)
            } else {
                print("User logged in successfully.")
                completionHandler(authResult, nil)
            }
        }
    }
}


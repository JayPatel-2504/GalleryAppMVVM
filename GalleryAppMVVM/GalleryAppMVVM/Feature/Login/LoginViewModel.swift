//
//  LoginViewModel.swift
//  GalleryAppMVVM
//
//  Created by Shiv's on 03/03/26.
//

import Foundation
import GoogleSignIn

class LoginViewModel {
    
    //MARK: - Sign-In with Google
    func signIn(presentingViewController: UIViewController,
                completion: @escaping (Result<GIDGoogleUser, Error>) -> Void) {
    
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else { return }
            completion(.success(user))
        }
        
    }
    
}

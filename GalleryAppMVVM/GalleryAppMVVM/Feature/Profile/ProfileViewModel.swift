//
//  ProfileViewModel.swift
//  GalleryAppMVVM
//
//  Created by Shiv's on 03/03/26.
//

import Foundation
import GoogleSignIn

class ProfileViewModel {
    
    //MARK: - Variable
    var userName: String {
        return UserDefaults.standard.string(forKey: AppConstants.userName) ?? "No Name"
    }
    
    var userEmail: String {
        return UserDefaults.standard.string(forKey: AppConstants.userEmail) ?? "No Email"
    }
    
    var userProfileImageURL: URL? {
        if let urlString = UserDefaults.standard.string(forKey: AppConstants.userProfileImageURL) {
            return URL(string: urlString)
        }
        return nil
    }
    
    //MARK: - Logout method
    func logout(completion: @escaping () -> Void) {
        GIDSignIn.sharedInstance.signOut()
        UserDefaults.standard.set(false, forKey: AppConstants.isLoggedIn)
        UserDefaults.standard.synchronize()
        completion()
    }
    
}

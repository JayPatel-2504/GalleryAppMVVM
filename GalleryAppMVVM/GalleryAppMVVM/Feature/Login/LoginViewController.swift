//
//  LoginViewController.swift
//  GalleryAppMVVM
//
//  Created by Shiv's on 03/03/26.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - Variable
    private let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLoginButton()
    }

}

extension LoginViewController {
    
    //MARK: - UI SetUp
    private func setLoginButton() {
        loginButton.layer.cornerRadius = 10
    }
    
}

extension LoginViewController {
    
    //MARK: - Button Action
    @IBAction func googleSignINButtonTapped(_ sender: UIButton) {
        
        viewModel.signIn(presentingViewController: self) { [weak self] result in
            
            switch result {
            
            case .success(let user):
                self?.navigateToGallery(user: user.profile)
            
            case .failure(let error):
                print("Login Error: \(error.localizedDescription)")
                
            }
            
        }
        
    }
    
    
    // MARK: - Navigation
    private func navigateToGallery(user: GIDProfileData?) {
        UserDefaults.standard.set(true, forKey: AppConstants.isLoggedIn)
        UserDefaults.standard.setValue(user?.name, forKey: AppConstants.userName)
        UserDefaults.standard.setValue(user?.email, forKey: AppConstants.userEmail)
        UserDefaults.standard.set(user?.imageURL(withDimension: 200)?.absoluteString, forKey: "userProfileImageURL")
        UserDefaults.standard.synchronize()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let galleryVC = storyboard.instantiateViewController(withIdentifier: "GalleryViewController")
        let nav = UINavigationController(rootViewController: galleryVC)
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = nav
        }
    }
    
}

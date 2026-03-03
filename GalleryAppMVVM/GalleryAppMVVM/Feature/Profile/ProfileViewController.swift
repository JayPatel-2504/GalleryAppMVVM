//
//  ProfileViewController.swift
//  GalleryAppMVVM
//
//  Created by Shiv's on 03/03/26.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    //MARK: - Variable
    private var viewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationBar()
        setLogoutButtton()
        setUserProfileImage()
        setUserData()
    }

}

extension ProfileViewController {
    
    //MARK: - UI SetUp
    private func setNavigationBar() {
        title = "Profile"
    }
    
    private func setLogoutButtton() {
        logoutButton.layer.cornerRadius = 10
    }
    
    private func setUserProfileImage() {
        
        imageProfile.contentMode = .scaleAspectFill
        imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
        imageProfile.clipsToBounds = true
     
        imageProfile.sd_setImage(
            with: viewModel.userProfileImageURL,
            placeholderImage: UIImage(named: "person.circle"),
            options: [.retryFailed, .highPriority, .continueInBackground, .refreshCached],
            completed: nil
        )
    }
    
    private func setUserData() {
        lblName.text = viewModel.userName
        lblEmail.text = viewModel.userEmail
    }
    
}

//MARK: - Button Action
extension ProfileViewController {
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        viewModel.logout { [weak self] in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                let nav = UINavigationController(rootViewController: loginVC)
                
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = nav
                }
            }
            
        }
        
    }
    
}

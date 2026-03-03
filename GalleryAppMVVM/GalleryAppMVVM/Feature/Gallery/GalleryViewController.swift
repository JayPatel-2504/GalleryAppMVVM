//
//  GalleryViewController.swift
//  GalleryAppMVVM
//
//  Created by Shiv's on 03/03/26.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDelegate {
    
    //MARK: - Outlet
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variable
    private var viewModel: GalleryViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViewModel()
        setUpNavigationBar()
        setUpCollectionView()
        fetchImages()
        checkInternetConnection()
        
    }

}

extension GalleryViewController {
    
    //MARK: - UI SetUp
    private func setUpNavigationBar() {
        
        title = "Gallery"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(profileTapped)
        )
        
    }
    
    @objc private func profileTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func setUpCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        
        let spacing: CGFloat = 10
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = floor((screenWidth - spacing * 3) / 2)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing,
                                           bottom: spacing, right: spacing)
        collectionView.collectionViewLayout = layout
        
    }
    
    private func setUpViewModel() {
        let apiService = APIService()
        viewModel = GalleryViewModel(apiService: apiService)
    }
    
    //MARK: - APIs call
    private func fetchImages() {
        
        LoaderManager.shared.show(on: self.view)
        
        viewModel.fetchImages { [weak self] in
            
            guard let self = self else { return }
            
            LoaderManager.shared.hide()
            self.collectionView.reloadData()
        }
    }
    
    private func checkInternetConnection() {
        
        updateNetworkLabel(isConnected: NetworkMonitor.shared.isConnected)
        
        NetworkMonitor.shared.networkChange = { [weak self] isConnected in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateNetworkLabel(isConnected: isConnected)
            }
        }
        
    }
    
    func updateNetworkLabel(isConnected: Bool) {
        self.networkLabel.text = isConnected ? "Online" : "Offline"
        self.networkLabel.backgroundColor = isConnected ? .systemGreen : .systemRed
        self.networkLabel.isHidden = false
    }
    
    
}

//MARK: - Collectionview Method
extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        let imageURL = viewModel.images[indexPath.row].downloadUrl
        cell.configure(urlString: imageURL)
        
        return cell
        
    }
    
    
}

//MARK: - Pagination
extension GalleryViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        
        if position > (collectionView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            viewModel.fetchImages { [weak self] in
                guard let self = self else { return }
                
                self.collectionView.reloadData()
            }
            
        }
        
    }
    
}

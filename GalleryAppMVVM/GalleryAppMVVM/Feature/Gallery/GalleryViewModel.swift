//
//  GalleryViewModel.swift
//  GalleryAppMVVM
//
//  Created by Shiv's on 03/03/26.
//

import Foundation

class GalleryViewModel {
    
    private let apiService: APIServiceProtocol
    
    var images: [ImageModel] = []
    var currentPage = 1
    var isLoading = false
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    //MARK: - Fetching images from the APIs or CoreData
    func fetchImages(complition: @escaping () -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        if NetworkMonitor.shared.isConnected {
            
            apiService.fetchImages(page: currentPage) { [weak self] result in
                
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                    
                case .success(let images):
                    
                    self.images.append(contentsOf: images)
                    self.currentPage += 1
                    
                    CoreDataManager.shared.saveImages(self.images )
                    
                    complition()
                    
                    
                case .failure(let error):
                    print(error)
                    complition()
                    
                }
                
            }
            
        } else {
            
            let saveImages = CoreDataManager.shared.fetchImages()
            
            self.images = saveImages.map {
                ImageModel(
                    id: $0.id ?? "",
                    downloadUrl: $0.downloadURL ?? ""
                )
            }
            
            DispatchQueue.main.async {
                complition()
            }
            
        }
        
    }
    
}

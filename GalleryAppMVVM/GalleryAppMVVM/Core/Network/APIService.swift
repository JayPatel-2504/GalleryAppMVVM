//
//  APIService.swift
//  GalleryAppMVVM
//
//  Created by Shiv's on 03/03/26.
//

import Foundation

protocol APIServiceProtocol {
    func fetchImages(page: Int, completion: @escaping (Result<[ImageModel], Error>) -> Void)
}

class APIService: APIServiceProtocol{
    
    func fetchImages(page: Int, completion: @escaping (Result<[ImageModel], Error>) -> Void) {
        
        let urlString = "https://picsum.photos/v2/list?page=\(page)&limit=20"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let images = try JSONDecoder().decode([ImageModel].self, from: data)
                        completion(.success(images))
                } catch {
                    completion(.failure(error))
                }
            }
            
        }.resume()
        
    }
    
}

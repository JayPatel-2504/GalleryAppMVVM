//
//  ImageModel.swift
//  GalleryAppMVVM
//
//  Created by Shiv's on 03/03/26.
//

import Foundation

struct ImageModel: Codable {
    let id: String
    let downloadUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case downloadUrl = "download_url"
    }
}

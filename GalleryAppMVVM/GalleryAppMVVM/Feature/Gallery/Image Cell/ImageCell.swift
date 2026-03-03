//
//  ImageCell.swift
//  GalleryAppMVVM
//
//  Created by Shiv's on 03/03/26.
//

import UIKit
import SDWebImage

class ImageCell: UICollectionViewCell {
    
    //MARK: - Outlet
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    //MARK: - Image configration
    func configure(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        imageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(systemName: "photo"),
            options: [.retryFailed, .highPriority, .continueInBackground, .refreshCached],
            completed: nil
            )
        
    }

}

//
//  LoaderManager.swift
//  GalleryAppMVVM
//
//  Created by Shiv's on 03/03/26.
//

import UIKit

final class LoaderManager {
    
    static let shared = LoaderManager()
    private var loaderView: UIView?
    
    private init() {}
    
    func show(on view: UIView) {
        
        // Prevent multiple loaders
        if loaderView != nil { return }
        
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        backgroundView.addSubview(activityIndicator)
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
        
        loaderView = backgroundView
    }
    
    func hide() {
        loaderView?.removeFromSuperview()
        loaderView = nil
    }
}

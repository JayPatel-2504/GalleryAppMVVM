//
//  NetworkMonitor.swift
//  GalleryAppMVVM
//
//  Created by Shiv's on 03/03/26.
//

import Network

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isConnected = false
    var networkChange: ((Bool) -> Void)?
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            
            guard let self = self else {return}
            
            self.isConnected = path.status == .satisfied
            if let networkComplition = self.networkChange {
                networkComplition(self.isConnected)
            }
        }
        monitor.start(queue: queue)
    }
    
}

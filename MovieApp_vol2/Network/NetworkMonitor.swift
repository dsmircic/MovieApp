//
//  NetworkMonitor.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 05.05.2022..
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: Connection?
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in self?.isConnected = path.status == .satisfied }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    public func getConnectionType(path: NWPath) {
        
        if (path.usesInterfaceType(.wifi)) {
            connectionType = .wifi
        } else if (path.usesInterfaceType(.cellular)) {
            connectionType = .cellular
        } else if (path.usesInterfaceType(.wiredEthernet)) {
            connectionType = .ethernet
        } else {
            connectionType = nil
        }
        
    }
    
    
    enum Connection {
        case wifi
        case cellular
        case ethernet
    }
    
    
}

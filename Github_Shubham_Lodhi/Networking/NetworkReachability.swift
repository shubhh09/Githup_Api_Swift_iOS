//
//  Network.swift
//  Github_Shubham_Lodhi
//
//  Created by SHUBHAM on 18/07/24.
//

import Foundation
import SystemConfiguration

class NetworkReachabilityManager {
    
    static let shared = NetworkReachabilityManager()
    
    private var reachability: SCNetworkReachability?
    
    private init() {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com") else { return }
        self.reachability = reachability
    }
    
    var isConnectedToNetwork: Bool {
        var flags = SCNetworkReachabilityFlags()
        guard let reachability = reachability, SCNetworkReachabilityGetFlags(reachability, &flags) else { return false }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    func startListening() {
        guard let reachability = reachability else { return }
        
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        
        if SCNetworkReachabilitySetCallback(reachability, { (_, flags, info) in
            if let info = info {
                let manager = Unmanaged<NetworkReachabilityManager>.fromOpaque(info).takeUnretainedValue()
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .networkReachabilityChanged, object: manager)
                }
            }
        }, &context) {
            SCNetworkReachabilitySetDispatchQueue(reachability, DispatchQueue.main)
        }
    }
    
    func stopListening() {
        guard let reachability = reachability else { return }
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
    }
}

extension Notification.Name {
    static let networkReachabilityChanged = Notification.Name("networkReachabilityChanged")
}

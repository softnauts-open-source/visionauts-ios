//
//  ServiceFactory+BeaconServiceProvider.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 13/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation

extension ServiceFactory {

    // Beacon service providers
    enum BeaconServiceProvider {
        case defaultService
        case kontakt
    }
    
    /// Beacon Service selector according to chosen provider.
    ///
    /// The service must be adapted by Beacon Service Adapter.
    ///
    /// - Parameters:
    ///   - provider: service provider
    ///   - configuration: beacon service configuration
    /// - Returns: returns beacon service of the provider type
    static func beaconService<T: NSObject>(provider: BeaconServiceProvider, _ configuration: BeaconConfiguration? = nil) -> T where T: BeaconServiceAdapter {
        switch provider {
            
        case .defaultService:
            let service = BeaconDefaultService.shared
            if let configuration = configuration {
                service.configuration = configuration
            }
            return service as! T
            
        case .kontakt:
            let service = BeaconKTKService.shared
            if let configuration = configuration {
                service.configuration = configuration
            }
            return service as! T
        }
    }
}

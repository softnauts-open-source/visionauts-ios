//
//  BeaconsRouter.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import Alamofire

enum BeaconsRouter: URLRequestConvertible {
    case getBeacons
    
    static let baseURL = "https://your-api-domain.com"
    
    var method: HTTPMethod {
        switch self {
        
        case .getBeacons:
            return .get
        }
    }

    var path: String {
        switch self {
        
        case .getBeacons:
            return "/api/beacons"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try BeaconsRouter.baseURL.asURL()
        
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        switch self {
            
        case .getBeacons:
            urlRequest = try JSONEncoding.default.encode(urlRequest)
        }
        
        return urlRequest
    }
}

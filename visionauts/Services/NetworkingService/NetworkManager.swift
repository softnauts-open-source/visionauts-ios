//
//  NetworkManager.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkManagerReachability: class {
    func isConnectedToNetwork() -> Bool
}

class NetworkManager: NetworkAdapter {
    
    // Session Manager
    var sessionManager: Alamofire.SessionManager
    
    // OAuth Handler
    var oauthHandler: OAuthHandler?
    
    // Shared Instance
    static let shared = NetworkManager()
    
    //MARK: - Init
    
    private init() {
        self.sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    }
    
    //MARK: - Request
    
    func apiRequest(_ request: URLRequestConvertible, OAuth: Bool, responseHandler: @escaping (ServiceResponse<Any>) -> Void) {
        var sessionManager: Alamofire.SessionManager
        
        if OAuth {
            sessionManager = self.sessionManager
            sessionManager.adapter = oauthHandler
            sessionManager.retrier = oauthHandler
        } else {
            sessionManager = Alamofire.SessionManager.default
        }
        
        sessionManager.request(request)
        .validate()
            .responseJSON { (response) in
                responseHandler(response.serviceResponseJson)
        }
    }
    
    func apiDataRequest(_ request: URLRequestConvertible, OAuth: Bool, responseHandler: @escaping (ServiceResponse<Data>) -> Void) {
        var sessionManager: Alamofire.SessionManager
        
        if OAuth {
            sessionManager = self.sessionManager
            sessionManager.adapter = oauthHandler
            sessionManager.retrier = oauthHandler
        } else {
            sessionManager = Alamofire.SessionManager.default
        }
        
        sessionManager.request(request)
        .validate()
            .responseData { (response) in
                responseHandler(response.serviceResponseData)
        }
    }
    
    func apiStringRequest(_ request: URLRequestConvertible, OAuth: Bool, responseHandler: @escaping (ServiceResponse<String>) -> Void) {
        var sessionManager: Alamofire.SessionManager
        
        if OAuth {
            sessionManager = self.sessionManager
            sessionManager.adapter = oauthHandler
            sessionManager.retrier = oauthHandler
        } else {
            sessionManager = Alamofire.SessionManager.default
        }
        
        sessionManager.request(request)
            .validate()
            .responseString { (response) in
                responseHandler(response.serviceResponseString)
        }
    }
    
    func apiMockRequest(_ request: URLRequestConvertible, OAuth: Bool,
                        requestDelay: Double = 0,
                        mockResponse: MockingResponse<Any>,
                        responseHandler: @escaping (ServiceResponse<Any>) -> Void) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + requestDelay) {
            switch mockResponse {
                
            case .success(let value):
                responseHandler(ServiceResponse.success(value: value))
            case .failure(let error):
                let message = "[Error]: \((error as NSError).code), \(error.localizedDescription)"
                print(message)
                responseHandler(ServiceResponse.failure(message: message))
            }
        }
    }
    
    //MARK: Refresh tokens 
    
    func refreshTokens(_ request: URLRequestConvertible, completionHandler: @escaping (String?, String?) -> Void) {
        self.apiRequest(request, OAuth: true) { (response) in
            switch response {
            
            case .success(let value):
                guard let value = value as? JsonData,
                    let token = value["token"] as? String
                    else {
                        completionHandler(nil, nil)
                        return
                }
                
                let refreshToken = value["refreshToken"] as? String
                
                completionHandler(token, refreshToken)
                
            case .failure:
                completionHandler(nil, nil)
            }
        }
    }
}

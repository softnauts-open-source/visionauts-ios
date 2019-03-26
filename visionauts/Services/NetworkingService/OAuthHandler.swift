//
//  OAuthHandler.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 20/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import Alamofire

class OAuthHandler: RequestAdapter, RequestRetrier {

    private typealias RefreshCompletion = (_ _succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    
    private let lock = NSLock()
    
    // Tokens
    private var accessToken: String
    private var refreshToken: String?
    
    // Refreshing
    private var isRefreshing: Bool = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // Refresh tokens request
    var refreshTokensRequest: URLRequestConvertible
    
    // Session Manager
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()
    
    //MARK: - Init
    
    init(refreshTokensRequest: URLRequest, accessToken: String, refreshToken: String?) {
        self.refreshTokensRequest = refreshTokensRequest
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    //MARK: - Adapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    //MARK: - Retrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock(); defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                
                refreshTokens { [weak self] (succeded, accessToken, refreshToken) in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock(); defer { strongSelf.lock.unlock() }
                    
                    if let accessToken = accessToken, let refreshToken = refreshToken {
                        strongSelf.accessToken = accessToken
                        strongSelf.refreshToken = refreshToken
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        }
    }
    
    //MARK: - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        NetworkManager.shared.refreshTokens(refreshTokensRequest) { (token, refreshToken) in
            if let token = token {
                completion(true, token, refreshToken)
            } else {
                completion(false,nil,nil)
            }
        }
    }
}

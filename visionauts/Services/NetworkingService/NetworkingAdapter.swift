//
//  NetworkingAdapter.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import Alamofire

// Data types
public typealias JsonData = [String : Any]
public typealias JsonArrayData = [[String : Any]]
public typealias JsonErrors = [[String : Any]]

//MARK: - Adapter

protocol NetworkAdapter {
    
    associatedtype NetworkRequest
    associatedtype OAuth
    
    var oauthHandler: OAuth? { get set }
    
    /// Default request with Json response
    ///
    /// - Parameters:
    ///   - request: generic type request
    ///   - OAuth: true or false
    ///   - responseHandler: closure with result Any (typically JsonData)
    func apiRequest(_ request: NetworkRequest,
                    OAuth: Bool,
                    responseHandler: @escaping(ServiceResponse<Any>) -> Void)
    
    /// Request with Data response
    ///
    /// - Parameters:
    ///   - request: generic type request
    ///   - OAuth: true or false
    ///   - responseHandler: closure with result Data
    func apiDataRequest(_ request: NetworkRequest,
                        OAuth: Bool,
                        responseHandler: @escaping(ServiceResponse<Data>) -> Void)
    
    /// Request with String response
    ///
    /// - Parameters:
    ///   - request: generic type request
    ///   - OAuth: true or false
    ///   - responseHandler: closure with result String
    func apiStringRequest(_ request: NetworkRequest,
                          OAuth: Bool,
                          responseHandler: @escaping(ServiceResponse<String>) -> Void)
    
    /// Default mock request with json response
    ///
    /// - Parameters:
    ///   - request: generic type request
    ///   - OAuth: true or false
    ///   - responseHandler: closure with result Any (typically JsonData)
    func apiMockRequest(_ request: NetworkRequest,
                        OAuth: Bool,
                        requestDelay: Double,
                        mockResponse: MockingResponse<Any>,
                        responseHandler: @escaping(ServiceResponse<Any>) -> Void)
    
    /// Refresh tokens
    ///
    /// - Parameters:
    ///   - request: generic type request used for refreshing
    ///   - completionHandler: refreshed tokens result
    func refreshTokens(_ request: NetworkRequest,
                       completionHandler: @escaping (_ token: String?, _ refreshToken: String?) -> Void)
}

// Service response
public enum ServiceResponse<Type> {
    case success(value: Type)
    case failure(message: String)
}

//MARK: - Mocking

protocol Mockable {
    var mockSuccess: JsonData { get }
    var mockFailure: Error { get }
}

// Mocking response
public enum MockingResponse<Type> {
    case success(value: Type)
    case failure(error: Error)
}

//MARK: - Adapting to Alamofire

extension Alamofire.DataResponse {
    
    // Response Json
    
    public var serviceResponseJson: ServiceResponse<Any> {
        
        switch self.result {
        
        case .success(_):
            let response = self.result.value
            guard response is JsonData || response is JsonArrayData else {
                print("[Api JSON Validation] Error: \(String(describing: self.request))")
                return .failure(message: "Did not receive JSON response")
            }
            
            return ServiceResponse.success(value: response!)
            
        case .failure(let error):
            let message = buildErrorMessage(using: error)
            print(message)
            return ServiceResponse.failure(message: message)
        }
    }
    
    // Response Data
    
    public var serviceResponseData: ServiceResponse<Data> {
        switch self.result {
        
        case .success(_):
            guard let response = self.result.value as? Data else {
                return .failure(message: "Did not receive any data in response")
            }
            
            return ServiceResponse.success(value: response)
            
        case .failure(let error):
            let message = buildErrorMessage(using: error)
            print(message)
            return ServiceResponse.failure(message: message)
        }
    }
    
    // Response String
    
    public var serviceResponseString: ServiceResponse<String> {
        switch self.result {
        
        case .success(_):
            guard let response = self.result.value as? String else {
                print("[Api String Validation] Error: \(String(describing: self.request))")
                return .failure(message: "Did not receive String response")
            }
            
            return ServiceResponse.success(value: response)
            
        case .failure(let error):
            let message = buildErrorMessage(using: error)
            print(message)
            return ServiceResponse.failure(message: message)
        }
    }
    
    //MARK: - Helpers
    
    func buildErrorMessage(using error: Error) -> String {
        if let httpStatusCode = self.response?.statusCode {
            return "[ApiError]: code = \(httpStatusCode), " + error.localizedDescription
        } else {
            return "[Api Error]: " + error.localizedDescription
        }
    }
}

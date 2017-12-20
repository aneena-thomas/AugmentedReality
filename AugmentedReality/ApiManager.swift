//
//  ApiManager.swift
//  Sabarimala
//
//  Created by MAC on 23/10/17.
//  Copyright © 2017 Experion Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper


let authorizationToken: NSString = BEARER
extension AugmentedReality_E_NetWorK {
    public var baseURL: URL { return URL(string: BASE_URL )! }
    public var path: String {
        switch self {
        case .LOGIN:
            return "/login"
        
        }
    }
    
    public func url() -> String {
        return self.baseURL.appendingPathComponent(self.path).absoluteString.removingPercentEncoding!
    }
    
    public var headers: HTTPHeaders? {
        switch self {
        case .LOGIN:
            return ["X-Grant-Type": "password"]
       
        }
    }
    public var method: Alamofire.HTTPMethod {
        switch self {
        // Add the post requests here, separated by comma
        case .LOGIN:
        return .post
      
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
            return JSONEncoding.default
        
    }
}

class SabarimalaApi {
    
    class func request(route: AugmentedReality_E_NetWorK, body: Parameters?) -> DataRequest {
        print("url = \(route.url())")
        return Alamofire.request (route.url(), method: route.method, parameters: body,
                                  encoding: route.parameterEncoding, headers: route.headers)
    }
    
//    class func login(username: String, password: String, completionHandler: @escaping (LoggedInUser?) -> Void) {
//
//        let body = ["username": username, "password": password]
//
//        request(route: .login, body: body).responseObject { (response: DataResponse<LoggedInUser>) in
//            response.result.ifSuccess({
//                completionHandler(response.result.value)
//            })
//
//            response.result.ifFailure {
//                completionHandler(nil)
//            }
//        }
//    }
   

}

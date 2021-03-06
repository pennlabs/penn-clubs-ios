//
//  Networking.swift
//  PennMobile
//
//  Created by Josh Doman on 7/31/17.
//  Copyright © 2017 PennLabs. All rights reserved.
//
import Foundation
import SwiftUI

func getDeviceID() -> String {
    let deviceID = UIDevice.current.identifierForVendor!.uuidString
    #if DEBUG
       return "test"
    #else
        return deviceID
    #endif
}

public enum Method {
    case delete
    case get
    case head
    case post
    case put
    case connect
    case options
    case trace
    case patch
    case other(method: String)
}

extension Method {
    public init(_ rawValue: String) {
        let method = rawValue.uppercased()
        switch method {
        case "DELETE":
            self = .delete
        case "GET":
            self = .get
        case "HEAD":
            self = .head
        case "POST":
            self = .post
        case "PUT":
            self = .put
        case "CONNECT":
            self = .connect
        case "OPTIONS":
            self = .options
        case "TRACE":
            self = .trace
        case "PATCH":
            self = .patch
        default:
            self = .other(method: method)
        }
    }
}

extension Method: CustomStringConvertible {
    public var description: String {
        switch self {
        case .delete:            return "DELETE"
        case .get:               return "GET"
        case .head:              return "HEAD"
        case .post:              return "POST"
        case .put:               return "PUT"
        case .connect:           return "CONNECT"
        case .options:           return "OPTIONS"
        case .trace:             return "TRACE"
        case .patch:             return "PATCH"
        case .other(let method): return method.uppercased()
        }
    }
}

protocol Requestable {}

extension Requestable {
    internal func getRequest(url: String, callback: @escaping (_ json: NSDictionary?,  _ error: Error?, _ status: Int?) -> ()) {
        request(method: .get, url: url, params: nil) { (data, dict, error, status) in
            callback(dict, error, status)
        }
    }

    internal func getRequestData(url: String, callback: @escaping (_ data: Data?,  _ error: Error?, _ status: Int?) -> ()) {
        request(method: .get, url: url, params: nil) { (data, dict, error, status) in
            callback(data, error, status)
        }
    }

    internal func postRequestData(url: String, params: [NSString: Any]? = nil, callback: @escaping (_ data: Data?,  _ error: Error?, _ status: Int?) -> ()) {
        request(method: .post, url: url, params: params) { (data, _, error, status) in
            callback(data, error, status)
        }
    }

    internal func request(method: Method, url: String, params: [NSString: Any]? = nil, callback: ((_ data: Data?, _ json: NSDictionary?, _ error: Error?, _ status: Int?) -> ())? = nil)  {
        guard let url = URL(string: url) else {
            return
        }

        let request = NSMutableURLRequest(url: url)
        request.cachePolicy = .reloadIgnoringCacheData

        let deviceID = getDeviceID()
        request.setValue(deviceID, forHTTPHeaderField: "X-Device-ID")
        
//        TODO: Figure out what this enables
//        if let accountID = UserDefaults.standard.getAccountID() {
//            request.setValue(accountID, forHTTPHeaderField: "X-Account-ID")
//        }
        
        request.httpMethod = method.description
        if let params = params {
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("super secret password", forHTTPHeaderField: "Authorization")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        }

        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in

            if let error = error {
                // indicates that user is unable to connect to internet
                callback?(nil, nil, error, nil)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data, let _ = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        if let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary) as NSDictionary??) {
                            //data recieved and parsed successfully
                            callback?(data, json, nil, 200)
                        }
                    } else {
                        //could not serialize json
                        callback?(nil, nil, nil, 200)
                    }
                } else {
                    //response code is not 200
                    callback?(nil, nil, nil, httpResponse.statusCode)
                }
            }

        })
        task.resume()
    }
}

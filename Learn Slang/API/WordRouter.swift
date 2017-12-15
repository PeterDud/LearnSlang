//
//  WordRouter.swift
//  Learn Slang
//
//  Created by user on 14/12/2017.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import Alamofire

public struct WordRouter: URLRequestConvertible {
    
    static let baseURLPath = "http://api.urbandictionary.com/v0/define?term="
    let word: String
    
    public func asURLRequest() throws -> URLRequest {
        
        let urlString = WordRouter.baseURLPath + word
        let url = try urlString.asURL()

        var request = URLRequest(url: url)
        
        print(request)
        print(word)
        
        request.httpMethod = "GET"
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: nil)
    }
}


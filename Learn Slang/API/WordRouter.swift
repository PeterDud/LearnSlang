//
//  WordRouter.swift
//  Learn Slang
//
//  Created by user on 14/12/2017.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import Alamofire

class WordRouter: URLRequestConvertible {
    
    let baseURLString = "http://api.urbandictionary.com/v0/define?term="
    let word: String
    lazy var urlString: String = {
        
        var urlStr = baseURLString + word
        if urlStr.contains(" ") { // space is not valid character in URL, so we need to replace it with %20
            urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            return urlStr
        }
        return urlStr
    }()
    
    init(word: String) {
        self.word = word
    }

    public func asURLRequest() throws -> URLRequest {
        
        let url = try urlString.asURL()

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: nil)
    }
}

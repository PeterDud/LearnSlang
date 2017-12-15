//
//  ServerManager.swift
//  Learn Slang
//
//  Created by user on 13/12/2017.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import Alamofire

class ServerManager {
    
    static var shared = ServerManager()
    
    private init() {
    }

    func downloadWord (word: String, completion: @escaping ([String]) -> Void) -> () {
        
        Alamofire.request(WordRouter(word: word)).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                print("Error while fetching word: \(response.result.error)")

                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any],
            let list = responseJSON["list"] as? [[String: Any]] else {
                    print("Error while fetching word: \(response.result.error)")
                    return
            }
            
            var words = [String]()
            var definitions = [String]()
            
            for word in list {
                
                words.append(word["word"] as! String)
                definitions.append(word["definition"] as! String)
            }
            
            completion(definitions)
        }
    }
}






























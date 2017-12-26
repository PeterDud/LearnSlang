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

    func downloadWord (word: String, completion: @escaping (Result<WordModel>) -> Void) -> () {
        
        Alamofire.request(WordRouter(word: word)).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                print("Error while fetching word: \(String(describing: response.result.error))") 

                completion(.Error(response.result.error!.localizedDescription))
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any],
            let list = responseJSON["list"] as? [[String: Any]],
            let spellingsURLs = responseJSON["sounds"] as? [String] else {
                print("Error while fetching word: \(String(describing: response.result.error))")
                    return
            }
            
            guard list.count > 0 else {
                completion(.NotFound)
                return
            }
            
            var words = [String]()
            var defsAndExamps = [DefinitionAndExample]()
            
            for word in list {
                
                words.append(word["word"] as! String)
                let defAndExamp = DefinitionAndExample(definition: word["definition"] as! String,
                                                       example: word["example"] as! String)
                defsAndExamps.append(defAndExamp)
            }

            let wordModel = WordModel(word: words[0],
                                      defsAndExamps: NSOrderedSet(array: defsAndExamps),
                                      spellingURL: spellingsURLs.count > 0 ? spellingsURLs[0] : "")
            
            completion(.Success(wordModel))
        }
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
    case NotFound
}

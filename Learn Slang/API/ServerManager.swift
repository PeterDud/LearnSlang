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

    func downloadWord (word: String, completion: @escaping (Result) -> Void) -> () {
        
        Alamofire.request(WordRouter(word: word)).responseJSON { (response) in
            
            guard response.result.isSuccess else {

                let responseError = response.result.error!
                let errorDescription = responseError.localizedDescription
                completion(.Error("ERROR WHILE DOWNLOADING WORD: \(errorDescription)"))
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any],
                  let list = responseJSON["list"] as? [[String: Any]],
                  let spellingsURLs = responseJSON["sounds"] as? [String] else {
                
                completion(.Error("ERROR WHILE FETCHING WORD"))
                return
            }
            
            guard list.count > 0 else {
                completion(.NotFound)
                return
            }
            
            var words = [String]()
            var definitions = [DefinitionModel]()
            var definitionsSet = Set<String>()

            for word in list {
                words.append(word["word"] as! String)

                let definitionStr = word["definition"] as! String // here we need to make sure we don't save similar definitions. If we get similar definitions only one of them is saved and all examples of unsaved definitions are also saved to that one definition.
                if definitionsSet.contains(where: {$0.caseInsensitiveCompare(definitionStr) == .orderedSame}) {
                    for definition in definitions {
                        if definition.definition.caseInsensitiveCompare(definitionStr) == .orderedSame {
                            definition.examples.append(word["example"] as! String)
                        }
                    }
                } else {
                    let definition = DefinitionModel(definition: definitionStr, examples: [word["example"] as! String])
                    definitions.append(definition)
                    definitionsSet.insert(word["definition"] as! String)
                }
            }
            
            let wordModel = WordModel(word: words[0],
                                      definitions: definitions,
                                      spellingURL: spellingsURLs.count > 0 ? spellingsURLs[0] : nil)
            
            completion(.Success(wordModel))
        }
    }
}

enum Result {
    case Success(WordModel)
    case Error(String)
    case NotFound
}

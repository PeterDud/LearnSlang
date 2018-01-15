//
//  Word.swift
//  Learn Slang
//
//  Created by user on 19/12/2017.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation

class WordModel: NSObject {
    
    let word: String
    let definitions: [DefinitionModel]   // Ordered set of DefinitionModel objects, each object has an array of "example" strings as its property.
    let spellingURL: String
    
    init(word: String, definitions: [DefinitionModel], spellingURL: String) {
        self.word = word
        self.definitions = definitions 
        self.spellingURL = spellingURL
    }
}

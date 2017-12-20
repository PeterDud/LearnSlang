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
    let defsAndExamps: NSOrderedSet
    let spellingURL: String
    
    init(word: String, defsAndExamps: NSOrderedSet, spellingURL: String) {
        self.word = word
        self.defsAndExamps = defsAndExamps
        self.spellingURL = spellingURL
    }
}

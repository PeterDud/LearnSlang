//
//  DefinitionAndExample.swift
//  Learn Slang
//
//  Created by user on 20/12/2017.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

// We need this class to make sure every definition is saved in Core Data. The issue is that similar definitions happen and that's why they cannot be saved to NSOrderedSet. When we combine definition and example in one class we will make sure that each instance of DefinitionAndExample class is unique and won't be lost when placed into NSOrderedSet. So in the end each definition and example of word will be saved in Core Data with no issues.

class DefinitionAndExample: NSObject {

    let definition: String
    let example: String
    
    init(definition: String, example: String) {
        self.definition = definition
        self.example = example
        super.init()
    }
}

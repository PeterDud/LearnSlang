//
//  DefinitionModel.swift
//  Learn Slang
//
//  Created by user on 12/01/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class DefinitionModel: NSObject {

    let definition: String
    var examples: [String]
    
    init(definition: String, examples: [String]) {
        self.definition = definition
        self.examples = examples
    }
}

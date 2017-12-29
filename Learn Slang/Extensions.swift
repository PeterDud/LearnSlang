//
//  Extensions.swift
//  Learn Slang
//
//  Created by user on 29/12/2017.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation

extension NSString{
    func firstChar() -> String{
        if self.length == 0{
            return ""
        }
        return self.substring(to: 1)
    }
}

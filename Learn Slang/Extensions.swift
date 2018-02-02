//
//  Extensions.swift
//  Learn Slang
//
//  Created by user on 29/12/2017.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import UIKit

extension NSString {
    @objc func firstChar() -> String{
        if self.length == 0{
            return ""
        }
        return self.substring(to: 1)
    }
}

extension String {
    func firstChar() -> String{
        if self.count == 0{
            return ""
        }
        let i = index(self.startIndex, offsetBy: 1)
        let firstChar = String(self.prefix(upTo: i))
        return firstChar
    }
}

extension NSLayoutConstraint {
    
    override open var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}

extension UILabel {
    var numberOfVisibleLines: Int {
//        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
//        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
//        let charSize: Int = lroundf(Float(self.font.pointSize))
//        return rHeight / charSize
        
        let textSize = CGSize(width: self.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(self.font.lineHeight))
        let lineCount = rHeight/charSize
        return lineCount

    }
}



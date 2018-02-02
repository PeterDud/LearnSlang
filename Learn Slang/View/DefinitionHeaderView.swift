//
//  DefinitionHeaderView.swift
//  Learn Slang
//
//  Created by user on 01/02/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

protocol DefinitionHeaderViewDelegate {
    
    func moreTapped(header: DefinitionHeaderView)
}

class DefinitionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var sizingLabel: UILabel!  // this is invisible label (alpha = 0), we need it to make cell expand smoothly after pressing readMoreBtn.
    @IBOutlet weak var readMoreBtn: UIButton!
    @IBOutlet weak var containerView: UIView! // Container view holds definitionLabel with numberOfLines 0 and clip to bounds enabled
    var delegate: DefinitionHeaderViewDelegate?
    var isExpanded = false
    var linesCount = 10
    
    @IBAction func readMoreBtnClicked(_ sender: UIButton) {
        
        isExpanded = !isExpanded
        sizingLabel.numberOfLines = isExpanded ? 0 : linesCount
        readMoreBtn.setTitle(isExpanded ? "Show Less" : "Read More", for: .normal)
        delegate?.moreTapped(header: self)

    }
    
    func myInit(definition: String) {
        
        definitionLabel.text = definition
        definitionLabel.numberOfLines = 0
        
        sizingLabel.text = definition
        sizingLabel.numberOfLines = isExpanded ? 0 : linesCount
    }

}


//
//  DefinitionTableViewCell.swift
//  Learn Slang
//
//  Created by user on 15/12/2017.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol DefinitionTableViewCellDelegate {
    
    func moreTapped(cell: DefinitionTableViewCell)
}

class DefinitionTableViewCell: UITableViewCell {

    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var sizingLabel: UILabel!  // this is invisible label (alpha = 0), we need it to make cell expand smoothly after pressing readMoreBtn.
    @IBOutlet weak var readMoreBtn: UIButton!
    @IBOutlet weak var containerView: UIView! // Container view holds definitionLabel with numberOfLines 0 and clip to bounds enabled
    var delegate: DefinitionTableViewCellDelegate?
    var isExpanded = false
    var linesCount = 10
    
    @IBAction func readMoreBtnClicked(_ sender: UIButton) {
        
        isExpanded = !isExpanded
        sizingLabel.numberOfLines = isExpanded ? 0 : linesCount
        readMoreBtn.setTitle(isExpanded ? "Show Less" : "Read More", for: .normal)
        delegate?.moreTapped(cell: self)
    }
    
    func myInit(definition: String) {

        isExpanded = false
        
        readMoreBtn.setTitle("Read More", for: .normal)

        definitionLabel.text = definition
        definitionLabel.numberOfLines = 0

        sizingLabel.text = definition
        sizingLabel.numberOfLines = isExpanded ? 0 : linesCount
    }

}

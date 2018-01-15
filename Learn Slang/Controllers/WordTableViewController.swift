//
//  WordTableViewController.swift
//  Learn Slang
//
//  Created by user on 11/01/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class WordTableViewController: UITableViewController {

    var word: Word!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100

        navigationItem.title = "Word"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source
    
    internal override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionTitle = word.word!
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 9, width: 320, height: 22) // #Warning: make it flexible
        myLabel.font = UIFont.init(name: "Hallosans-Black", size: 24)
        myLabel.text = sectionTitle
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.addSubview(myLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return word.definitions != nil ? word.definitions!.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defWithExampCell", for: indexPath) as! DefinitionWithExampleTVCell

        let definition = word.definitions?[indexPath.row] as! Definition
        let myDefinition = definition.definition
        var text = ""
        text += myDefinition!
        text += "\n"
        text += "\n"
        
        var examples = ""

        for example in definition.examples! {
            let myExample = example as! Example
            let exampleStr = myExample.example
            examples += exampleStr!
            let lastElement = definition.examples!.lastObject as! Example
            if !(myExample == lastElement) {
                examples += "\n"
                examples += "\n"
            }
        }
        
        cell.definitionLabel.font = UIFont(name: "Hallo sans", size: 24)
        cell.definitionLabel.text = myDefinition!
        
        cell.exampleLabel.text = examples
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }


    
}

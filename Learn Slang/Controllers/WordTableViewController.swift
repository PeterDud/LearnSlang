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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return word.word
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return word.definitions != nil ? word.definitions!.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)

        let definition = word.definitions?[indexPath.row] as! Definition
//        print(definition)
        let myDefinition = definition.definition
        var text = ""
        text += myDefinition!
        text += "\n"
        text += "\n"

        for example in definition.examples! {
            let myExample = example as! Example
            let exampleStr = myExample.example
            text += exampleStr!
            let lastElement = definition.examples!.lastObject as! Example
            if !(myExample == lastElement) {
                text += "\n"
                text += "\n"
            }
            print(exampleStr!)
        }
        
        cell.textLabel!.font = UIFont(name: "Hallo sans", size: 24)
        cell.textLabel!.text = text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }


}

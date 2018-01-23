//
//  WordTableViewController.swift
//  Learn Slang
//
//  Created by user on 11/01/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import AVKit

class WordTableViewController: UITableViewController {

    var word: Word!
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = word.word
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .play, target: self, action: #selector(WordTableViewController.play))
        if word.spellingURL == nil {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 100

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return word.definitions?.count ?? 0
    }
    
    internal override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let definitions = word.definitions else { return nil }
        
        let sectionTitle = (definitions[section] as! Definition).definition

        let definitionLabel = UILabel()
        definitionLabel.numberOfLines = 0
        
        definitionLabel.font = UIFont.init(name: "ArialMT", size: 19)
        definitionLabel.text = sectionTitle

        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 0.97, alpha: 1)
        headerView.addSubview(definitionLabel)
        
        definitionLabel.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = NSLayoutConstraint(item: definitionLabel,
                                                    attribute: .leading,
                                                    relatedBy: .equal,
                                                    toItem: headerView,
                                                    attribute: .leading,
                                                    multiplier: 1,
                                                    constant: 8)

        let trailingConstraint = NSLayoutConstraint(item: definitionLabel,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: headerView,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: -8)

        let topConstraint = NSLayoutConstraint(item: definitionLabel,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: headerView,
                                                    attribute: .top,
                                                    multiplier: 1,
                                                    constant: 3)

        let bottomConstraint = NSLayoutConstraint(item: definitionLabel,
                                                    attribute: .bottom,
                                                    relatedBy: .equal,
                                                    toItem: headerView,
                                                    attribute: .bottom,
                                                    multiplier: 1,
                                                    constant: -3)

        
        headerView.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        
        return headerView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let definition = word.definitions?[section] as! Definition
        return definition.examples?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exampleCell", for: indexPath)

        let definition = word.definitions?[indexPath.section] as! Definition
        let examplesSet = definition.examples!
        
        var examples = ""
        
        if examplesSet.count > 1 && indexPath.row == 0 {
            examples = "Examples: \n"
        } else if examplesSet.count == 1 {
            examples = "Example: \n"
        }
        
        for example in examplesSet {
            let myExample = example as! Example
            let exampleStr = myExample.example
            examples += exampleStr!
            let lastElement = examplesSet.lastObject as! Example
            if !(myExample == lastElement) {

                examples += "\n\n"
            }
        }
        
        cell.textLabel?.text = examples

        return cell
    }
    
    //MARK: - Actions
    
    @IBAction func play() {

        guard let spellingURL = word.spellingURL else { return }
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        let url = URL(fileURLWithPath: documentDirectory)
        
        let filepathURL = URL(fileURLWithPath: spellingURL, relativeTo: url)
        
        do {
            player = try AVAudioPlayer(contentsOf: filepathURL)
            
            player.volume = 1.0
            print(player.duration)
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }

}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source
    
    internal override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let sectionTitle = word.word!

        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 9, width: 320, height: 27) // #Warning: make it flexible
        myLabel.font = UIFont.init(name: "Hallosans-Black", size: 24)
        myLabel.text = sectionTitle

        let play = UIButton()
        play.frame = CGRect.init(x: 300, y: 6, width: 32, height: 32)
        

        if let image = UIImage(named: "play_icon_35x35") {
            play.setImage(image, for: .normal)
        }
        if let image = UIImage(named: "play_icon_35x35_light") {
            play.setImage(image, for: .disabled)
            play.setImage(image, for: .highlighted)
        }
        
        if word.spellingURL == nil {
            play.isEnabled = false
        } else {
            play.isEnabled = true
        }
        
        play.addTarget(self, action: #selector(WordTableViewController.play), for: .touchUpInside)

        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.addSubview(myLabel)
        headerView.addSubview(play)
        
        // Fixing button to the right side of header view by adding trailing constraint

        play.translatesAutoresizingMaskIntoConstraints = false
        
        let trailingConstraint = NSLayoutConstraint(item: play,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: headerView,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: -10)

        headerView.addConstraint(trailingConstraint)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if word.definitions != nil {
            return word.definitions!.count
        }
        return 0
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
        
        if indexPath.row % 2 == 0 {
            let color = UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
            cell.backgroundColor = color
        } else {
            cell.backgroundColor = UIColor.white
        }

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: - Actions
    
    @objc func play() {

        guard let spellingURL = word.spellingURL else { return }
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        let url = URL(fileURLWithPath: documentDirectory)
        
        let filepathURL = URL(fileURLWithPath: spellingURL, relativeTo: url)
        
        do {
            let player = try AVAudioPlayer(contentsOf: filepathURL)
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

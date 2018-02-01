//
//  WordTableViewController.swift
//  Learn Slang
//
//  Created by user on 11/01/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import AVKit

class WordTableViewController: UITableViewController, DefinitionTableViewCellDelegate, DefinitionHeaderViewDelegate {

    var word: Word?
    var player: AVAudioPlayer!
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var readMoreClicked = false
    var indexOfReadMoreButton = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = word?.word
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .play, target: self, action: #selector(WordTableViewController.play))
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 100

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let nib = UINib(nibName: "DefinitionHeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "DefinitionHeaderView")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // MARK: - DefinitionHeaderViewDelegate
    
    func moreTapped(header: DefinitionHeaderView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return word?.definitions?.count ?? 0
    }
    
    internal override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let definitions = word?.definitions else { return nil }
        
        let definition = definitions[section] as! Definition
        let sectionTitle = definition.definition!
        
        if sectionTitle.count > 300 {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DefinitionHeaderView") as! DefinitionHeaderView
            headerView.readMoreBtn.setTitle(headerView.isExpanded ? "Show Less" : "Read More", for: .normal)
            headerView.view.backgroundColor = UIColor.init(white: 241/255, alpha: 1.0)
            headerView.containerView.backgroundColor = headerView.view.backgroundColor
            headerView.linesCount = 6
            headerView.myInit(definition: sectionTitle)
            headerView.delegate = self
            return headerView
            
        } else {
            
            let defCell = tableView.dequeueReusableCell(withIdentifier: "defCell")!
            defCell.textLabel?.text = sectionTitle
            defCell.textLabel?.font = UIFont.init(name: "Noteworthy-Bold", size: 21)
            defCell.backgroundColor = UIColor.init(white: 241/255, alpha: 1.0)
            
            let headerView = UIView.init(frame: defCell.frame)
            headerView.addSubview(defCell)
            
            return defCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let definition = word?.definitions?[section] as! Definition
        return definition.examples?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exampleCell", for: indexPath) as! DefinitionTableViewCell

        let definition = word?.definitions?[indexPath.section] as! Definition
        let examplesSet = definition.examples!
        
        var examples = ""

        if examplesSet.count > 1 && indexPath.row == 0 {
            examples = "Examples: \n"
        } else if examplesSet.count == 1 && (examplesSet[0] as! Example).example != "" {
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
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - DefinitionTableViewCellDelegate
    
    func moreTapped(cell: DefinitionTableViewCell) {
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //MARK: - Actions
    
    @IBAction func play() {

        guard let spellingURL = word?.spellingURL else {
            
            if let wordStr = word?.word  {
                let speechUtterance = AVSpeechUtterance(string: wordStr)
                speechSynthesizer.speak(speechUtterance)
            }
            return
        }
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        let url = URL(fileURLWithPath: documentDirectory)
        
        let filepathURL = URL(fileURLWithPath: spellingURL, relativeTo: url)
        
        do {
            player = try AVAudioPlayer(contentsOf: filepathURL)
            
            player.volume = 1.0
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {

            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }

}

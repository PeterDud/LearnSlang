//
//  SearchTableViewController.swift
//  Learn Slang
//
//  Created by user on 14/12/2017.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    var wordModel: WordModel?
    @IBOutlet weak var wordSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Word Search"
        
        wordSearchBar.delegate = self
        wordSearchBar.becomeFirstResponder()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        CoreDataStack.sharedInstance.applicationDocumentsDirectory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        ServerManager.shared.downloadWord(word: searchBar.text!) { (result) in
                switch result {
                case .Success(let wordModel):
                    self.wordModel = wordModel
                    self.tableView.reloadData()
                case .Error(let errorMessage):
                    print(errorMessage) // #warning: add Alert later
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if wordModel == nil {
            return 0
        }
        return wordModel!.defsAndExamps.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "definitionCell", for: indexPath) as! DefinitionTableViewCell
        let defAndExamp = wordModel!.defsAndExamps[indexPath.row] as! DefinitionAndExample
        let definition = defAndExamp.definition 
        cell.definitionLabel.text = definition
        
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func saveWordButtonClicked(_ sender: UIBarButtonItem) {

//        clearData()
        
        if wordAlreadyExists(wordModel: wordModel!) {
            showAlertWith(title: "Already have it", message: "It seems like you already added this word to the learning list =)")
            return
        }
        saveEntityInCoreData(type: .definition(nil))
        saveEntityInCoreData(type: .example(nil))
        saveEntityInCoreData(type: .word())
    }
    
    // MARK: - Alerts
    
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Core Data Operations
    
    private func wordAlreadyExists(wordModel: WordModel) -> Bool {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
        fetchRequest.predicate = NSPredicate(format: "word == %@", wordModel.word)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {

                return true
            }
        } catch let error {
            print(error)
        }
        return false
    }
        
    private func createEntityOf(type: EntityType) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        switch type {
        case .word():
            if let wordEntity = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context) as? Word {
                wordEntity.word = wordModel?.word
                wordEntity.spellingURL = wordModel?.spellingURL
            }
         case .definition(let definition):
            if let definitionEntity = NSEntityDescription.insertNewObject(forEntityName: "Definition", into: context) as? Definition {
                definitionEntity.definition = definition
                return definitionEntity
                }
        case .example(let example):
            if let exampleEntity = NSEntityDescription.insertNewObject(forEntityName: "Example", into: context) as? Example {
                exampleEntity.example = example
                return exampleEntity
            }
        }
        return nil
    }
    
    private func saveEntityInCoreData(type: EntityType) {
        
        switch type {
        case .word:
            _ = createEntityOf(type: .word())
            do {
                try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }

        case .definition:
            _ = wordModel?.defsAndExamps.map({ (defAndExamp)  in
                let definitionAndExample = defAndExamp as! DefinitionAndExample
                _ = self.createEntityOf(type: .definition(definitionAndExample.definition))
                do {
                    try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
                } catch let error {
                    print(error)
                }
            })
            
        case .example:
            _ = wordModel?.defsAndExamps.map({ (defAndExamp)  in
                let definitionAndExample = defAndExamp as! DefinitionAndExample
                _ = self.createEntityOf(type: .example(definitionAndExample.example))
                do {
                    try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
                } catch let error {
                    print(error)
                }
            })
        }
    }

    private func clearData() {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let wordsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: "Word"))
        let definitionsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: "Definition"))
        let examplesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: "Example"))
        do {
            let words  = try context.fetch(wordsFetchRequest) as? [NSManagedObject]
            let definitions = try context.fetch(definitionsFetchRequest) as? [NSManagedObject]
            let examples = try context.fetch(examplesFetchRequest) as? [NSManagedObject]

            _ = words.map{$0.map{context.delete($0)}}
            _ = definitions.map{$0.map{context.delete($0)}}
            _ = examples.map{$0.map{context.delete($0)}}

            CoreDataStack.sharedInstance.saveContext()
        } catch let error {
            print("ERROR DELETING : \(error)")
        }
    }
    
    enum EntityType {
        case word()
        case definition(String?)
        case example(String?)
    }
}

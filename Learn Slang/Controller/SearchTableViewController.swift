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
        ServerManager.shared.downloadWord(word: searchBar.text ?? " ") { (result) in
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

        clearData()
        
        saveDefinitionInCoreData(wordModel: wordModel!)
        saveExampleInCoreData(wordModel: wordModel!)
        saveWordInCoreData(wordModel: wordModel!)
    }
    
    // MARK: - Core Data Operations #Warning: trhy to optimize these methods with generics
    
    private func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: "Word"))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
        
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: "Definition"))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }

        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: "Example"))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }

    }
    
    private func createDefinitionEntityFrom(definition: String) -> NSManagedObject? { // #Warning: Think about doing it with generics
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let definitionEntity = NSEntityDescription.insertNewObject(forEntityName: "Definition", into: context) as? Definition {
            definitionEntity.definition = definition
            return definitionEntity
        }
        return nil
    }
    
    private func createExampleEntityFrom(example: String) -> NSManagedObject? { // #Warning: Think about doing it with generics
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let exampleEntity = NSEntityDescription.insertNewObject(forEntityName: "Example", into: context) as? Example {
            exampleEntity.example = example
            return exampleEntity
        }
        return nil
    }

    private func createWordEntityFrom(wordModel: WordModel) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let wordEntity = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context) as? Word {
            wordEntity.word = wordModel.word
            wordEntity.spellingURL = wordModel.spellingURL
            
            return wordEntity
        }
        return nil
    }
    
    //        private func createEntityFor<T>(_ value: T, from: WordModel) {  // #Warning: Research how to do this
//
//        for value in wordModel.va
//    }
    
    
    private func saveDefinitionInCoreData(wordModel: WordModel) {
        _ = wordModel.defsAndExamps.map({ (defAndExamp)  in
            let definitionAndExample = defAndExamp as! DefinitionAndExample
            _ = self.createDefinitionEntityFrom(definition: definitionAndExample.definition)
            do {
                try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        })
    }
    
    private func saveExampleInCoreData(wordModel: WordModel) {
        _ = wordModel.defsAndExamps.map({ (defAndExamp)  in
            let definitionAndExample = defAndExamp as! DefinitionAndExample
            _ = self.createExampleEntityFrom(example: definitionAndExample.example)
            do {
                try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        })
    }
    
    private func saveWordInCoreData(wordModel: WordModel) {
        _ = createWordEntityFrom(wordModel: wordModel)
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }

//    private func createPhotoEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
//
//        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
//        if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
//            photoEntity.author = dictionary["author"] as? String
//            photoEntity.tags = dictionary["tags"] as? String
//            let mediaDictionary = dictionary["media"] as? [String: AnyObject]
//            photoEntity.mediaURL = mediaDictionary?["m"] as? String
//            return photoEntity
//        }
//        return nil
//    }
//
//    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
//        _ = array.map{self.createPhotoEntityFrom(dictionary: $0)}
//        do {
//            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
//        } catch let error {
//            print(error)
//        }
//    }

 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}


















//
//  SearchViewController.swift
//  Learn Slang
//
//  Created by user on 19/01/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var wordModel: WordModel?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wordSearchBar: UISearchBar!
    var saveWordButton: UIBarButtonItem!
    var cancelButton: UIButton!
    var saveButton: UIButton!
    var word: Word!
    var definition: Definition!
    var spellingFilePath: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton = wordSearchBar.value(forKey: "_cancelButton") as? UIButton
        
        createSaveBarButtonItem()
        enableCustomFonts()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        // Notifications subscriptions
        NotificationCenter.default.addObserver(self, selector: #selector(SearchTableViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchTableViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        if wordModel == nil {
        //            DispatchQueue.main.async { self.cancelButton.isEnabled = false }
        //        }
    }
    
    func createSaveBarButtonItem()  {
        
        saveButton = UIButton(type: .custom)
        saveButton.addTarget(self, action: #selector(SearchTableViewController.saveWordButtonClicked(_:)), for: .touchUpInside)
        saveWordButton = UIBarButtonItem(customView: saveButton)
        saveWordButton.isEnabled = false
        navigationItem.rightBarButtonItem = saveWordButton
    }
    
    func enableCustomFonts() {
        
        let hallosansLight = "Hallosans-Light"
        
        let attributesBlack = [NSAttributedStringKey.foregroundColor : UIColor.black,
                               NSAttributedStringKey.font : UIFont.init(name: hallosansLight, size: 25.0)!]
        let attributesGray = [NSAttributedStringKey.foregroundColor : UIColor.lightGray,
                              NSAttributedStringKey.font : UIFont.init(name: hallosansLight, size: 25.0)!]
        
        let textField = wordSearchBar.value(forKey: "_searchField") as! UITextField
        textField.font = UIFont(name: hallosansLight, size: 25.0)
        textField.attributedPlaceholder = NSAttributedString(string: "Enter your word", attributes:attributesGray)
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributesBlack,
                                                                                                          for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributesGray,
                                                                                                          for: .disabled)
        saveButton?.setAttributedTitle(NSAttributedString(string: "Save", attributes: attributesBlack), for: .normal)
        saveButton?.setAttributedTitle(NSAttributedString(string: "Save", attributes: attributesGray), for: .disabled)
        saveButton?.setAttributedTitle(NSAttributedString(string: "Save", attributes: attributesGray), for: .highlighted)
        
        self.navigationController?.navigationBar.titleTextAttributes = attributesBlack
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func enableSaveButton() { // #Warning: maybe you don't need this method
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {self.saveWordButton.isEnabled = true}
        }
    }
    
    func disableSaveButton() { // #Warning: maybe you don't need this method
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {self.saveWordButton.isEnabled = false}
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async { self.cancelButton.isEnabled = true }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        ServerManager.shared.downloadWord(word: searchBar.text!) { (result) in
            switch result {
            case .Success(let word):
                
                self.updateTableView(word: word)
                self.enableSaveButton()
                
            case .Error(let errorMessage):
                self.showAlertWith(title: "Oh", message: "The word wasn't downloaded. Try again!")
                print(errorMessage)
                
            case .NotFound:
                let notFoundString = "Unfortunately there's no such word/phrase at www.urbandictionary.com"
                let notFoundDefAndExamp = DefinitionModel(definition: notFoundString, examples: [""])
                let notFoundWordModel = WordModel(word: "",
                                                  definitions: [notFoundDefAndExamp],
                                                  spellingURL: "")
                self.updateTableView(word: notFoundWordModel)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        wordSearchBar.resignFirstResponder()
        
        if tableView.visibleCells.isEmpty {
            return
        }
        deleteRowsInTableView()
        disableSaveButton()
        searchBar.text = ""
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard wordModel != nil else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {self.cancelButton.isEnabled = false}
            }
            return 0
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {self.cancelButton.isEnabled = true}
        }
        return wordModel!.definitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "definitionCell", for: indexPath) as! DefinitionTableViewCell
        let definition = wordModel!.definitions[indexPath.row]
        let definitionStr = definition.definition
        cell.definitionLabel.font = UIFont(name: "Hallo sans", size: 22.0)
        cell.definitionLabel.text = definitionStr
        
        if indexPath.row % 2 == 0 {
            let color = UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
            cell.backgroundColor = color
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    // MARK: - Notifactions methods, moving content up/down when keyboard appears/disappears
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    // MARK: - Table View Update Methods
    
    func updateTableView(word: WordModel) {
        
        if wordModel == nil {
            wordModel = word
            insertRowsInTableView()
            
        } else {
            tableView.performBatchUpdates({
                self.deleteRowsInTableView()
            }) { (finished) in
                self.wordModel = word
                self.insertRowsInTableView()
            }
        }
    }
    
    func insertRowsInTableView() {
        
        var indexPaths = [IndexPath]()
        for index in 0..<wordModel!.definitions.count {
            indexPaths.append(IndexPath.init(row: index, section: 0))
        }
        self.tableView.insertRows(at: indexPaths, with: .top)
    }
    
    func deleteRowsInTableView() {
        
        var indexPaths = [IndexPath]()
        for index in 0..<self.wordModel!.definitions.count {
            indexPaths.append(IndexPath.init(row: index, section: 0))
        }
        self.wordModel = nil
        self.tableView.deleteRows(at: indexPaths, with: .bottom)
    }
    
    // MARK: - Actions
    
    @objc func saveWordButtonClicked(_ sender: UIBarButtonItem) {
        
        if wordAlreadyExists(wordModel: wordModel!) {
            showAlertWith(title: "Already have it", message: "It seems like you already added this word to the learning list =)")
            return
        }
        saveEntityInCoreData(type: .word())
        saveEntityInCoreData(type: .definition(nil))
        saveEntityInCoreData(type: .example(nil))
        
        wordSearchBar.resignFirstResponder()
    }
    
    // MARK: - Alerts
    
    func showAlertWith(title: String, message: String) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showSavedWordMessage() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Saved!", message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Core Data Operations
    
    private func wordAlreadyExists(wordModel: WordModel) -> Bool {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
        fetchRequest.predicate = NSPredicate(format: "word ==[c] %@", wordModel.word)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                return true
            }
        } catch let error {
            print("ERROR FETCHING WORD COUNT: \(error)")
        }
        return false
    }
    
    private func createEntityOf(type: EntityType) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        switch type {
        case .word():
            if let wordEntity = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context) as? Word {
                
                word = wordEntity
                wordEntity.word = setUpWordForCoreData(wordModel?.word ?? "")
                wordEntity.spellingURL = downloadAudioAndCreateFile()
                return wordEntity
            }
        case .definition(let myDefinition):
            if let definitionEntity = NSEntityDescription.insertNewObject(forEntityName: "Definition", into: context) as? Definition {
                
                definition = definitionEntity
                
                definitionEntity.definition = myDefinition
                definitionEntity.word = word
                return definitionEntity
            }
        case .example(let example):
            if let exampleEntity = NSEntityDescription.insertNewObject(forEntityName: "Example", into: context) as? Example {
                
                exampleEntity.example = example
                exampleEntity.definition = definition
                return exampleEntity
            }
        }
        return nil
    }
    
    func setUpWordForCoreData(_ word: String) -> String {
        if word == word.uppercased() {
            return word
        } else {
            return word.capitalized
        }
    }
    
    func downloadAudioAndCreateFile() -> String? {
        
        guard wordModel?.spellingURL != nil else { return nil }
        
        let stringURL = self.wordModel!.spellingURL!
        let url = URL(string: stringURL)
        
        guard url != nil else { return nil }
        
        let urlData: NSData
        
        do { urlData = try NSData(contentsOf: url!)
            
            let fileName = (stringURL as NSString).lastPathComponent
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentDirectory = paths[0]
            let url = URL(string: documentDirectory)!
            
            let filePathURL = URL(fileURLWithPath: fileName, relativeTo: url)
            
            DispatchQueue.global(qos: .background).async {
                urlData.write(toFile: filePathURL.absoluteString, atomically: true)
            }
            
            return filePathURL.relativePath
        } catch {
            print("ERROR WHILE DOWNLOADING WORD AUDIO")
        }
        return nil
    }
    
    private func saveEntityInCoreData(type: EntityType) {
        
        switch type {
        case .word:
            _ = createEntityOf(type: .word())
            
            do {
                try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
                disableSaveButton()
                showSavedWordMessage()
            } catch let error {
                print("ERROR SAVING WORD: \(error)")
                showAlertWith(title: "Oops...", message: "It seems word wasn't saved. Try again!")
            }
            
        case .definition:
            _ = wordModel?.definitions.map({ (myDefinition)  in
                _ = self.createEntityOf(type: .definition(myDefinition.definition))
                do {
                    try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
                } catch let error {
                    print("ERROR SAVING DEFINITION: \(error)")
                    showAlertWith(title: "Oops...", message: "It seems definition wasn't saved. Try again!")
                }
                _ = myDefinition.examples.map({ (myExample) in
                    _ = self.createEntityOf(type: .example(myExample))
                    do {
                        try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
                    } catch let error {
                        print("ERROR SAVING EXAMPLE: \(error)")
                        self.showAlertWith(title: "Oops...", message: "It seems example wasn't saved. Try again!")
                    }
                })
            })
        case . example: // examples are saved in case .definition, so we just break here
            break
            
        }
    }
    
    private func clearData() { // #Warning: Create abstract class to unite all your managed objects
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let wordsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: "Word"))
        let definitionsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: "Definition"))
        let examplesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: "Example"))
        do {
            let words  = try context.fetch(wordsFetchRequest) as? [NSManagedObject]
            _ = words.map{$0.map{context.delete($0)}}
            
            CoreDataStack.sharedInstance.saveContext()
        } catch let error {
            print("ERROR DELETING WORD: \(error)")
            showAlertWith(title: "Oops...", message: "It seems word wasn't deleted. Try again!")
        }
        do {
            let definitions = try context.fetch(definitionsFetchRequest) as? [NSManagedObject]
            
            _ = definitions.map{$0.map{context.delete($0)}}
            
            CoreDataStack.sharedInstance.saveContext()
        } catch let error {
            print("ERROR DELETING DEFINITION: \(error)")
            showAlertWith(title: "Oops...", message: "It seems definition wasn't deleted. Try again!")
        }
        do {
            let examples = try context.fetch(examplesFetchRequest) as? [NSManagedObject]
            
            _ = examples.map{$0.map{context.delete($0)}}
            
            CoreDataStack.sharedInstance.saveContext()
        } catch let error {
            print("ERROR DELETING EXAMPLE: \(error)")
            showAlertWith(title: "Oops...", message: "It seems example wasn't deleted. Try again!")
        }
    }
    
    enum EntityType {
        case word()
        case definition(String?)
        case example(String?)
    }
}


//
//  WordListViewController.swift
//  Learn Slang
//
//  Created by user on 27/12/2017.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import CoreData

class WordListViewController: UIViewController {

    @IBOutlet weak var wordSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
    private var fetchedResultController: NSFetchedResultsController<Word>?
    
    var selectedIndexPath: IndexPath?
    var attributesBlack = [NSAttributedStringKey.foregroundColor : UIColor.black,
                           NSAttributedStringKey.font : UIFont.init(name: "Hallosans-Light", size: 28.0)!]
    let attributesGray = [NSAttributedStringKey.foregroundColor : UIColor.lightGray,
                          NSAttributedStringKey.font : UIFont.init(name: "Hallosans-Light", size: 25.0)!]

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let editButton = createEditButton(withText: "Edit")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
        tableView.sectionIndexColor = UIColor.black
        
        enableCustomFonts()
        
        // Notifications subscriptions
        NotificationCenter.default.addObserver(self, selector: #selector(WordListViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WordListViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func enableCustomFonts() {
        
        let textField = wordSearchBar.value(forKey: "_searchField") as! UITextField
        textField.font = UIFont(name: "Hallosans-Light", size: 25.0)
        textField.attributedPlaceholder = NSAttributedString(string: "Enter your word", attributes:attributesGray)
        
        attributesBlack[NSAttributedStringKey.font] = UIFont.init(name: "Hallosans-Light", size: 25.0)!
        self.navigationController?.navigationBar.titleTextAttributes = attributesBlack
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableContent()
        tableView.reloadData()
        if UIDevice.current.orientation.isLandscape == true {
            
            guard let selected = selectedIndexPath else { return }
            
            DispatchQueue.main.async {
                self.tableView.selectRow(at: selected, animated: true, scrollPosition: .top)
                self.tableView.scrollToRow(at: selected, at: .top, animated: true)
            }
        }
    }
    
    func createEditButton (withText text: String) -> UIButton  {
        
        let editButton = UIButton(type: .custom)
        editButton.addTarget(self, action: #selector(WordListViewController.editButtonClicked(_:)), for: .touchUpInside)
        editButton.setAttributedTitle(NSAttributedString(string: text, attributes: attributesBlack), for: .normal)
        
        return editButton
    }

    @objc func editButtonClicked (_ sender: UIBarButtonItem) {
        
        let isEditing = tableView.isEditing
        tableView.setEditing(!isEditing, animated: true)
        
        let editBarButtonItem = UIBarButtonItem()
        editBarButtonItem.customView = createEditButton(withText: "Edit")
        if tableView.isEditing {
            editBarButtonItem.customView = createEditButton(withText: "Done")
        }
        navigationItem.setRightBarButton(editBarButtonItem, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateTableContent() {
        
        let request = Word.fetchRequest() as NSFetchRequest<Word>
        let sort = NSSortDescriptor(key: "word", ascending:true, selector: nil)
        
        if wordSearchBar.text?.count != nil && (wordSearchBar.text?.count)! > 0 {
            let predicate = NSPredicate(format: "word CONTAINS[cd] %@", self.wordSearchBar.text ?? "")
            request.predicate = predicate
        }
        request.sortDescriptors = [sort]
        do {
            fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "word.firstChar", cacheName: nil)
            fetchedResultController?.delegate = self
            
            try self.fetchedResultController?.performFetch()
        } catch let error  {
            print("Error: \(error)")
        }
    }
    
    // MARK: - Notifactions methods, moving content up/down when keyboard appears/disappears
    
    @objc func keyboardWillShow(notification: NSNotification) {
     
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showWordSegue" {
            if let navigationController = segue.destination as? UINavigationController,
                let wordTableViewController = navigationController.topViewController as? WordTableViewController {
                if let send = sender as? Word {
                    wordTableViewController.word = send
                }
            }
        }
    }

}

extension WordListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return fetchedResultController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let objs = fetchedResultController?.sections?[section].objects
        return objs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)
        
        let word = fetchedResultController?.object(at: indexPath)
        cell.textLabel!.font = UIFont(name: "Hallo sans", size: 24)
        cell.textLabel!.text = word?.word
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let word = fetchedResultController?.object(at: indexPath)
            guard let myWord = word else { return }
            
            context.delete(myWord)
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return fetchedResultController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return fetchedResultController?.sectionIndexTitles ?? nil
    }
}

extension WordListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if tableView.isEditing {
            return .delete
        }
        return .none
    }

    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionTitle = fetchedResultController?.sectionIndexTitles[section]
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 5, width: 320, height: 22) // #Warning: make it flexible
        myLabel.font = UIFont.init(name: "Hallo sans", size: 24)
        myLabel.text = sectionTitle
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackground
        headerView.addSubview(myLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        let word = fetchedResultController?.object(at: indexPath)
        performSegue(withIdentifier: "showWordSegue", sender: word)
    }
    
}

extension WordListViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        guard indexPath?.section != nil, tableView.numberOfRows(inSection: (indexPath?.section)!) > 1 else { return } // if there's only one row left we delete an entire section in another NSFetchedResultsControllerDelegate method
        
        if type == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath!], with: .left)
            tableView.endUpdates()
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        if type == .delete {
            tableView.beginUpdates()
            tableView.deleteSections([sectionIndex], with: .left)
            tableView.endUpdates()
        }
    }
}

extension WordListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        updateTableContent()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        wordSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        wordSearchBar.text = ""
        wordSearchBar.resignFirstResponder()
    }
}




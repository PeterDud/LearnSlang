//
//  WordListTableViewController.swift
//  Learn Slang
//
//  Created by user on 27/12/2017.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import CoreData

class WordListTableViewController: UITableViewController {

    private let context = CoreDataStack.sharedInstance.persistentContainer.viewContext

    private var fetchedResultController: NSFetchedResultsController<Word>?

    override func viewDidLoad() {
        super.viewDidLoad()
        enableCustomFonts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableContent()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func enableCustomFonts() {
        
        let attributesBlack = [NSAttributedStringKey.foregroundColor : UIColor.black,
                               NSAttributedStringKey.font : UIFont.init(name: "Hallosans-Light", size: 28.0)!]
        self.navigationController?.navigationBar.titleTextAttributes = attributesBlack
    }


    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let words = fetchedResultController?.sections?[section].objects as? [Word]
        let word = words?.first
        let string = word?.word
        let index = string!.index(string!.startIndex, offsetBy: 2)
        let first2Chars = word?.word?.prefix(upTo: index)
        let first2CharsStr = "\(first2Chars!)"

        return first2CharsStr
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return (fetchedResultController?.section(forSectionIndexTitle: title, at: index))!
    }

//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//
//        return fetchedResultController!.sectionIndexTitles
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let sections = fetchedResultController?.sections, let objs = sections[section].objects else {
            return 0
        }
        return objs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)

        let word = fetchedResultController?.object(at: indexPath)
        cell.textLabel!.font = UIFont(name: "Hallo sans", size: 25)
        cell.textLabel!.text = word?.word
        
        return cell
    }
    
    func updateTableContent() {
        
        let request = Word.fetchRequest() as NSFetchRequest<Word>
        
        let sort = NSSortDescriptor(key: #keyPath(Word.word), ascending:true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        
        do {
            fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(), cacheName: nil)
            fetchedResultController?.delegate = self

            try self.fetchedResultController?.performFetch()
            print("COUNT FETCHED FIRST: \(String(describing: fetchedResultController?.sections?[0].numberOfObjects))")
        } catch let error  {
            print("ERROR: \(error)")
        }
    }
}

extension WordListTableViewController: NSFetchedResultsControllerDelegate {

//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//        switch type {
//        case .insert:
//            break // The word is added in SearchTableViewController (WordListTableViewController won't be visible at the moment of adding new cell), that's why we don't update table view here.
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .automatic)
//        default:
//            break
//        }
//    }

}

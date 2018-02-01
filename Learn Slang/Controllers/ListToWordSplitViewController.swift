//
//  ListToWordSplitViewController.swift
//  Learn Slang
//
//  Created by user on 24/01/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ListToWordSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UISplitViewCotnrollerDelegate
        
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior

        if let secondaryAsNavController = secondaryViewController as? UINavigationController, let topAsDetailController = secondaryAsNavController.topViewController as? WordTableViewController, topAsDetailController.word == nil {
            return true
        }
        return false
    }

}







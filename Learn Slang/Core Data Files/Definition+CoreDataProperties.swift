//
//  Definition+CoreDataProperties.swift
//  Learn Slang
//
//  Created by user on 04/01/2018.
//  Copyright © 2018 user. All rights reserved.
//
//

import Foundation
import CoreData


extension Definition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Definition> {
        return NSFetchRequest<Definition>(entityName: "Definition")
    }

    @NSManaged public var definition: String?
    @NSManaged public var word: Word?

}

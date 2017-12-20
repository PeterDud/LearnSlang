//
//  Definition+CoreDataProperties.swift
//  Learn Slang
//
//  Created by user on 19/12/2017.
//  Copyright © 2017 user. All rights reserved.
//
//

import Foundation
import CoreData


extension Definition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Definition> {
        return NSFetchRequest<Definition>(entityName: "Definition")
    }

    @NSManaged public var definition: String?

}

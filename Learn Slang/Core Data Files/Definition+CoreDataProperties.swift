//
//  Definition+CoreDataProperties.swift
//  Learn Slang
//
//  Created by user on 12/01/2018.
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
    @NSManaged public var example: NSSet?

}

// MARK: Generated accessors for example
extension Definition {

    @objc(addExampleObject:)
    @NSManaged public func addToExample(_ value: Example)

    @objc(removeExampleObject:)
    @NSManaged public func removeFromExample(_ value: Example)

    @objc(addExample:)
    @NSManaged public func addToExample(_ values: NSSet)

    @objc(removeExample:)
    @NSManaged public func removeFromExample(_ values: NSSet)

}

//
//  Definition+CoreDataProperties.swift
//  Learn Slang
//
//  Created by user on 15/01/2018.
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
    @NSManaged public var examples: NSOrderedSet?
    @NSManaged public var word: Word?

}

// MARK: Generated accessors for examples
extension Definition {

    @objc(insertObject:inExamplesAtIndex:)
    @NSManaged public func insertIntoExamples(_ value: Example, at idx: Int)

    @objc(removeObjectFromExamplesAtIndex:)
    @NSManaged public func removeFromExamples(at idx: Int)

    @objc(insertExamples:atIndexes:)
    @NSManaged public func insertIntoExamples(_ values: [Example], at indexes: NSIndexSet)

    @objc(removeExamplesAtIndexes:)
    @NSManaged public func removeFromExamples(at indexes: NSIndexSet)

    @objc(replaceObjectInExamplesAtIndex:withObject:)
    @NSManaged public func replaceExamples(at idx: Int, with value: Example)

    @objc(replaceExamplesAtIndexes:withExamples:)
    @NSManaged public func replaceExamples(at indexes: NSIndexSet, with values: [Example])

    @objc(addExamplesObject:)
    @NSManaged public func addToExamples(_ value: Example)

    @objc(removeExamplesObject:)
    @NSManaged public func removeFromExamples(_ value: Example)

    @objc(addExamples:)
    @NSManaged public func addToExamples(_ values: NSOrderedSet)

    @objc(removeExamples:)
    @NSManaged public func removeFromExamples(_ values: NSOrderedSet)

}

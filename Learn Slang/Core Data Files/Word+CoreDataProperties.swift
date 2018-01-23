//
//  Word+CoreDataProperties.swift
//  Learn Slang
//
//  Created by user on 15/01/2018.
//  Copyright © 2018 user. All rights reserved.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var spellingURL: String? 
    @NSManaged public var word: String?
    @NSManaged public var definitions: NSOrderedSet?

}

// MARK: Generated accessors for definitions
extension Word {

    @objc(insertObject:inDefinitionsAtIndex:)
    @NSManaged public func insertIntoDefinitions(_ value: Definition, at idx: Int)

    @objc(removeObjectFromDefinitionsAtIndex:)
    @NSManaged public func removeFromDefinitions(at idx: Int)

    @objc(insertDefinitions:atIndexes:)
    @NSManaged public func insertIntoDefinitions(_ values: [Definition], at indexes: NSIndexSet)

    @objc(removeDefinitionsAtIndexes:)
    @NSManaged public func removeFromDefinitions(at indexes: NSIndexSet)

    @objc(replaceObjectInDefinitionsAtIndex:withObject:)
    @NSManaged public func replaceDefinitions(at idx: Int, with value: Definition)

    @objc(replaceDefinitionsAtIndexes:withDefinitions:)
    @NSManaged public func replaceDefinitions(at indexes: NSIndexSet, with values: [Definition])

    @objc(addDefinitionsObject:)
    @NSManaged public func addToDefinitions(_ value: Definition)

    @objc(removeDefinitionsObject:)
    @NSManaged public func removeFromDefinitions(_ value: Definition)

    @objc(addDefinitions:)
    @NSManaged public func addToDefinitions(_ values: NSOrderedSet)

    @objc(removeDefinitions:)
    @NSManaged public func removeFromDefinitions(_ values: NSOrderedSet)

}

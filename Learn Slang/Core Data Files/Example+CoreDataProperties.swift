//
//  Example+CoreDataProperties.swift
//  Learn Slang
//
//  Created by user on 04/01/2018.
//  Copyright © 2018 user. All rights reserved.
//
//

import Foundation
import CoreData


extension Example {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Example> {
        return NSFetchRequest<Example>(entityName: "Example")
    }

    @NSManaged public var example: String?
    @NSManaged public var word: Word?

}

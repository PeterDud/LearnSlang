//
//  Example+CoreDataProperties.swift
//  Learn Slang
//
//  Created by user on 19/12/2017.
//  Copyright © 2017 user. All rights reserved.
//
//

import Foundation
import CoreData


extension Example {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Example> {
        return NSFetchRequest<Example>(entityName: "Example")
    }

    @NSManaged public var example: String?

}

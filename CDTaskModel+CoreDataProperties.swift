//
//  TaskModel+CoreDataProperties.swift
//
//
//  Created by Рамил Гаджиев on 30.03.2022.
//
//

import Foundation
import CoreData


extension CDTaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTaskModel> {
        return NSFetchRequest<CDTaskModel>(entityName: "CDTaskModel")
    }

    @NSManaged public var name: String
    @NSManaged public var id: String
    @NSManaged public var task: String
    @NSManaged public var endTime: Date?
    @NSManaged public var startTime: Date
    @NSManaged public var isDone: Bool
    @NSManaged public var doneTime: Date?
}

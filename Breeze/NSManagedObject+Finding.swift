//
//  NSManagedObject+Finding.swift
//  Breeze
//
//  Created by André Lind on 2014-08-11.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    /*
        Find in context
    */
    public func inContextOfType(type: BreezeContextType) -> AnyObject? {
        if objectID.temporaryID {
            var error: NSError?
            if managedObjectContext!.obtainPermanentIDsForObjects([self], error: &error) == false {
                println("Breeze - Unable to obtain permantent IDs for object: \(self). Error: \(error)")
                return nil
            }
        }
        
        return BreezeStore.contextForType(type).objectWithID(objectID)
    }
    
    /*
        Find first
    */
    public class func findFirst(attribute: String? = nil, value: AnyObject?, contextType: BreezeContextType = .Main) -> AnyObject? {
        let predicate = predicateForAttribute(attribute, value: value)
        return findFirst(predicate: predicate, sortedBy: nil, ascending: false, contextType: contextType)
    }
    
    public class func findFirst(predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = true, contextType: BreezeContextType = .Main) -> AnyObject? {
        return findFirst(predicate: predicate, sortedBy: sortedBy, ascending: ascending, context: BreezeStore.contextForType(contextType))
    }
    
    public class func findFirst(attribute: String? = nil, value: AnyObject?, context: NSManagedObjectContext) -> AnyObject? {
        let predicate = predicateForAttribute(attribute, value: value)
        return findFirst(predicate: predicate, sortedBy: nil, ascending: false, context: context)
    }
    
    public class func findFirst(predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = true, context: NSManagedObjectContext) -> AnyObject? {
        let request = fetchRequest(predicate, sortedBy: sortedBy, ascending: ascending)
        request.fetchLimit = 1
        return BreezeStore.executeRequest(request, context: context).result.first
    }
    
    /*
        Find all
    */
    public class func findAll(attribute: String? = nil, value: AnyObject?, contextType: BreezeContextType = .Main) -> [AnyObject]! {
        let predicate = predicateForAttribute(attribute, value: value)
        return findAll(predicate: predicate, sortedBy: nil, ascending: false, contextType: contextType)
    }
    
    public class func findAll(predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = true, contextType: BreezeContextType = .Main) -> [AnyObject]! {
        return findAll(predicate: predicate, sortedBy: sortedBy, ascending: ascending, context: BreezeStore.contextForType(contextType))
    }
    
    public class func findAll(attribute: String? = nil, value: AnyObject?, context: NSManagedObjectContext) -> [AnyObject]! {
        let predicate = predicateForAttribute(attribute, value: value)
        return findAll(predicate: predicate, sortedBy: nil, ascending: false, context: context)
    }
    
    public class func findAll(predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = true, context: NSManagedObjectContext) -> [AnyObject]! {
        let request = fetchRequest(predicate, sortedBy: sortedBy, ascending: ascending)
        return BreezeStore.executeRequest(request, context: context).result
    }
    
    /*
        Count
    */
    public class func countAll(predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = true, contextType: BreezeContextType = .Main) -> Int {
        return countAll(predicate: predicate, sortedBy: sortedBy, ascending: ascending, context: BreezeStore.contextForType(contextType))
    }
    
    public class func countAll(predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = true, context: NSManagedObjectContext) -> Int {
        let request = fetchRequest(predicate, sortedBy: sortedBy, ascending: ascending)
        request.includesSubentities = false
        return BreezeStore.executeCountRequest(request, context: context).count
    }
    
    /*
        Fetch all
    */
    public class func fetchAll(predicate: NSPredicate? = nil, groupedBy: String? = nil, sortedBy: String? = nil, ascending: Bool = true, delegate: NSFetchedResultsControllerDelegate?, contextType: BreezeContextType = .Main) -> NSFetchedResultsController? {
        let request = fetchRequest(predicate, sortedBy: sortedBy, ascending: ascending)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: BreezeStore.contextForType(contextType), sectionNameKeyPath: groupedBy, cacheName: nil)
        fetchedResultsController.delegate = delegate
        
        var error: NSError?
        if fetchedResultsController.performFetch(&error) == false {
            println("Breeze - Error setting up NSFetchedResultsController \(fetchedResultsController). Error: \(error)")
            return nil
        }
        return fetchedResultsController
    }
    
    /*
        Private area, keep off
    */
    private class func predicateForAttribute(attribute: String?, value: AnyObject?) -> NSPredicate {
        return NSPredicate(format: "%K = %@", argumentArray: [attribute!, value!])
    }
    
    private class func fetchRequest(predicate: NSPredicate?, sortedBy: String? = nil, ascending: Bool = true) -> NSFetchRequest! {
        let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(self))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortedBy != nil ? [NSSortDescriptor(key: sortedBy!, ascending: ascending)] : nil
        return fetchRequest
    }
}
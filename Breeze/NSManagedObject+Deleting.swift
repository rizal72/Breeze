//
//  NSManagedObject+Deleting.swift
//  Breeze
//
//  Created by André Lind on 2014-08-11.
//  Copyright (c) 2014 André Lind. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    public func deleteInContextOfType(type: BreezeContextType) {
        let contextSelf = inContextOfType(type) as NSManagedObject
        BreezeStore.contextForType(type).deleteObject(contextSelf)
    }
}
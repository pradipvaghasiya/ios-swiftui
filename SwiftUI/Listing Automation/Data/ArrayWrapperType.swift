//
//  Sample.swift
//  SpeedKit
//
//  Created by ibm on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation

public protocol ArrayWrapperType : CollectionType,ExtensibleCollectionType,RangeReplaceableCollectionType,ArrayLiteralConvertible{
   typealias Element
   var items : [Element] {get set}
}


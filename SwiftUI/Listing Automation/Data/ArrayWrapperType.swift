//
//  Sample.swift
//  SpeedKit
//
//  Created by ibm on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation


///TODO: Extending existing Protocols with already defined methods does not work. 
///TODO: items need to be made public though this should hide this

public protocol ArrayWrapperType : CollectionType,ExtensibleCollectionType,RangeReplaceableCollectionType,ArrayLiteralConvertible{
   typealias Element
   var items : [Element] {get set}
}


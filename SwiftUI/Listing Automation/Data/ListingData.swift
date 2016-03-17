//
//  TableViewData.swift
//  SwiftUI
//
//  Created by Pradip V on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation


public class ListingData<Element : SectionType> : ArrayWrapperType{
    
    public var items : [Element]
    public init (items : [Element]){
        self.items = items
    }
    
    required public init(){
        items = []
    }
    
    public required init(arrayLiteral elements: Element...){
        items = Array(elements)
    }
    
    public var count: Int { get {return items.count} }
}

extension ListingData : CollectionType{
    public var startIndex: Int { get {return 0}}
    public var endIndex: Int {
        get{
            return items.count
        }
    }
    
    public subscript (index: Int) -> Element{
        get{
            return items[index]
        }
        
        set{
            items[index] = newValue
        }
    }
}


extension ListingData : RangeReplaceableCollectionType{
    
    public func reserveCapacity(n: Int.Distance){
        items.reserveCapacity(n)
    }
    
    public func append(x: Element){
        items.append(x)
    }
    
    public func replaceRange<C : CollectionType where C.Generator.Element == Element>(subRange: Range<Int>, with newElements: C){
        items.replaceRange(subRange, with: newElements)
    }
    
   public func splice<S : CollectionType where S.Generator.Element == Element>(newElements: S, atIndex i: Int){
      items.insertContentsOf(newElements, at: i)
   }
   
   
   public func removeRange(subRange: Range<Int>){
      items.removeRange(subRange)
   }
   
   public func insert(newElement: Element, atIndex i: Int){
      items.insert(newElement, atIndex: i)
   }
   
   public func removeAtIndex(index: Int) -> Element{
      return items.removeAtIndex(index)
   }
   
   public func removeAll(keepCapacity keepCapacity: Bool){
      items.removeAll(keepCapacity: keepCapacity)
   }
}

extension ListingData : ArrayLiteralConvertible{
}





//
//  TableViewData.swift
//  SwiftUI
//
//  Created by Pradip V on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation


public class ListingData : ArrayWrapperType{
    
    public var items : [ListingSection]
    public init (items : [ListingSection]){
        self.items = items
    }
    
    required public init(){
        items = []
    }
    
    public required init(arrayLiteral elements: ListingSection...){
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
    
    public subscript (index: Int) -> ListingSection{
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
    
    public func append(x: ListingSection){
        items.append(x)
    }
    
    public func replaceRange<C : CollectionType where C.Generator.Element == ListingSection>(subRange: Range<Int>, with newElements: C){
        items.replaceRange(subRange, with: newElements)
    }
    
   public func splice<S : CollectionType where S.Generator.Element == ListingSection>(newElements: S, atIndex i: Int){
      items.insertContentsOf(newElements, at: i)
   }
   
   
   public func removeRange(subRange: Range<Int>){
      items.removeRange(subRange)
   }
   
   public func insert(newElement: ListingSection, atIndex i: Int){
      items.insert(newElement, atIndex: i)
   }
   
   public func removeAtIndex(index: Int) -> ListingSection{
      return items.removeAtIndex(index)
   }
   
   public func removeAll(keepCapacity keepCapacity: Bool){
      items.removeAll(keepCapacity: keepCapacity)
   }
}

extension ListingData : ArrayLiteralConvertible{
}





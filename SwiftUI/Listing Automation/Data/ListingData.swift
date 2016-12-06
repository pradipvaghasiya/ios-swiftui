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

extension ListingData : Collection{
    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: Int) -> Int {
        return items.index(after: i)
    }

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


extension ListingData : RangeReplaceableCollection{
    public func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, C.Iterator.Element == ListingSection {
        items.replaceSubrange(subrange, with: newElements)
    }
    
//    public func reserveCapacity(n: Int.Distance){
//        items.reserveCapacity(n)
//    }
    
    public func append(x: ListingSection){
        items.append(x)
    }
    
//   public func splice<S : CollectionType where S.Generator.Element == ListingSection>(newElements: S, atIndex i: Int){
//      items.insertContentsOf(newElements, at: i)
//   }
//   
   
   public func removeRange(subRange: Range<Int>){
      items.removeSubrange(subRange)
   }
   
   public func insert(newElement: ListingSection, atIndex i: Int){
      items.insert(newElement, at: i)
   }
   
   public func removeAtIndex(index: Int) -> ListingSection{
      return items.remove(at: index)
   }
   
   public func removeAll(keepCapacity: Bool){
      items.removeAll(keepingCapacity: keepCapacity)
   }
}

extension ListingData : ExpressibleByArrayLiteral{
}





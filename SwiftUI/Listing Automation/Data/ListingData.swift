//
//  TableViewData.swift
//  SwiftUI
//
//  Created by Pradip V on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation


open class ListingData : ArrayWrapperType{
    
    open var items : [ListingSection]
    public init (items : [ListingSection]){
        self.items = items
    }
    
    required public init(){
        items = []
    }
    
    public required init(arrayLiteral elements: ListingSection...){
        items = Array(elements)
    }
    
    open var count: Int { get {return items.count} }
}

extension ListingData : Collection{
    public func index(after i: Int) -> Int {
        guard i != items.count else {
            return 0
        }
        return i + 1
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
    
    public func reserveCapacity(_ n: Int){
        items.reserveCapacity(n)
    }
    
    public func append(_ x: ListingSection){
        items.append(x)
    }
    
    public func replaceSubrange<C : Collection>(_ subRange: Range<Int>, with newElements: C) where C.Iterator.Element == ListingSection{
        items.replaceSubrange(subRange, with: newElements)
    }
    
   public func splice<S : Collection>(_ newElements: S, atIndex i: Int) where S.Iterator.Element == ListingSection{
      items.insert(contentsOf: newElements, at: i)
   }
   
   
   public func removeSubrange(_ subRange: Range<Int>){
      items.removeSubrange(subRange)
   }
   
   public func insert(_ newElement: ListingSection, at i: Int){
      items.insert(newElement, at: i)
   }
   
   public func remove(at index: Int) -> ListingSection{
      return items.remove(at: index)
   }
   
   public func removeAll(keepingCapacity keepCapacity: Bool){
      items.removeAll(keepingCapacity: keepCapacity)
   }
}

extension ListingData : ExpressibleByArrayLiteral{
}





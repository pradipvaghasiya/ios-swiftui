//
//  ArrayWrapper.swift
//  SwiftUI
//
//  Created by ibm on 29/06/15.
//  Copyright © 2015 SpeedUI. All rights reserved.
//

import Foundation

public class ArrayWrapper<T> : ArrayWrapperType{
   
   public typealias Element = T

   public var items : [Element]
   public init (items : [Element]){
      self.items = items
   }
   
   required public init(){
      items = []
   }
   
   public required init(arrayLiteral elements: T...){
      items = Array(elements)
   }

   public var count: Int { get {return items.count} }
}

extension ArrayWrapper : CollectionType{
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


extension ArrayWrapper : RangeReplaceableCollectionType{
   
   public func reserveCapacity(n: Int.Distance){
      items.reserveCapacity(n)
   }
   
   public func append(x: T){
      items.append(x)
   }
   
   public func replaceRange<C : CollectionType where C.Generator.Element == T>(subRange: Range<Int>, with newElements: C){
      items.replaceRange(subRange, with: newElements)
   }
   
   public func splice<S : CollectionType where S.Generator.Element == T>(newElements: S, atIndex i: Int){
      items.insertContentsOf(newElements, at: i)
   }
   
   
   public func removeRange(subRange: Range<Int>){
      items.removeRange(subRange)
   }
   
   public func insert(newElement: T, atIndex i: Int){
      items.insert(newElement, atIndex: i)
   }
   
   public func removeAtIndex(index: Int) -> T{
      return items.removeAtIndex(index)
   }
   
   public func removeAll(keepCapacity keepCapacity: Bool){
      items.removeAll(keepCapacity: keepCapacity)
   }
}

extension ArrayWrapper : ArrayLiteralConvertible{
}


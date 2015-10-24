//
//  Section.swift
//  SwiftUI
//
//  Created by ibm on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation

public class TableViewSection: TableViewSectionType{
    public var sectionHeader : String?
    public var sectionFooter : String?
    
    private var items : [ViewModelType]
    init (items : [ViewModelType]){
        self.items = items
    }
    
    public required init(){
        items = []
    }
    
    public required init(arrayLiteral elements: ViewModelType...){
        items = Array(elements)
    }
    
    public var count: Int { get {return items.count} }
    
    //     required init(arrayLiteral elements: T...){
    //        super.init(items: elements)
    //    }
    
    //    public func viewModelAtIndexPath(indexPath: NSIndexPath) -> ViewModelType{
    //        return items[indexPath.section].items[1]
    //    }
}

extension TableViewSection : CollectionType{
    public var startIndex: Int { get {return 0}}
    public var endIndex: Int {
        get{
            return items.count
        }
    }
    
    public subscript (index: Int) -> ViewModelType{
        get{
            return items[index]
        }
        
        set{
            items[index] = newValue
        }
    }
}


extension TableViewSection : RangeReplaceableCollectionType{
    
    public func reserveCapacity(n: Int.Distance){
        items.reserveCapacity(n)
    }
    
    public func append(x: ViewModelType){
        items.append(x)
    }
    
    public func replaceRange<C : CollectionType where C.Generator.Element == ViewModelType>(subRange: Range<Int>, with newElements: C){
        items.replaceRange(subRange, with: newElements)
    }
    
    public func splice<S : CollectionType where S.Generator.Element == ViewModelType>(newElements: S, atIndex i: Int){
        items.insertContentsOf(newElements, at: i)
    }
    
    
    public func removeRange(subRange: Range<Int>){
        items.removeRange(subRange)
    }
    
    public func insert(newElement: ViewModelType, atIndex i: Int){
        items.insert(newElement, atIndex: i)
    }
    
    public func removeAtIndex(index: Int) -> ViewModelType{
        return items.removeAtIndex(index)
    }
    
    public func removeAll(keepCapacity keepCapacity: Bool){
        items.removeAll(keepCapacity: keepCapacity)
    }
}

extension TableViewSection : ArrayLiteralConvertible{
}


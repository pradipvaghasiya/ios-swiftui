//
//  Section.swift
//  Kamero
//
//  Created by Pradip V on 4/15/16.
//  Copyright © 2016 Happyfall. All rights reserved.
//

public class ListingSection: SectionType{
    ///Only valid for TableView
    public var sectionHeader : String?
    ///Only valid for TableView
    public var sectionFooter : String?

    var items : [ViewModelType]
    init (items : [ViewModelType]){
        self.items = items
    }
    
    public required init(arrayLiteral elements: ViewModelType...){
        items = Array(elements)
    }

    public required init(){
        items = []
    }
        
    public var count: Int { get {return items.count} }
}

extension ListingSection : CollectionType{
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


extension ListingSection : RangeReplaceableCollectionType{
    
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

extension ListingSection : ArrayLiteralConvertible{
    
}

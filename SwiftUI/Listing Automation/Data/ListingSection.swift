//
//  ListingSection.swift
//  SwiftUI
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

extension ListingSection : Collection{
    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: Int) -> Int {
        return items.index(after : i)
    }

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


extension ListingSection : RangeReplaceableCollection{
    
    public func reserveCapacity(_ n: ListingSection.IndexDistance){
        items.reserveCapacity(n)
    }
    
    public func append(_ x: ViewModelType){
        items.append(x)
    }
    
    public func replaceSubrange<C : Collection>(_ subRange: Range<Int>, with newElements: C) where C.Iterator.Element == ViewModelType{
        items.replaceSubrange(subRange, with: newElements)
    }
    
    public func splice<S : Collection>(_ newElements: S, atIndex i: Int) where S.Iterator.Element == ViewModelType{
        items.insert(contentsOf: newElements, at: i)
    }
    
    
    public func removeSubrange(_ subRange: Range<Int>){
        items.removeSubrange(subRange)
    }
    
    public func insert(_ newElement: ViewModelType, at i: Int){
        items.insert(newElement, at: i)
    }
    
    public func remove(at index: Int) -> ViewModelType{
        return items.remove(at: index)
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool){
        items.removeAll(keepingCapacity: keepCapacity)
    }
}

extension ListingSection : ExpressibleByArrayLiteral{
    
}

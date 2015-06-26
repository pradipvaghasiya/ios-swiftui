//
//  TableViewData.swift
//  Hello
//
//  Created by ibm on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation


public struct ListingData<T : SectionType> : ArrayWrapperType{
      
   public var items : [T]
   init (sections : [T]){
      self.items = sections
   }
   
//   public var startIndex: Int { get {return 0}}
//   public var endIndex: Int {
//      get{
//         return items.count
//      }
//   }
//   
//   public subscript (index: Int) -> T{
//      get{
//         return items[index]
//      }
//      
//      set{
//         items[index] = newValue
//      }
//   }

}
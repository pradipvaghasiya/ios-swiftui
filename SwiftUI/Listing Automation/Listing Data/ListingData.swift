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
   public init (sections : [T]){
      self.items = sections
   }

}
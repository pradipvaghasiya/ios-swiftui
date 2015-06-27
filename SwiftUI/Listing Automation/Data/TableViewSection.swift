//
//  Section.swift
//  Hello
//
//  Created by ibm on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation

public struct TableViewSection: TableViewSectionType{
   public var sectionHeader : String?
   public var sectionFooter : String?
      
   public var items : [ViewModelType]
   public init (viewModels : [ViewModelType]){
      self.items = viewModels
   }
}

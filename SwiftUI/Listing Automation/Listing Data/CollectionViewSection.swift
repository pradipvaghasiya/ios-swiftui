//
//  CollectionViewSection.swift
//  Hello
//
//  Created by ibm on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation

public struct CollectionViewSection: CollectionViewSectionType{
   
   public var items: [ViewModelType]
   init (viewModels : [ViewModelType]){
      self.items = viewModels
   }
}

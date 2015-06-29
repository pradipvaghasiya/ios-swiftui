//
//  CollectionViewSection.swift
//  SpeedKit
//
//  Created by ibm on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation

public class CollectionViewSection: ArrayWrapper<ViewModelType>,CollectionViewSectionType{
   
//   public init (viewModels : [ViewModelType]){
//      super.init(items: viewModels)
//   }

   public required init(arrayLiteral elements: ViewModelType...){
      super.init(items: elements)
   }
}

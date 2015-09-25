//
//  CollectionViewSection.swift
//  SwiftUI
//
//  Created by ibm on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation

public class CollectionViewSection: ArrayWrapper<ViewModelType>,CollectionViewSectionType{
   
   public required init(arrayLiteral elements: ViewModelType...){
      super.init(items: elements)
   }
}

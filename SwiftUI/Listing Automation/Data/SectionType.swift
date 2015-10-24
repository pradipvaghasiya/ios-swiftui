//
//  SectionType.swift
//  SwiftUI
//
//  Created by ibm on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation


public protocol SectionType : ArrayWrapperType{
   
}

public protocol TableViewSectionType : SectionType{
   var sectionHeader : String? {get set}
   var sectionFooter : String? {get set}
}


public protocol CollectionViewSectionType : SectionType{
   
}
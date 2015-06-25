//
//  SPTableViewSection.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 01/05/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit

public final class SPTableViewSection: SPListingSection {
   /// Header Title as a String for this section.
   public var sectionHeader : String?
   
   /// Footer Title as a String for this section.
   public var sectionFooter : String?

   /// Designated initialiser for given cells/items array.
   override public init(CellGroups cellGroups:[SPListingCellGroup]){
      super.init(CellGroups: cellGroups)
   }

   /// Designated initialiser for given cells/items array and Section Header.
   public init(CellGroups cellGroups:[SPListingCellGroup], SectionHeader sectionHeader:String){
      super.init(CellGroups: cellGroups)
      
      self.sectionHeader = sectionHeader
   }
   
   /// Designated initialiser for given cells/items array and Section Footer.
   public init(CellGroups cellGroups:[SPListingCellGroup], SectionFooter sectionFooter:String){
      super.init(CellGroups: cellGroups)

      self.sectionFooter = sectionFooter
   }
   
   /// Designated initialiser for given cells/items array and Section Header & Footer.
   public init(CellGroups cellGroups:[SPListingCellGroup], SectionHeader sectionHeader:String,SectionFooter sectionFooter:String){
      super.init(CellGroups: cellGroups)

      self.sectionHeader = sectionHeader
      self.sectionFooter = sectionFooter
   }

}

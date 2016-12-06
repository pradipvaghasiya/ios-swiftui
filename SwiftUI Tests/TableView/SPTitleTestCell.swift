//
//  SPTitleTestCell.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 13/07/14.
//  Copyright (c) 2014 SpeedUI. All rights reserved.
//

import UIKit
import SwiftUI

///Reusable Cell Id defined in xib file and xib file name itself. Both must be same.
public let kCellIdSPTitleTestCell = "SPTitleTestNibCell"

//Default Label Parameters
private let kDefaultFontSize : CGFloat = 16.0
private let kDefaultFont = UIFont.systemFont(ofSize: kDefaultFontSize)
private let kDefaultTextColor = UIColor.black
private let kDefaultTextAlignment : NSTextAlignment = .left

// MARK: Cell Configuration
///This cell shows single label covered in whole length and height
class SPTitleTestCell: UITableViewCell,SPListingCellProtocol {
    ///Title Label IBOutlet
    @IBOutlet var titleLabel: UILabel?
    
    // SPTableViewCellProtocol
    func configureCellUsing(_ model: AnyObject){
        //If model is of type SPTitleTestCellModel, It would set title text.
        if let myModel = model as? SPTitleTestCellModel{
            self.titleLabel?.text = myModel.titleText
            
            return
        }
        
        //If model is of type SPTitleTestCellCommonModel, It would set Label properties.
        if let myModel = model as? SPTitleTestCellCommonModel{
            self.titleLabel?.textColor = myModel.textColor
            self.titleLabel?.textAlignment = myModel.textAlignment
            self.titleLabel?.font = myModel.font

            return
        }
        
        print("Please pass correct model")
    }
}

// MARK: Helper Methods
extension SPTitleTestCell{
    
    ///This method creates basic default SPListingData with one section from given array.
    ///
    ///:param: stringArray Array of string using which SPListingData would be created.
    ///
    ///:returns: SPListingData which can be used to create TableView using SwiftUI
    class func getBasicDefaultSPListingData(UsingStringArray stringArray: [String]) -> ListingData{

        var spTitleTestCellModelArray : [SPTitleTestCellModel] = []
        
        for rowTitle in stringArray{
            spTitleTestCellModelArray.append(SPTitleTestCellModel(TitleText: rowTitle))
        }
        
        let spListingCellData = SPListingCellGroup(cellId: kCellIdSPTitleTestCell,
            cellModelArray: spTitleTestCellModelArray)
        
        let spListingSection0Data = SPListingSection(CellGroups: [spListingCellData])
        
        return SPListingData(SectionArray: [spListingSection0Data])
    }
}

// MARK: Cell Common Model
///This model ideally should be used as Common Model so that it can be applied to all similar cells.
class SPTitleTestCellCommonModel{
    //User can change below label property.
    var font: UIFont
    var textColor: UIColor
    var textAlignment: NSTextAlignment
    
    init(Font font:UIFont,
         TextColor textColor:UIColor = kDefaultTextColor,
        TextAlignment alignment : NSTextAlignment = kDefaultTextAlignment){
            self.font = font
            self.textColor = textColor
            self.textAlignment = alignment
    }
    
    init(TextColor textColor:UIColor,
        TextAlignment alignment : NSTextAlignment = kDefaultTextAlignment,
        Font font:UIFont = kDefaultFont){
            self.font = font
            self.textColor = textColor
            self.textAlignment = alignment
    }
    
    init(TextAlignment alignment : NSTextAlignment,
        Font font:UIFont = kDefaultFont,
        TextColor textColor:UIColor = kDefaultTextColor){
            self.font = font
            self.textColor = textColor
            self.textAlignment = alignment
    }
}

// MARK: Cell Model
///This model contains only one title property.
class SPTitleTestCellModel{
    ///Cell label Title Text
    var titleText:String
    init(TitleText text:String){
        self.titleText = text
    }
}



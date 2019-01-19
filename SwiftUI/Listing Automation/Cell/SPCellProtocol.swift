//
//  SPCellProtocol.swift
//  SwiftUI
//
//  Created by Pradip Vaghasiya on 04/08/14.
//  Copyright (c) 2014 Happyfall. All rights reserved.
//

import UIKit
/// To Listing Automation to work, Cell or Item must conform to this protocol.
public protocol SPCellProtocol : class{
    var viewModel : ViewModelType? {get set}   //weak
    func configureCell()
}


public protocol SPTableCellProtocol : SPCellProtocol{
    var tableView : UITableView? {get set}  //weak
}


public protocol SPCollectionCellProtocol : SPCellProtocol{
    var collectionView : UICollectionView? {get set} //weak
}

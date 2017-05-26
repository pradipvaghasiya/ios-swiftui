//
//  SPTableCell.swift
//  SwiftUI
//
//  Created by Pradip V on 29/06/15.
//  Copyright © 2015 Happyfall. All rights reserved.
//

import UIKit

open class SPTableCell: UITableViewCell,SPTableCellProtocol{
    open weak var viewModel : ViewModelType?
    open weak var tableView : UITableView?
    
    open func configureCell(){
        fatalError("Subclass must override this method in class. Please note currently method inside Swift Extension is not being called by system.")
    }
}

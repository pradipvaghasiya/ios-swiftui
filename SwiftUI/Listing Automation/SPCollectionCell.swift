//
//  SPCollectionCell.swift
//  SwiftUI
//
//  Created by ibm on 29/06/15.
//  Copyright © 2015 SpeedUI. All rights reserved.
//

import UIKit

public class SPCollectionCell: UICollectionViewCell,SPCollectionCellProtocol{
   public weak var viewModel : ViewModelType?
   public weak var parentView : UICollectionView?
   
   public func configureCell(){
      fatalError("Subclass must override this method in class. Please note currently method inside Swift Extension is not being called by system.")
   }
}

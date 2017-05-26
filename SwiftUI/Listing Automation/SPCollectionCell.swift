//
//  SPCollectionCell.swift
//  SwiftUI
//
//  Created by Pradip V on 29/06/15.
//  Copyright © 2015 Happyfall. All rights reserved.
//

import UIKit

open class SPCollectionCell: UICollectionViewCell,SPCollectionCellProtocol{
    open weak var viewModel : ViewModelType?
    open weak var collectionView : UICollectionView?
    
    open var selectedBackgroundColor : UIColor? // Set this if you wish to have selection color change behaviour
    fileprivate var defaultBackgroundColor : UIColor?
    
    override open var isSelected : Bool{
        didSet{
            if let color = selectedBackgroundColor{
                if oldValue != isSelected{
                    if isSelected{
                        self.backgroundColor = color
                    }else{
                        self.backgroundColor = defaultBackgroundColor
                    }
                }
            }
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        defaultBackgroundColor = self.backgroundColor
    }
    
    open func configureCell(){
        fatalError("Subclass must override this method in class. Please note currently method inside Swift Extension is not being called by system.")
    }
}

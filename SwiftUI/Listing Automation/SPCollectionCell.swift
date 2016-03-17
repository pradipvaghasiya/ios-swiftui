//
//  SPCollectionCell.swift
//  SwiftUI
//
//  Created by Pradip V on 29/06/15.
//  Copyright © 2015 SpeedUI. All rights reserved.
//

import UIKit

public class SPCollectionCell: UICollectionViewCell,SPCollectionCellProtocol{
    public weak var viewModel : ViewModelType?
    public weak var collectionView : UICollectionView?
    
    public var selectedBackgroundColor : UIColor? // Set this if you wish to have selection color change behaviour
    private var defaultBackgroundColor : UIColor?
    
    override public var selected : Bool{
        didSet{
            if let color = selectedBackgroundColor{
                if oldValue != selected{
                    if selected{
                        self.backgroundColor = color
                    }else{
                        self.backgroundColor = defaultBackgroundColor
                    }
                }
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        defaultBackgroundColor = self.backgroundColor
    }
    
    public func configureCell(){
        fatalError("Subclass must override this method in class. Please note currently method inside Swift Extension is not being called by system.")
    }
}

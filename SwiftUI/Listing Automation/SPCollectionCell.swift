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
    public weak var collectionView : UICollectionView?
    
    public var highlightedBackgroundColor : UIColor?
    private var defaultBackgroundColor : UIColor?
    
    override public var highlighted : Bool{
        didSet{
            if let color = highlightedBackgroundColor{
                if oldValue != highlighted{
                    if highlighted{
                        defaultBackgroundColor = self.backgroundColor
                        self.backgroundColor = color
                    }else{
                        let delay = 0.5 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), { [unowned self] in
                            self.backgroundColor = self.defaultBackgroundColor
                        })
                    }
                }
            }
        }
    }
    
    public func configureCell(){
        fatalError("Subclass must override this method in class. Please note currently method inside Swift Extension is not being called by system.")
    }
}

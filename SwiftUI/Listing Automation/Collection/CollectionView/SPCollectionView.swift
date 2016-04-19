//
//  SPCollectionView.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 30/04/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

public class SPCollectionView: UICollectionView {
    
    public weak var controller : SPListingControllerType?
        {
        didSet{
            if oldValue == nil && controller != nil{
                self.registerReusableCellsIfRequired()
                if listingDataSource == nil{
                    listingDataSource = SPCollectionViewDataSource(controller!)
                }
                dataSource = listingDataSource
            }
        }
    }
    
    
    var listingDataSource : SPCollectionViewDataSource?
    
    //editing Cell
    public weak var editingCell : UIView?
    var editingTouchStartPointInCell : CGPoint?
    var touchStartPoint : CGPoint?
    public weak var editView : UIView?
    public var panGesture : UIPanGestureRecognizer?
    public weak var editingDelegate : SPEditableListingViewEditingDelegate?
    public var editViewWidth : CGFloat = kDefaultListingEditViewWidth
    public var enableEditing : Bool = false{
        didSet{
            enableEditing(enableEditing)
        }
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SPCollectionView : SPEditableListingViewType{
    public func configurePanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(SPCollectionView.userPannedInCollectionView(_:)))
    }
    
    func userPannedInCollectionView(gesture : UIPanGestureRecognizer ){
        userPanned(gesture)
    }
}

//MARK: Register Nib Or Subclass
extension SPCollectionView{
    ///Registers all nib file or Subclass which may be in SPListingData for reuse purpose.
    final func registerReusableCellsIfRequired(){
        
        var nibCells : Set<String> = Set()
        var subclassCells : Set<String> = Set()
        
        if let controller = self.controller{
            for section in controller.listingData(self).items{
                for viewModel in section{
                    if viewModel.cellType == .Nib{
                        nibCells.insert(viewModel.cellId)
                    }else if viewModel.cellType == .SubClass{
                        subclassCells.insert(viewModel.cellId)
                    }
                }
            }
        }
        
        for cellId in nibCells{
            self.registerNib(cellId)
        }
        
        for cellId in subclassCells{
            self.registerClass(cellId)
        }
        
    }
    
    ///Registers given cell using CellData.
    ///
    ///:param: cellData Registers class based on its type and cell Id contained in this param.
    final func registerCellsFor(ViewModel viewModel : ViewModelType){
        switch viewModel.cellType{
        case .SubClass:
            self.registerClass(viewModel.cellId)
        case .Nib:
            self.registerNib(viewModel.cellId)
        case .ProtoType:
            true
        }
    }
    
    
    public final func registerNib(nibId : String){
        self.registerNib(UINib(nibName: nibId, bundle: nil),forCellWithReuseIdentifier: nibId)
    }
    
    public final func registerClass(className : String){
        if let cellClass = NSClassFromString(className){
            if cellClass.isSubclassOfClass(UICollectionViewCell){
                self.registerClass(NSClassFromString(className),forCellWithReuseIdentifier: className)
            }
        }else{
            SPLogger.logError(Message: "\(className) must be subclass of UITableViewCell to use it with SPTableView.")
        }
    }
    
}

//MARK: Cell Update
extension SPCollectionView{
    ///Update the viewmodel and call this method. ViewModel is reference type so cell's ViewModel will automatically updated.
    func reConfigureCellIfVisibleAtIndexPath(indexPath: NSIndexPath){
        guard let cell = cellForItemAtIndexPath(indexPath) as? SPCollectionCell else{
            return
        }
        cell.configureCell()
    }
}

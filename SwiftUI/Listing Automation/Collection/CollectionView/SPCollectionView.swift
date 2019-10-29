//
//  SPCollectionView.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 30/04/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

open class SPCollectionView: UICollectionView {
    
    open weak var controller : SPListingControllerType?
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
    
    ///Must be set before setting controller.
    var listingDataSource : SPCollectionViewDataSource?
    
    //editing Cell
    open weak var editingCell : UIView?
    var editingTouchStartPointInCell : CGPoint?
    var touchStartPoint : CGPoint?
    open weak var editView : UIView?
    open var panGesture : UIPanGestureRecognizer?
    open weak var editingDelegate : SPEditableListingViewEditingDelegate?
    open var editViewWidth : CGFloat = kDefaultListingEditViewWidth
    open var enableEditing : Bool = false{
        didSet{
            enableEditing(enableEditing)
        }
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout){
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SPCollectionView : SPEditableListingViewType{
    public func configurePanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(SPCollectionView.userPannedInCollectionView(_:)))
    }
    
    @objc func userPannedInCollectionView(_ gesture : UIPanGestureRecognizer ){
        userPanned(gesture)
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureShouldBegin(gestureRecognizer)
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
                    if viewModel.cellType == .nib{
                        nibCells.insert(viewModel.cellId)
                    }else if viewModel.cellType == .subClass{
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
        case .subClass:
            self.registerClass(viewModel.cellId)
        case .nib:
            self.registerNib(viewModel.cellId)
        case .protoType:
            break
        }
    }
    
    
    public final func registerNib(_ nibId : String){
        self.register(UINib(nibName: nibId, bundle: nil),forCellWithReuseIdentifier: nibId)
    }
    
    public final func registerClass(_ className : String){
        if let cellClass = NSClassFromString(className){
            if let _ = cellClass as? UICollectionViewCell.Type {
                self.register(cellClass,forCellWithReuseIdentifier: className)
            }
        }else{
            SPLogger.logError(Message: "\(className) must be subclass of UITableViewCell to use it with SPTableView.")
        }
    }
    
}

//MARK: Cell Update
extension SPCollectionView{
    ///Update the viewmodel and call this method. ViewModel is reference type so cell's ViewModel will automatically updated.
    func reConfigureCellIfVisibleAtIndexPath(_ indexPath: IndexPath){
        guard let cell = cellForItem(at: indexPath) as? SPCollectionCell else{
            return
        }
        cell.configureCell()
    }
}

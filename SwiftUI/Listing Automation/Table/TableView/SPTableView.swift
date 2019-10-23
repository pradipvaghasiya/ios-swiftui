//
//  SPTableView.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 16/04/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

open class SPTableView: UITableView{
    
    open weak var controller : SPListingControllerType? {
        didSet{
            if oldValue == nil && controller != nil{
                self.registerReusableCellsIfRequired()
                self.listingDataSource = SPTableViewDataSource(controller!)
                self.dataSource = self.listingDataSource
            }
        }
    }
    
    fileprivate var listingDataSource : SPTableViewDataSource?
    
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
    
    init() {
        super.init(frame: CGRect.zero, style: .plain)
        setup()
    }

    override public init(frame: CGRect, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    private func setup() {
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.systemBackground
        }
    }
    
}

extension SPTableView : SPEditableListingViewType{
    public func configurePanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(SPTableView.userPannedInTableView(_:)))
    }
    
    @objc func userPannedInTableView(_ gesture : UIPanGestureRecognizer ){
        userPanned(gesture)
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureShouldBegin(gestureRecognizer)
    }
}


//MARK: Register Nib Or Subclass
extension SPTableView{
    ///Registers all nib file or Subclass which may be in SPListingData for reuse purpose.
    public final func registerReusableCellsIfRequired(){
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
    public final func registerCellsFor(ViewModel viewModel : ViewModelType){
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
        self.register(UINib(nibName: nibId, bundle: nil),forCellReuseIdentifier: nibId)
    }
    
    public final func registerClass(_ className : String){
        if let cellClass = NSClassFromString(className){
            if let _ = cellClass as? UITableViewCell.Type{
                self.register(NSClassFromString(className),forCellReuseIdentifier: className)
            }
        }else{
            SPLogger.logError(Message: "\(className) must be subclass of UITableViewCell to use it with SPTableView.")
        }
    }
    
}



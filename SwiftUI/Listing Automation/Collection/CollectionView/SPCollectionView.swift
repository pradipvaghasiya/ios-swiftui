//
//  SPCollectionView.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 30/04/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

private let kDefaultEditViewWidth : CGFloat = 80
public protocol SPCollectionViewEditingDelegate : class{
    func editView(indexPath : NSIndexPath) -> UIView?
}

public class SPCollectionView: UICollectionView, SPListingViewType {
    
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
    public weak var editingCell : UICollectionViewCell?
    private var editingTouchStartPoint : CGPoint?
    private weak var editView : UIView?
    private var panGesture : UIPanGestureRecognizer?
    weak var editingDelegate : SPCollectionViewEditingDelegate?
    var enableEditing : Bool = false {
        didSet{
            if enableEditing{
                guard let _ = panGesture else{
                    panGesture = UIPanGestureRecognizer(target: self, action: #selector(SPCollectionView.userPanned(_:)))
                    panGesture?.delegate = self
                    addGestureRecognizer(panGesture!)
                    return
                }
            }else{
                guard let gesture = panGesture else{
                    return
                }
                removeGestureRecognizer(gesture)
                panGesture = nil
            }
        }
    }
    var editViewWidth : CGFloat = kDefaultEditViewWidth
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
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

//MARK: Edit Cell
extension SPCollectionView : UIGestureRecognizerDelegate{
    func userPanned(gesture : UIPanGestureRecognizer ){
        
        switch(gesture.state)
        {
        case .Began:
            var touchPoint = gesture.locationInView(self)
            guard let editCell = getCellFromTouch(touchPoint) else{
                return
            }
            
            guard let currentCell = editingCell else{
                beginEditing(touchPoint, editCell: editCell, addEditView: true)
                return
            }
            
            guard currentCell != editCell else{
                touchPoint.x += editViewWidth
                beginEditing(touchPoint, editCell: editCell, addEditView: false)
                return
            }
            
            if(!removeEditView()){
                beginEditing(touchPoint, editCell: editCell, addEditView: true)
            }
            
        case .Changed:
            let touchPoint = gesture.locationInView(self)
            guard let currentEditingCell = getCellFromTouch(touchPoint),
                let editingStartedWithCell = editingCell,
                let startPoint = editingTouchStartPoint
                where editingStartedWithCell == currentEditingCell else{
                    editingGestureEnded(touchPoint)
                    return
            }
            moveCell(editingStartedWithCell, offset: touchPoint.x - startPoint.x)
        case .Ended, .Cancelled, .Failed:
            let touchPoint = gesture.locationInView(self)
            editingGestureEnded(touchPoint)
        case .Possible:
            break
        }
    }
    
    func beginEditing(touchPoint : CGPoint, editCell: UICollectionViewCell, addEditView: Bool){
        editingTouchStartPoint = touchPoint
        editingCell = editCell
        if(addEditView) {
            editView = addEditViewForCell(editCell)
        }
    }
    
    public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let customGesture = panGesture where customGesture == gestureRecognizer else{
            removeEditView()
            return true
        }
        
        let velocityPoint = customGesture.velocityInView(self)
        guard velocityPoint.x < 0 else {
            removeEditView()
            return false
        }
        
        return true
    }
        
    func moveCell(cell : UICollectionViewCell, offset : CGFloat){
        guard let editView = editView where offset > -200 && offset < 0 else{
            return
        }
        
        UIView.animateWithDuration(0, animations: {
            cell.frame.origin.x = offset
            editView.frame.origin.x = cell.frame.origin.x + cell.frame.width
            editView.frame.size.width = -cell.frame.origin.x
        })
        
    }
    
    func editingGestureEnded(point : CGPoint){
        guard let currentCell = editingCell,
            let editView = editView,
            let startPoint = editingTouchStartPoint else{
                return
        }
        
        guard abs(startPoint.x - point.x) > 80 else{
            removeEditView()
            return
        }
        
        UIView.animateWithDuration(0.3, animations: {
            currentCell.frame.origin.x = -self.editViewWidth
            editView.frame.origin.x = currentCell.frame.origin.x + currentCell.frame.width
            editView.frame.size.width = -currentCell.frame.origin.x
        })
    }
    
    func removeEditView() -> Bool{
        guard let currentCell = editingCell,
            let editView = editView else{
                return false
        }
        
        self.editView = nil
        self.editingCell = nil
        self.editingTouchStartPoint = nil
        
        UIView.animateWithDuration(0.3, animations: {
            currentCell.frame.origin.x = 0
            editView.frame.origin.x = currentCell.frame.origin.x + currentCell.frame.width
            editView.frame.size.width = -currentCell.frame.origin.x
            }
            , completion: {[weak self]success in
                editView.removeFromSuperview()
                guard let cellBeforeAnimation = self?.editingCell
                    where cellBeforeAnimation == currentCell else{
                        return
                }
            })
        return true
    }
    
    func getCellFromTouch(point : CGPoint) -> UICollectionViewCell?{
        for cell in visibleCells(){
            let cellFrameInCollectionView = getCellFrameInCollectionView(cell.frame)
            if(CGRectContainsPoint(cellFrameInCollectionView, point)){
                return cell
            }
        }
        return nil
    }
    
    func getCellFrameInCollectionView(cellFrame : CGRect) -> CGRect{
        return convertRect(cellFrame, fromCoordinateSpace: self)
    }

    func addEditViewForCell(cell : UICollectionViewCell) -> UIView?{
        guard let indexPath = indexPathForCell(cell),
            let editView = editingDelegate?.editView(indexPath) else{
            return nil
        }
        var editViewFrame = getCellFrameInCollectionView(cell.frame)
        editViewFrame.origin.x = editViewFrame.width
        editViewFrame.size.width = 0
        editView.frame = editViewFrame
        addSubview(editView)
        return editView
    }
}



//
//  SPEditableListingViewType.swift
//  Kamero
//
//  Created by Pradip V on 4/16/16.
//  Copyright © 2016 Happyfall. All rights reserved.
//


public let kDefaultListingEditViewWidth : CGFloat = 80
public let kDefaultListingEditViewBounceUpto : CGFloat = 60

public protocol SPEditableListingViewEditingDelegate : class{
    func editView(indexPath : NSIndexPath) -> UIView?
}

public protocol SPEditableListingViewType : SPListingViewType{
    //editing Cell
    var enableEditing : Bool { get set }
    weak var editingCell : UIView?  {get set}
    var editingTouchStartPoint : CGPoint?  {get set}
    weak var editView : UIView?  {get set}
    var panGesture : UIPanGestureRecognizer?  {get set}
    weak var editingDelegate : SPEditableListingViewEditingDelegate?  {get set}
    var editViewWidth : CGFloat  {get set}
    
    func configurePanGesture()
}

extension SPEditableListingViewType where Self : UIScrollView{
    func enableEditing(shouldEnable : Bool){
        if shouldEnable{
            guard let _ = panGesture else{
                configurePanGesture()
                panGesture!.maximumNumberOfTouches = 1
                panGesture!.delegate = self
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
    
    func userPanned(gesture : UIPanGestureRecognizer ){
        var touchPoint = gesture.locationInView(self)

        switch(gesture.state)
        {
        case .Began:
            //There must not be other gesture running, if thats not the case return.
            guard editingTouchStartPoint == nil else{
                return
            }
            
            guard let editCell = getCellFromTouch(touchPoint) else{
                if editingCell != nil {
                    removeEditView()
                }
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
            guard
                let editingStartedWithCell = editingCell,
                let startPoint = editingTouchStartPoint else{
                    editingGestureEnded(touchPoint)
                    return
            }
            moveCell(editingStartedWithCell, offset: touchPoint.x - startPoint.x)
        case .Ended:
            editingGestureEnded(touchPoint)
        case .Failed:
            editingGestureEnded(touchPoint)
        case .Cancelled:
            editingGestureEnded(touchPoint)
            break
        case .Possible:
            break
        }
    }
    
    func beginEditing(touchPoint : CGPoint, editCell: UIView, addEditView: Bool){
        editingTouchStartPoint = touchPoint
        editingCell = editCell
        if(addEditView) {
            editView = addEditViewForCell(editCell)
        }
    }
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
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
    
    func moveCell(cell : UIView, offset : CGFloat){
        //Positive Inset means user is swiping right
        //Negative less than -(editViewWidth + kDefaultListingEditViewBounceUpto) means user moved a lot to left
        guard let editView = editView where offset > -(editViewWidth + kDefaultListingEditViewBounceUpto) && offset < 0 else{
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
                editingTouchStartPoint = nil
                return
        }
        
        //If User moved more than half of edit view width then it should show editView fully
        guard abs(startPoint.x - point.x) > (editViewWidth/2) else{
            removeEditView()
            return
        }
        
        UIView.animateWithDuration(0.3, animations: {
            currentCell.frame.origin.x = -self.editViewWidth
            editView.frame.origin.x = currentCell.frame.origin.x + currentCell.frame.width
            editView.frame.size.width = -currentCell.frame.origin.x
            }, completion: { [weak self] sunccess in
                self?.editingTouchStartPoint = nil
        })
    }
    
    func removeEditView() -> Bool{
        guard let currentCell = editingCell,
            let editView = editView else{
                self.editingTouchStartPoint = nil
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
    
    func getCellFrameInCollectionView(cellFrame : CGRect) -> CGRect{
        return convertRect(cellFrame, fromCoordinateSpace: self)
    }
    
    func getCellFromTouch(point : CGPoint) -> UIView?{
        guard let visibleCells = getVisibleCells() else{
            return nil
        }
        
        for cell in visibleCells{
            let cellFrameInCollectionView = getCellFrameInCollectionView(cell.frame)
            if(CGRectContainsPoint(cellFrameInCollectionView, point)){
                return cell
            }
        }
        return nil
    }
    
    func addEditViewForCell(cell : UIView) -> UIView?{
        guard let indexPath = getIndexPathForCell(cell),
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
    
    func getVisibleCells() -> [UIView]?{
        guard let tableView = self as? UITableView else{
            guard let collectionView = self as? UICollectionView else{
                return nil
            }
            return collectionView.visibleCells()
        }
        return tableView.visibleCells
    }
    
    func getIndexPathForCell(cell : UIView) -> NSIndexPath?{
        guard let tableView = self as? UITableView,
            let tableCell = cell as? UITableViewCell else{
                guard let collectionView = self as? UICollectionView,
                    let collectionCell = cell as? UICollectionViewCell else{
                        return nil
                }
                return collectionView.indexPathForCell(collectionCell)
        }
        return tableView.indexPathForCell(tableCell)
    }
}


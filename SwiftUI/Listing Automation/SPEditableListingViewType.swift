//
//  SPEditableListingViewType.swift
//  Kamero
//
//  Created by Pradip V on 4/16/16.
//  Copyright © 2016 Happyfall. All rights reserved.
//


let kDefaultListingEditViewWidth : CGFloat = 80
let kDefaultListingEditViewBounceUpto : CGFloat = 60
private  let kDefaultListingEditViewMinimumScrollToAct : CGFloat = 30

public protocol SPEditableListingViewEditingDelegate : class{
    func editView(indexPath : IndexPath) -> UIView?
}

protocol SPEditableListingViewType : SPListingViewType{
    //editing Cell
    var enableEditing : Bool { get set }
    weak var editingCell : UIView?  {get set}
    var editingTouchStartPointInCell : CGPoint?  {get set}
    var touchStartPoint : CGPoint?  {get set}
    weak var editView : UIView?  {get set}
    var panGesture : UIPanGestureRecognizer?  {get set}
    weak var editingDelegate : SPEditableListingViewEditingDelegate?  {get set}
    var editViewWidth : CGFloat  {get set}
    
    func configurePanGesture()
}

extension SPEditableListingViewType where Self : UIScrollView{
    func enableEditingChanged(shouldEnable : Bool){
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
    
    func gestureShouldBegin(gestureRecognizer: UIGestureRecognizer)-> Bool{
        guard let customGesture = panGesture, customGesture == gestureRecognizer else{
            let _ = removeEditView()
            return true
        }
        
        let velocityPoint = customGesture.velocity(in: self)
        let isGestureIntoLeftDirection = velocityPoint.x < 0
        let isGestureInApproximateHorizontalDirectionToLeft = isGestureIntoLeftDirection && abs(velocityPoint.x) > (abs(velocityPoint.y) * 2)
        guard isGestureInApproximateHorizontalDirectionToLeft else {
            let _ = removeEditView()
            return false
        }
        
        return true
    }
    
    func userPanned(gesture : UIPanGestureRecognizer ){
        var touchPoint = gesture.location(in: self)

        switch(gesture.state)
        {
        case .began:
            //There must not be other gesture running, if thats not the case return.
            guard editingTouchStartPointInCell == nil else{
                return
            }
            touchStartPoint = touchPoint
            guard let editCell = getCellFromTouch(point: touchPoint) else{
                if editingCell != nil {
                    let _ = removeEditView()
                }
                return
            }
            
            guard let currentCell = editingCell else{
                beginEditing(touchPoint: touchPoint, editCell: editCell, addEditView: true)
                return
            }
            
            guard currentCell != editCell else{
                touchPoint.x += editViewWidth
                beginEditing(touchPoint: touchPoint, editCell: editCell, addEditView: false)
                return
            }
            
            if(!removeEditView()){
                beginEditing(touchPoint: touchPoint, editCell: editCell, addEditView: true)
            }
            
        case .changed:
            guard
                let editingStartedWithCell = editingCell,
                let startPoint = editingTouchStartPointInCell else{
                    editingGestureEnded(point: touchPoint)
                    return
            }
            moveCell(cell: editingStartedWithCell, offset: touchPoint.x - startPoint.x)
        case .ended:
            editingGestureEnded(point: touchPoint)
        case .failed:
            editingGestureEnded(point: touchPoint)
        case .cancelled:
            editingGestureEnded(point: touchPoint)
            break
        case .possible:
            break
        }
    }
    
    func beginEditing(touchPoint : CGPoint, editCell: UIView, addEditView: Bool){
        editingTouchStartPointInCell = touchPoint
        editingCell = editCell
        if(addEditView) {
            editView = addEditViewForCell(cell: editCell)
            if editView == nil {
                editingCell = nil
            }
        }
    }
    
    func moveCell(cell : UIView, offset : CGFloat){
        //Positive Inset means user is swiping right
        //Negative less than -(editViewWidth + kDefaultListingEditViewBounceUpto) means user moved a lot to left
        guard let editView = editView, offset > -(editViewWidth + kDefaultListingEditViewBounceUpto) && offset < 0 else{
            return
        }
        
        UIView.animate(withDuration: 0, animations: {
            cell.frame.origin.x = offset
            editView.frame.origin.x = cell.frame.origin.x + cell.frame.width
            editView.frame.size.width = -cell.frame.origin.x
        })
        
    }
    
    func editingGestureEnded(point : CGPoint){
        guard let currentCell = editingCell,
            let editView = editView,
            let screenStartPoint = touchStartPoint else{
                editingTouchStartPointInCell = nil
                return
        }
        
        let isUserMovingLeft = screenStartPoint.x > point.x
        let userMovedOffset = abs(screenStartPoint.x - point.x)
        let isUserMovedEnough = userMovedOffset > kDefaultListingEditViewMinimumScrollToAct
        guard isUserMovingLeft else{
            guard isUserMovedEnough else{
                showEditView(currentCell: currentCell, editView: editView)
                return
            }
            let _ = removeEditView()
            return
        }
        
        guard isUserMovedEnough else{
            let _ = removeEditView()
            return
        }
        showEditView(currentCell: currentCell, editView: editView)
    }
    
    private func showEditView(currentCell : UIView, editView : UIView){
        UIView.animate(withDuration: 0.3, animations: {
            currentCell.frame.origin.x = -self.editViewWidth
            editView.frame.origin.x = currentCell.frame.origin.x + currentCell.frame.width
            editView.frame.size.width = -currentCell.frame.origin.x
            }, completion: { [weak self] sunccess in
                self?.editingTouchStartPointInCell = nil
            })
    }
    
    func removeEditView() -> Bool{
        return removeEditView(onComplete: nil)
    }
    
    func removeEditView(onComplete : (()->Void)?) -> Bool{
        guard let currentCell = editingCell,
            let editView = editView else{
                self.editingTouchStartPointInCell = nil
                return false
        }
        
        self.editView = nil
        self.editingCell = nil
        self.editingTouchStartPointInCell = nil
        
        animateEditViewOut(currentCell: currentCell, editView: editView, onComplete : onComplete)
        return true
    }
    
    func animateEditViewOut(currentCell : UIView, editView : UIView, onComplete : (() ->Void)? ){
        UIView.animate(withDuration: 0.3, animations: {
            currentCell.frame.origin.x = 0
            editView.frame.origin.x = currentCell.frame.origin.x + currentCell.frame.width
            editView.frame.size.width = -currentCell.frame.origin.x
            }
            , completion: {[weak self]success in
                onComplete?()
                editView.removeFromSuperview()
                guard let cellBeforeAnimation = self?.editingCell, cellBeforeAnimation == currentCell else{
                        return
                }
            })
    }
    
    func getCellFrameInCollectionView(cellFrame : CGRect) -> CGRect{
        return convert(cellFrame, from: self)
    }
    
    func getCellFromTouch(point : CGPoint) -> UIView?{
        guard let visibleCells = getVisibleCells() else{
            return nil
        }
        
        for cell in visibleCells{
            let cellFrameInCollectionView = getCellFrameInCollectionView(cellFrame: cell.frame)
            if(cellFrameInCollectionView.contains(point)){
                return cell
            }
        }
        return nil
    }
    
    func addEditViewForCell(cell : UIView) -> UIView?{
        guard let indexPath = getIndexPathForCell(cell: cell),
            let editView = editingDelegate?.editView(indexPath: indexPath) else{
                return nil
        }
        var editViewFrame = getCellFrameInCollectionView(cellFrame: cell.frame)
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
            return collectionView.visibleCells
        }
        return tableView.visibleCells
    }
    
    func getIndexPathForCell(cell : UIView) -> IndexPath?{
        guard let tableView = self as? UITableView,
            let tableCell = cell as? UITableViewCell else{
                guard let collectionView = self as? UICollectionView,
                    let collectionCell = cell as? UICollectionViewCell else{
                        return nil
                }
                return collectionView.indexPath(for: collectionCell)
        }
        return tableView.indexPath(for: tableCell)
    }
}


# SwiftUI #

Speeds up iOS UI Development, Enforces developers to follow MVVM.

CollectionView

* Class of Collectionview in Storyboard should SPCollectionView

* 

* Setup CollectionView
var listingData : ListingData<ListingSection> = []
var layout : SPStraightVerticalLayout = SPStraightVerticalLayout(NoOfColumns: 2, ItemHeight: 200.0)

self.configureCollectionView()

private func configureCollectionView(){
        spCollectionView.controller = self
        spCollectionView.collectionViewLayout = layout
        spCollectionView.delegate = self
    }

* Create Data
listingData = [[SPTitleTestCCellModel(TitleText: "0")]]  // 1 Section and 1 Row

* Provide Data
//MARK: SwiftUI Collection View
extension AlbumsVC: SPListingControllerType{
    func listingData(collectionView: UICollectionView) -> ListingData<ListingSection> {
        return listingData
    }
}

* Reload Data
spCollectionView.registerReusableCellsIfRequired()
spCollectionView.reloadData()

* Delegate
// MARK: Collectionview delegate
extension AlbumsVC : UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
    }

}



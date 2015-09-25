# SwiftUI #

Speeds up iOS UI Development, Enforces developers to follow MVVM.

CollectionView

* Setup CollectionView
spCollectionView.controller = self
spCollectionView.collectionViewLayout = layout

* Create Data
collectionData = [[SPTitleTestCCellModel(TitleText: "0")]]  // 1 Section and 1 Row

* Provide Data
extension AlbumsVC: SPCollectionListingControllerType{
    func collectionListingData(collectionView: UICollectionView) -> ListingData<CollectionViewSection> {
    return collectionData    //collectionData : ListingData<CollectionViewSection>
    }
}

* Reload Data
spCollectionView.registerReusableCellsIfRequired()
spCollectionView.reloadData()


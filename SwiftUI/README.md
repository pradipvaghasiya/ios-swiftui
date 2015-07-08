# SwiftUI #

Speeds up iOS UI Development, Enforces developers to follow MVC.

#ListinAutomation 

To Create a TableView or Collection view you just need to create the SPListingData and provide it to SwiftUI views. It will generate the TableView or CollectionView for you.

###SPListingData
SPListingData contains array of SPListingSection. 

SPListingSection contains array of SPListingCellGroup.

SPListingCellGroup Contains Cell Details of same type. 

Reusability: Here you can create Cell once and use it in all your apps without changing the single line of code!!


###Below code will create the UITableView for you. 
This Tableview contains SPTitleLabelCell as its rows. You can create generic tableview cells and use it with SwiftUI.

 var spTableView = SPTableView(frame: self.view.frame)

// This is the model we need to show in TableView


```
#!swift

var section0Rows = [
"Basic TableView",
"Custom TableView",
"Fixed Column and Row Vertical",
"Fixed Column and Row Horizontal",
"Straight Vertical",
"Straight Space Optimized Vertical",
"Auto Resizing Straight Vertical"]

// Assign spListingData to SPTableView
spTableView.spListingData = SPTitleLabelCell.getBasicDefaultSPListingData(UsingStringArray: section0Rows)

// TableView Delegate
spTableView.delegate = self

//Add spTableView
self.view.addSubview(spTableView)

```

###Below code will create the UICollectionView for you. 
 
```
#!swift
lazy var verticalLayout = SPFixedColumnRowVerticalLayout()
 @IBOutlet weak var spCollectionView: SPCollectionView!    // Collection view added in Storyboard.
 
self.spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
CellGroups: [
SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: [
SPTitleTestCCellModel(TitleText: "0"),
SPTitleTestCCellModel(TitleText: "1")])]
),
SPListingSection(
CellGroups: [SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: [
SPTitleTestCCellModel(TitleText: "0"),
SPTitleTestCCellModel(TitleText: "1"),
SPTitleTestCCellModel(TitleText: "2"),
SPTitleTestCCellModel(TitleText: "3")
])]
)
]
)

self.spCollectionView.collectionViewLayout = verticalLayout

```

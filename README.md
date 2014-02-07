YUTableView is subclass of UITableView which adds expandable sub-menu support to it.

![1](http://i.imgur.com/QxzluZm.png)

#Installation
You can directly drag&drop **YUTableView** folder from demo to your project.

#Requirements
* ARC
* iOS 6 + (Should work on iOS 5, not tested)

#Usage
##Data Model
You must create a YUTableViewItem for all of your items.

###Properties
* ```itemData```: This is where you store the custom data of the cell.
* ```subItems```: A NSMutableArray, which has the subitems of the item. Every object in the array must be kind of YUTableViewItem. If you do not set subItems, it means that item does not have any subitem.
* ```cellIdentifier```: The identifier of the cell. If you don't set cellIdentifier, default identifier (which is a property of **YUTableView**) will be used. 
* ```status```: The current status (Selected/Not selected etc.) of the item. 

###How to init
```objc
// Initializing item with data. 
YUTableViewItem * item = [[YUTableViewItem alloc] initWithData: @"Label"];
// Initializing item with data and cell identifier.
YUTableViewItem * item2 = [[YUTableViewItem alloc] initWithSubitems: nil data: @"item" identifier: @"Cell"];
// Initializing item with subitems, data and cell identifier. 
YUTableViewItem * item3 = [[YUTableViewItem alloc] initWithSubitems: @[item, item2] data: @{@"key":@"value"} identifier: @"Cell2"];
// Setting subitems of the item.
YUTableViewItem * item4 = [[YUTableViewItem alloc] initWithData: @"Item"];
item4.subItems = @[item2, item3];
```

##Table
###How to init
First, initialize a YUTableView. You can use interface builder or code, just use YUTableView as a custom class instead of UITableVew. 
```objc
// If you are not using interface builder;
YUTableView * table = [[YUTableView alloc] initWithFrame: self.view.frame];
```
In order to set cells you should create your items and add them in an NSArray/NSMutableArray. Then you can set cells with **setCellsFromArray: cellIdentifier:** method of YUTableView.
```objc
 YUTableViewItem * subitem = [[YUTableViewItem alloc]  initWithData: @{@"label" : @"subitem"}];
 YUTableViewItem * item = [[YUTableViewItem alloc]  initWithData: @{@"label" : @"item"}];
 item.subItems = @[subitem];
 [_tableView setCellsFromArray: @[item] cellIdentifier: @"Cell"];
 ```
 You don't have to set a default cell identifier but in that case every YUTableViewItem must have an identifier.

###Usage of YUTableView
####Being notified when user selected cell
Your view controller should implement "YUTableViewDelegate" and you should set "parentView" property of your YUTableView to this view controller.
```objc
@interface BasicViewController () <YUTableViewDelegate>
//...
- (void) setTable
{
	YUTableView * table;
	// Initialize cells etc.
	// Setting delegate
	table.parentView = self;
}

 - (void) didSelectedRow: (YUTableViewItem *) cellItem
 {
 	NSString * data = cellItem.itemData;
    NSLog (@"%@", data);
 }
 ```

####Different cell heights
"YUTableViewDelegate" has "heightForItem:" method to provide different cell heights.
```objc
 - (CGFloat) heightForItem: (YUTableViewItem *) item
 {
    NSString * cellType = item.itemData;
    if ([cellType isEqualToString: @"myCell"])
    {
    	if (item.status == YUTableViewStatusSelected)
    		return 80;
    	return 100;
    }
    return 120;
 }
```

####Displaying only selected subitems
 If you want to display only subitems of the last selected item, you should set **showAllItems** property of YUTableView to NO. 
 
![1](http://i.imgur.com/exMl16O.png)

To set back button;
```objc
YUTableView * table;
//...
table.showAllItems = NO;
// Creating back button.
YUTableViewItem * item  = [[YUTableViewItem alloc] initWithData: @"Back"];
// Setting back button.
[self.tableView setRootItem: item];
```

####Selecting cells programmatically

 ```objc
YUTableView * table;
NSArray * itemList;
//...
[_tableView selectItem: itemList [0] animate: NO];
```

####Setting animation type
```objc
YUTableView * table;
//...
// Changes the animation of inserting cells.
table.insertRowAnimation = UITableViewRowAnimationLeft;
// Changes the animation of removing cells.
table.deleteRowAnimation = UITableViewRowAnimationRight;
```

####Animation duration and completion
You can change animation duration of inserting/deleting cells and set a block which will executed after animation was completed.
NOTE: Animation duration is only works with iOS 7.
```objc
YUTableView * table;
//...
table.animationDuration = 5;
table.competitionBlock = ^(void) {
    NSLog( @"Animation completed!");
};
```

##Cells
You must create custom class for your cells and this custom class must implement **YUTableViewCellDelegate**. "setCellContentsFromItem:" is the method where you set your cell.
```objc
- (void) setCellContentsFromItem: (YUTableViewItem *) item
{
    NSMutableDictionary * data  = item.itemData;
    self.title.text     = data[@"title"];
    self.label.text     = data[@"label"];
    
    if (item.status == YUTableViewItemStatusSubmenuOpened)
        self.contentView.backgroundColor = [UIColor grayColor];
    else
        self.contentView.backgroundColor = [UIColor whiteColor];
}
```

If you are loading your cell from xib you should register your nib to table view.
```objc
YUTableView * table;
//...
[tableView registerNib: [UINib nibWithNibName:@"Cell" bundle: nil] forCellReuseIdentifier: @"Cell"];
};
```

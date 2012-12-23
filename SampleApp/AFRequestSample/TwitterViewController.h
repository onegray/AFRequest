//
//  TwitterViewController.h
//
//  Created by onegray on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterViewController : UIViewController<UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end

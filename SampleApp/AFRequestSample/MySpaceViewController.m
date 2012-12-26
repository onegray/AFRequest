//
//  MySpaceViewController.m
//  AFRequestSample
//
//  Created by onegray on 12/26/12.
//  Copyright (c) 2012 onegray. All rights reserved.
//

#import "MySpaceViewController.h"
#import "MSPeopleSearchRequest.h"
#import "MySpaceConnection.h"

@interface MySpaceViewController ()

@property (nonatomic, strong) NSArray* results;

@end

@implementation MySpaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"MySpace";
    }
    return self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	MSPeopleSearchRequest* request = [MSPeopleSearchRequest requestWithSearchTerms:searchBar.text delegate:nil];
	request.completionHandler = ^(MSPeopleSearchRequest* request, MSPeopleSearchResponse* response) {
		if(response.success) {
			self.results = response.searchResults;
			[self.tableView reloadData];
		} else {
			[[[UIAlertView alloc] initWithTitle:@"Error" message:[response.error localizedDescription]
									   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
		}
	};
	[[MySpaceConnection sharedConnection] performRequest:request];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.results count];
}

-(UITableViewCell*) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    UITableViewCell* cell = [tv dequeueReusableCellWithIdentifier:cellId];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [self.results objectAtIndex:indexPath.row];
    return cell;
}



@end






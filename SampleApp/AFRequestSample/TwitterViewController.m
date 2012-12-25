//
//  TwitterViewController.m
//
//  Created by onegray on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterViewController.h"

#import "TwitterConnection.h"
#import "TwitterSearchRequest.h"


@interface TwitterViewController ()
@property (nonatomic, retain) NSArray* results;
@end

@implementation TwitterViewController
@synthesize tableView;
@synthesize results;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Twitter";
    }
    return self;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [[TwitterConnection sharedConnection] cancelRequestsForTarget:self];
	[[TwitterConnection sharedConnection] performRequest:[TwitterSearchRequest requestWithQuery:searchBar.text delegate:self]];
	
    [searchBar resignFirstResponder];
}

-(void) requestTwitterSearch:(TwitterSearchRequest*)request didFinishWithResponse:(TwitterSearchResponse*)response;
{
    if(response.success)
    {
        self.results = response.searchResults;
        [tableView reloadData];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[response.error localizedDescription] 
                                    delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource methods

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [results count];
}

-(UITableViewCell*) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString* cellId = @"cellId";
    UITableViewCell* cell = [tv dequeueReusableCellWithIdentifier:cellId];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [results objectAtIndex:indexPath.row];
    return cell;
}



@end





















//
//  ViewController.h
//  TableViewSearch
//
//  Created by iStef on 30.07.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)sortPersons:(UISegmentedControl *)sender;

@end


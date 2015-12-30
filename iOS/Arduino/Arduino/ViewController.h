//
//  ViewController.h
//  Arduino
//
//  Created by Rodrigo Cavalcante on 12/29/15.
//  Copyright © 2015 Rodrigo Cavalcante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordDataSource.h"
#import "Record.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *recordTableView;
@property (retain, nonatomic) RecordDataSource *recordDataSource;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
- (IBAction)info:(id)sender;
- (void) detail:(Record *)record;
@end


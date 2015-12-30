//
//  RecordDataSource.h
//  Arduino
//
//  Created by Rodrigo Cavalcante on 12/29/15.
//  Copyright © 2015 Rodrigo Cavalcante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordCell.h"
#import "Record.h"

@class ViewController;

@interface RecordDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) ViewController *view;
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *records;

-(id)initWithTableView:(UITableView *)tableView andViewController:(ViewController *)view;
-(void)refreshWithSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end

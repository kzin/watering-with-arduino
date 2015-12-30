//
//  RecordDataSource.m
//  Arduino
//
//  Created by Rodrigo Cavalcante on 12/29/15.
//  Copyright © 2015 Rodrigo Cavalcante. All rights reserved.
//

#import "RecordDataSource.h"
#import "ViewController.h"

@interface RecordDataSource ()

@end

@implementation RecordDataSource

-(id)initWithTableView:(UITableView *)tableView andViewController:(ViewController *)view {
    self = [super init];
    if(self)
    {
        UINib *nib = [UINib nibWithNibName:@"RecordCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"RecordCell"];
        
        self.tableView = tableView;
        
        self.records = [NSMutableArray new];
        _view = view;
    }
    return self;
}

-(void)refreshWithSuccess:(void (^)(void))success
                  failure:(void (^)(void))failure {
    PFQuery *query = [PFQuery queryWithClassName:@"Record"];
    query.limit = 1000;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *records, NSError *error) {
        if (!error) {
            // Do something with the found objects
            self.records = [NSMutableArray arrayWithArray:records];
            if([self.records count] == 0) {
                UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
                
                messageLabel.text = @"Nenhum registro encontrado.";
                messageLabel.textColor = [UIColor blackColor];
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = NSTextAlignmentCenter;
                messageLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
                [messageLabel sizeToFit];
                
                self.tableView.backgroundView = messageLabel;
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            } else {
                self.tableView.backgroundView = nil;
                [self.tableView reloadData];
            }
            
            success();
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            failure();
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.records count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    Record *record = [self.records objectAtIndex:indexPath.row];
    
    cell.contentView.userInteractionEnabled = NO;
    
    cell.bottomView.hidden = NO;
    
    if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
        cell.bottomView.hidden = YES;
    
    cell.temperature.text = [NSString stringWithFormat:@"Temperatura registrada: %@˚C",[record objectForKey:@"temperature"]];
    cell.data.text = [NSString stringWithFormat:@"Em: %@",[record formatedCreatedAt]];
    [cell loadImage:[NSURL URLWithString:[[record objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Record *record = [self.records objectAtIndex:indexPath.row];
    [_view detail:record];
}


@end

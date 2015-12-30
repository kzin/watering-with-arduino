//
//  ViewController.m
//  Arduino
//
//  Created by Rodrigo Cavalcante on 12/29/15.
//  Copyright © 2015 Rodrigo Cavalcante. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "Record.h"
#import "SSSnackbar.h"
#import "RecordDetailViewController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setShadow:self.headerView.layer];
    // Do any additional setup after loading the view, typically from a nib.
    _recordDataSource = [[RecordDataSource alloc] initWithTableView:self.recordTableView andViewController:self];
    self.recordTableView.dataSource = _recordDataSource;
    self.recordTableView.delegate = _recordDataSource;
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.recordTableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = UIColorFromRGB(0x388E3C);
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = self.refreshControl;
    
    [self refresh];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:@"client" forKey:@"channels"];
    [currentInstallation saveInBackground];
}

-(void)refresh{
    [_recordDataSource refreshWithSuccess:^{
        if(self.refreshControl) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *title = [NSString stringWithFormat:@"Última atualização: %@", [formatter stringFromDate:[NSDate date]]];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:UIColorFromRGB(0x000000)
                                                                        forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
            self.refreshControl.attributedTitle = attributedTitle;
            
            [self.refreshControl endRefreshing];
        }
        
    } failure:^{
        [[SSSnackbar snackbarWithMessage:@"Não foi possível atualizar os dados." actionText:nil duration:3 actionBlock:nil dismissalBlock:nil] show];
        
        if(self.refreshControl)
            [self.refreshControl endRefreshing];
    }];
}

- (void) detail:(Record *)record {
    RecordDetailViewController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RecordDetailViewController"];
    detail.record = record;
    [self presentViewController:detail animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setShadow:(CALayer *)layer{
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 4.0f;
    layer.shadowOpacity = 0.30f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
}

- (IBAction)info:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Hortinha 1.0"
                                                                   message:@"Desenvolvido por Rodrigo Cavalcante"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end

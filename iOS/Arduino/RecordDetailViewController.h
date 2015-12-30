//
//  RecordDetailViewController.h
//  Arduino
//
//  Created by Rodrigo Cavalcante on 12/30/15.
//  Copyright © 2015 Rodrigo Cavalcante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"

@interface RecordDetailViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (retain, nonatomic) Record *record;

- (IBAction)back:(id)sender;

@end

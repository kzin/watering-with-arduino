//
//  RecordCell.h
//  Arduino
//
//  Created by Rodrigo Cavalcante on 12/29/15.
//  Copyright © 2015 Rodrigo Cavalcante. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UILabel *data;


-(void)loadImage:(NSURL *) url;
@end

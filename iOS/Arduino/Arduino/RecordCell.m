//
//  RecordCell.m
//  Arduino
//
//  Created by Rodrigo Cavalcante on 12/29/15.
//  Copyright © 2015 Rodrigo Cavalcante. All rights reserved.
//

#import "RecordCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation RecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadImage:(NSURL *) url{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    self.picture.layer.cornerRadius = self.picture.frame.size.width / 2;
    self.picture.clipsToBounds = YES;
    self.picture.layer.borderWidth = 0.8f;
    self.picture.layer.borderColor = UIColorFromRGB(0xaaaaaa).CGColor;
    
    [self.picture setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"info"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        self.picture.image = image;
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"Failed to load picture");
    }];
}

@end

//
//  Record.h
//  Arduino
//
//  Created by Rodrigo Cavalcante on 12/29/15.
//  Copyright © 2015 Rodrigo Cavalcante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Record : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (retain) NSString *name;
@property float temperature;
@property (retain) NSString *url;

-(NSString *)formatedCreatedAt;
@end

//
//  Record.m
//  Arduino
//
//  Created by Rodrigo Cavalcante on 12/29/15.
//  Copyright © 2015 Rodrigo Cavalcante. All rights reserved.
//

#import "Record.h"
#import <Parse/PFObject+Subclass.h>

@implementation Record
@dynamic name;
@dynamic url;
@dynamic temperature;

+ (NSString *)parseClassName {
    return @"Record";
}

-(NSString *)formatedCreatedAt {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy' às 'HH:mm";
    
    NSTimeZone *gmt = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:gmt];
    
   return [dateFormatter stringFromDate:self.createdAt];
}

@end

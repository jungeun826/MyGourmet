//
//  Resturants.h
//  MyGourmet
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resturant : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *tag;
@property (strong, nonatomic) NSString *detail;
@property (nonatomic) float lon;
@property (nonatomic) float lat;
@property (strong, nonatomic) NSString *locationName;
@property (nonatomic) int rowID;
- (id)initWithName:(NSString *)name locationName:(NSString *)locationName tag:(NSString *)tag detail:(NSString *)detail lon:(float)lon lat:(float)lat;

@end

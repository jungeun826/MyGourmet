//
//  Resturants.m
//  MyGourmet
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "Resturant.h"

@implementation Resturant
- (id)initWithName:(NSString *)name locationName:(NSString *)locationName tag:(NSString *)tag detail:(NSString *)detail lon:(float)lon lat:(float)lat {
    self = [super init];
    if (self) {
        self.name = name;
        self.tag = tag;
        self.detail = detail;
        self.lon = lon;
        self.lat = lat;
        self.locationName = locationName;
    }
    return self;
}
@end

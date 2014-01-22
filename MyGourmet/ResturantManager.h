//
//  ResturantManager.h
//  MyGourmet
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Resturant.h"

@interface ResturantManager : NSObject
+ (id)sharedResturantManager;

- (void)requestRestrant;
- (void)addRestruantWithResturant:(Resturant *)resturant;
- (void)removeRestruantWithRowID:(NSInteger)rowID;
- (NSInteger)getNumberOfResturants;
- (Resturant *)getResturantAtIndex:(NSInteger)index;

@end

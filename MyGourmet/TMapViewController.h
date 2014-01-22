//
//  TMapViewController.h
//  MyGourmet
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMapView.h"

@interface TMapViewController : UIViewController <TMapViewDelegate>
@property (nonatomic) float lon;
@property (nonatomic) float lat;

@end

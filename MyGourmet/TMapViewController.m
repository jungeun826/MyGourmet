//
//  TMapViewController.m
//  MyGourmet
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "TMapViewController.h"
#define APP_KEY @"436686fb-a4ea-3149-b8b1-7b1af6226827"
#define NAVIGATORBAR_HEIGHT 72
@interface TMapViewController ()
@property (strong, nonatomic) TMapView *mapView;
@end

@implementation TMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect rect = CGRectMake(0, NAVIGATORBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAVIGATORBAR_HEIGHT);
    
    self.mapView = [[TMapView alloc]initWithFrame:rect];
    [self.mapView setSKPMapApiKey:APP_KEY];
    // self.mapView.zoomLevel = 12;
    
    self.mapView.delegate = self;
    
    
    [self.view addSubview:self.mapView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addMarker{
    NSString *itemID = @"T-ACADEMY";
    
    TMapPoint *point= [[TMapPoint alloc]initWithLon:self.lon Lat:self.lat];
    [self.mapView setCenterPoint:point];
    TMapMarkerItem *marker = [[TMapMarkerItem alloc]initWithTMapPoint:point];
    [marker setIcon:[UIImage imageNamed:@"토끼.jpg"]];
    
    [marker setCanShowCallout:YES];
    //[marker setCalloutTitle:@"티 아카데미"];
    //[marker setCalloutRightButtonImage:[UIImage imageNamed:@"_Right"]];
    
    [self.mapView addTMapMarkerItemID:itemID Marker:marker];
}
@end

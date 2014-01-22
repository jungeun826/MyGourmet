//
//  TMapViewController.m
//  MyGourmet
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "TMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#define APP_KEY @"436686fb-a4ea-3149-b8b1-7b1af6226827"
#define NAVIGATORBAR_HEIGHT 68
#define WORK 1
@interface TMapViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) TMapView *mapView;
@property (strong, nonatomic) TMapMarkerItem *startMark, *endMark;

@end

@implementation TMapViewController{
    CLLocationManager *_coreLocationManager;
    float _curLat;
    float _curLon;
}
-(void) locationManager: (CLLocationManager *) manager
    didUpdateToLocation: (CLLocation *) newLocation
           fromLocation: (CLLocation *) oldLocation {
    _curLat = newLocation.coordinate.latitude;
    _curLon= newLocation.coordinate.longitude;
    
    NSLog(@"map update location %f, %f", _curLon,_curLat);

}
-(void) locationManager: (CLLocationManager *) manager didFailWithError: (NSError *) error {
    NSString *msg = @"Error obtaining location";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS 수신 설정해주세요" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
}

-(void)showPath{
    TMapPathData *path = [[TMapPathData alloc]init];
    
    TMapPolyLine *line = [path findPathDataWithType:WORK startPoint:[self.startMark getTMapPoint] endPoint:[self.endMark getTMapPoint]];
    
    if(line != nil){
        [self.mapView showFullPath:@[line]];
        
        [self.mapView bringMarkerToFront:self.startMark];
        [self.mapView bringMarkerToFront:self.endMark];
    }
    [_coreLocationManager stopUpdatingLocation];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _coreLocationManager = [[CLLocationManager alloc] init];
    if([CLLocationManager locationServicesEnabled]) {
        _coreLocationManager.delegate = self;
        _coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _coreLocationManager.distanceFilter = 50.0f;
        
        [_coreLocationManager startUpdatingLocation];
    }
    
    CGRect rect = CGRectMake(0, NAVIGATORBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAVIGATORBAR_HEIGHT);
    
    self.mapView = [[TMapView alloc]initWithFrame:rect];
    [self.mapView setSKPMapApiKey:APP_KEY];

    TMapPoint *startPoint = [[TMapPoint alloc]initWithLon:_curLon Lat:_curLat];
    TMapPoint *endPoint=[[TMapPoint alloc]initWithLon:self.lon Lat:self.lat];
    
    [self.mapView setCenterPoint:endPoint];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    
    
    self.endMark = [[TMapMarkerItem alloc]init];
    [self.endMark setIcon:[UIImage imageNamed:@"icon.png"]];
    [self.endMark setTMapPoint:endPoint];
    [self.mapView addCustomObject:self.endMark ID:@"END"];
    
    self.startMark = [[TMapMarkerItem alloc]init];
    [self.startMark setIcon:[UIImage imageNamed:@"_Right.png"]];
    [self.startMark setTMapPoint:startPoint];
    [self.mapView addCustomObject:self.startMark ID:@"START"];
    
    [self performSelector:@selector(showPath) withObject:nil afterDelay:2];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

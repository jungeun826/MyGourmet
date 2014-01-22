//
//  ViewController.m
//  MyGourmet
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ViewController.h"
#import "ResturantManager.h"
#import <CoreLocation/CoreLocation.h>
#import "ResturantCell.h"
#import "DetailViewController.h"

#define MARGIN_Y 30
#define HIDDEN_Y 600
@interface ViewController () <CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UITextField *locationNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *resturantNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UITableView *resturantTable;

@end

@implementation ViewController{
    ResturantManager *_resturantManager;
    CLLocationManager *_coreLocationManager;
    float _lon;
    float _lat;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailViewController *DetailVC = segue.destinationViewController;
    
    NSIndexPath *selectedIndex = [self.resturantTable indexPathForSelectedRow];
    Resturant *resturant = [_resturantManager getResturantAtIndex:selectedIndex.row];
    DetailVC.resturant = resturant;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_resturantManager getNumberOfResturants];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResturantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RESTURANT_CELL" forIndexPath:indexPath];
    Resturant *resturant = [_resturantManager getResturantAtIndex:indexPath.row];
    [cell setResturantInfo:resturant];
    
    return cell;
}
//밀어서 셀 삭제
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Resturant *resturant = [_resturantManager getResturantAtIndex:indexPath.row];
    //DB에서 삭제후 릴로드
    [_resturantManager removeRestruantWithRowID:resturant.rowID];
    [_resturantManager requestRestrant];
    //테이블 셀 삭제
    NSArray *rows = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void) locationManager: (CLLocationManager *) manager
    didUpdateToLocation: (CLLocation *) newLocation
           fromLocation: (CLLocation *) oldLocation {
    _lat = newLocation.coordinate.latitude;
    _lon= newLocation.coordinate.longitude;
    
    NSLog(@"update location %f, %f", _lon, _lat);
}
-(void) locationManager: (CLLocationManager *) manager didFailWithError: (NSError *) error {
    NSString *msg = @"Error obtaining location";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS 수신 설정해주세요" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
}
- (void)changeRecordViewLocationWithY:(NSInteger)Y{
    self.recordView.frame = CGRectMake(self.recordView.frame.origin.x, Y, self.recordView.frame.size.width, self.recordView.frame.size.height);
}
- (IBAction)registerResturant:(id)sender {
    [_coreLocationManager stopUpdatingLocation];
    NSString *name = self.resturantNameTextfield.text;
    NSString *locationName = self.locationNameTextfield.text;
    NSString *tag = self.tagTextField.text;
    NSString *detail = self.detailTextView.text;
    NSLog(@"%@,%@,%@,%@,%f,%f",name,locationName,tag,detail,_lon, _lat);
    Resturant *resturant = [[Resturant alloc] initWithName:name locationName:locationName tag:tag detail:detail lon:_lon lat:_lat];
    [_resturantManager addRestruantWithResturant:resturant];
    
    [self changeRecordViewLocationWithY:HIDDEN_Y];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"완료" message:@"기록이 저장되었습니다." delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == alertView.firstOtherButtonIndex){
        [self initTextField];
        [_resturantManager requestRestrant];
        [self.resturantTable reloadData];
    }
}
- (void)initTextField{
    self.resturantNameTextfield.text = @"";
    self.locationNameTextfield.text = @"";
    self.tagTextField.text = @"";
    self.detailTextView.text = @"";
}
- (IBAction)cancelResturant:(id)sender {
    [self changeRecordViewLocationWithY:HIDDEN_Y];
    [self initTextField];
    
    [self.resturantTable reloadData];
}

- (IBAction)recordResturant:(id)sender {
    [self changeRecordViewLocationWithY:MARGIN_Y];
    [_coreLocationManager startUpdatingLocation];
    //[self.resturantTable reloadData];
}

//view 나타날 때 불리는 함수들
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    
    [self changeRecordViewLocationWithY:HIDDEN_Y];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _resturantManager = [ResturantManager sharedResturantManager];
    [_resturantManager requestRestrant];

    
    
    _coreLocationManager = [[CLLocationManager alloc] init];
    if([CLLocationManager locationServicesEnabled]) {
        _coreLocationManager.delegate = self;
        _coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _coreLocationManager.distanceFilter = 50.0f;
        
        [_coreLocationManager startUpdatingLocation];
    }
}
//메모리 부족시 불림
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

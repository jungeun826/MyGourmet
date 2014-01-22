//
//  DetailViewController.m
//  MyGourmet
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DetailViewController.h"
#import "TMapViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *resturantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailView;

@end

@implementation DetailViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    TMapViewController *mapVC = segue.destinationViewController;
    
    mapVC.lon = self.resturant.lon;
    mapVC.lat = self.resturant.lat;
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    
    self.locationNameLabel.text = self.resturant.locationName;
    self.resturantNameLabel.text = self.resturant.name;
    self.tagLabel.text = self.resturant.tag;
    self.detailView.text = self.resturant.detail;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

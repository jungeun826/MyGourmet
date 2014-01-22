//
//  ResturantCell.m
//  MyGourmet
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ResturantCell.h"
@interface ResturantCell()
@property (weak, nonatomic) IBOutlet UILabel *resturantName;
@property (weak, nonatomic) IBOutlet UILabel *locationName;

@end
@implementation ResturantCell
-(void)setResturantInfo:(Resturant *)resturant{
    self.resturantName.text = resturant.name;
    self.locationName.text = resturant.locationName;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

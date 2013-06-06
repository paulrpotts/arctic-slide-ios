//
//  ArcticSlideViewController.m
//  ArcticSlide
//
//  Created by Paul R. Potts on 6/4/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//

#import "ArcticSlideViewController.h"
#import "ArcticSlideModel.h"

@interface ArcticSlideViewController ()
{
    ArcticSlideModel* model;
}
@end

@implementation ArcticSlideViewController

- (id)init
{
    model = [[ArcticSlideModel alloc] init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

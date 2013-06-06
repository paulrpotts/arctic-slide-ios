//
//  ArcticSlideTests.m
//  ArcticSlideTests
//
//  Created by Paul R. Potts on 6/4/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//

#import "ArcticSlideTests.h"

@implementation ArcticSlideTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    // ArcticSlideModel *model = [[ArcticSlideModel alloc] init];
    // NSLog(@"%@", model);

    ArcticSlideModel *model_from_level = [[ArcticSlideModel alloc] initWithLevelIndex:0];
    NSLog(@"%@", model_from_level);   
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in ArcticSlideTests");
}

@end

//
//  LifeScheduleTests.m
//  LifeScheduleTests
//
//  Created by 杨善成 on 6/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface LifeScheduleTests : XCTestCase

@end

@implementation LifeScheduleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    int a = 0;
    XCTAssertTrue(a==0,@"a必须为0");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

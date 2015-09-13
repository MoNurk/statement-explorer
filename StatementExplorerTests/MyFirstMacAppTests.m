//
//  MyFirstMacAppTests.m
//  MyFirstMacAppTests
//
//  Created by Muhammed Nurkerim on 11/09/2015.
//  Copyright (c) 2015 Muhammed Nurkerim. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@interface MyFirstMacAppTests : XCTestCase

@end

@implementation MyFirstMacAppTests

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
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

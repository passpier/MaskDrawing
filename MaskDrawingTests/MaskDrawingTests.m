//
//  MaskDrawingTests.m
//  MaskDrawingTests
//
//  Created by Vincent Cheng on 2018/1/9.
//  Copyright © 2018年 Vincent Cheng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FakeColorMaskViewModel.h"

@interface MaskDrawingTests : XCTestCase {
    ColorMaskViewModel *_colorMaskViewModel;
}

@end

@implementation MaskDrawingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    CGFloat colorVewWidth = 200;
    CGFloat colorVewHeight = 100;
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, colorVewWidth, colorVewHeight)];
    _colorMaskViewModel = [[FakeColorMaskViewModel alloc] initWithColorView:colorView];
    
    self.continueAfterFailure = NO;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Create new ip cam mask

- (void)testCreateNewColorMaskView {
    [self createNewColorMaskView];
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:30 Y:30 Width:50 Height:50]);
}

- (void)testCreateNewColorMaskViewOutOfTopBound {
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeAdd;
    CGPoint startPoint = CGPointMake(10, 10);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(10, 10);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(15, -15);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(30, -30);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(30, -30);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:10 Y:0 Width:20 Height:10]);
}

- (void)testCreateNewColorMaskViewOutOfLeftBound {
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeAdd;
    CGPoint startPoint = CGPointMake(10, 10);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(10, 10);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(-15, 15);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(-30, 30);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(-30, 30);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:0 Y:10 Width:10 Height:20]);
}

- (void)testCreateNewColorMaskViewOutOfRightBound {
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeAdd;
    CGPoint startPoint = CGPointMake(10, 10);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(10, 10);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(200, 20);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(210, 20);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(210, 20);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:10 Y:10 Width:190 Height:10]);
}

- (void)testCreateNewColorMaskViewOutOfBottomBound {
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeAdd;
    CGPoint startPoint = CGPointMake(10, 10);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(10, 10);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(20, 100);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(20, 110);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(20, 110);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:10 Y:10 Width:10 Height:90]);
}

- (void)testCreateThreeNewColorMaskView {
    [self createNewColorMaskView];
    [self createNewColorMaskView];
    [self createNewColorMaskView];
    
    int ipMaskViewCount = [self getColorMaskViewMatchedSubViewsCountWithX:30 Y:30 Width:50 Height:50];
    XCTAssertEqual(ipMaskViewCount, 3);
}

#pragma mark - Resize ip cam mask

- (void)testResizeColorMaskViewFromLeftTopPoint {
    [self createNewColorMaskView];
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeResizing;
    CGPoint startPoint = CGPointMake(30, 30);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(30, 30);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(20, 20);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(10, 10);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(10, 10);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:10 Y:10 Width:70 Height:70]);
}

- (void)testResizeColorMaskViewFromRightTopPoint {
    [self createNewColorMaskView];
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeResizing;
    CGPoint startPoint = CGPointMake(80, 30);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(80, 30);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(70, 20);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(60, 10);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(60, 10);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:30 Y:10 Width:30 Height:70]);
}

- (void)testResizeColorMaskViewFromLeftBottomPoint {
    [self createNewColorMaskView];
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeResizing;
    CGPoint startPoint = CGPointMake(30, 80);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(30, 80);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(20, 90);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(10, 100);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(10, 100);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:10 Y:30 Width:70 Height:70]);
}

- (void)testResizeColorMaskViewFromRightBottomPoint {
    [self createNewColorMaskView];
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeResizing;
    CGPoint startPoint = CGPointMake(80, 80);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(80, 80);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(90, 90);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(100, 100);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(100, 100);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:30 Y:30 Width:70 Height:70]);
}

- (void)testResizeColorMaskViewFromOutSide {
    [self createNewColorMaskView];
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeResizing;
    CGPoint startPoint = CGPointMake(9, 9);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(9, 9);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(20, 20);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(30, 30);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(30, 30);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:30 Y:30 Width:50 Height:50]);
}

#pragma mark - Move ip cam mask

- (void)testMoveColorMaskView {
    [self createNewColorMaskView];
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeChangePosition;
    CGPoint startPoint = CGPointMake(55, 55);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(55, 55);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(65, 65);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(75, 75);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(75, 75);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:50 Y:50 Width:50 Height:50]);
}

- (void)testMoveColorMaskViewOutOfTopBound {
    [self createNewColorMaskView];
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeChangePosition;
    CGPoint startPoint = CGPointMake(55, 55);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(55, 55);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(55, 20);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(55, 0);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(55, 0);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:30 Y:0 Width:50 Height:50]);
}

- (void)testMoveColorMaskViewOutOfLeftBound {
    [self createNewColorMaskView];
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeChangePosition;
    CGPoint startPoint = CGPointMake(55, 55);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(55, 55);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(20, 55);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(0, 55);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(0, 55);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:0 Y:30 Width:50 Height:50]);
}

- (void)testMoveColorMaskViewOutOfRightBound {
    [self createNewColorMaskView];
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeChangePosition;
    CGPoint startPoint = CGPointMake(55, 55);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(55, 55);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(90, 55);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(200, 55);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(200, 55);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:150 Y:30 Width:50 Height:50]);
}

- (void)testMoveColorMaskViewOutOfBottomBound {
    [self createNewColorMaskView];
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeChangePosition;
    CGPoint startPoint = CGPointMake(55, 55);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(55, 55);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(55, 75);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(55, 100);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(55, 100);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
    XCTAssertTrue([self isColorMaskViewMatchedTopViewWithX:30 Y:50 Width:50 Height:50]);
}

#pragma mark - Delete ip cam mask

- (void)testDeleteColorMaskView {
    [self createNewColorMaskView];
    [_colorMaskViewModel removeColorMaskByIndex:0];
    BOOL isRemoved = [self isColorMaskViewMatchedTopViewWithX:30 Y:30 Width:50 Height:50] == 0 && _colorMaskViewModel.colorMaskList.count == 0;
    XCTAssertTrue(isRemoved);
}

#pragma mark - Select ip cam mask

- (void)testSelectColorMaskView {
    [self createNewColorMaskView];
    [self createNewColorMaskView2];
    
    if ([self isColorMaskViewMatchedTopViewWithX:30 Y:30 Width:60 Height:60] ) {
        XCTAssertTrue(YES);
    } else {
        XCTAssertTrue(NO);
    }
    
    [_colorMaskViewModel selectColorMaskByIndex:0];
    
    if ([self isColorMaskViewMatchedTopViewWithX:30 Y:30 Width:50 Height:50] ) {
        XCTAssertTrue(YES);
    } else {
        XCTAssertTrue(NO);
    }
}


#pragma mark -

/**
 Mask view frame:(30,30,50,50)
 */
- (void)createNewColorMaskView {
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeAdd;
    CGPoint startPoint = CGPointMake(30, 30);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(30, 30);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(50, 50);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(80, 80);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(80, 80);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
}

/**
 Mask view frame:(30,30,60,60)
 */
- (void)createNewColorMaskView2 {
    _colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeAdd;
    CGPoint startPoint = CGPointMake(30, 30);
    [_colorMaskViewModel colorViewTouchesBegan:startPoint];
    CGPoint movePoint1 = CGPointMake(30, 30);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint1];
    CGPoint movePoint2 = CGPointMake(50, 50);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint2];
    CGPoint movePoint3 = CGPointMake(90, 90);
    [_colorMaskViewModel colorViewTouchesMoved:movePoint3];
    CGPoint endPoint = CGPointMake(90, 90);
    [_colorMaskViewModel colorViewTouchesEnded:endPoint];
}

- (int)getColorMaskViewMatchedSubViewsCountWithX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height {
    int colorMaskViewMatchedCount = 0;
    for (id subView in _colorMaskViewModel.colorView.subviews) {
        if ([subView isMemberOfClass:[UIImageView class]]) {
            UIImageView *maskImageView = (UIImageView *)subView;
            if (maskImageView.frame.origin.x == x &&
                maskImageView.frame.origin.y == y &&
                maskImageView.frame.size.width == width &&
                maskImageView.frame.size.height == height) {
                colorMaskViewMatchedCount++;
            }
            
        }
    }
    
    return colorMaskViewMatchedCount;
}

- (BOOL)isColorMaskViewMatchedTopViewWithX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height {
    BOOL isColorMaskViewMatched = NO;
    UIImageView *maskImageView = [_colorMaskViewModel.colorView.subviews lastObject];
    if (maskImageView.frame.origin.x == x &&
        maskImageView.frame.origin.y == y &&
        maskImageView.frame.size.width == width &&
        maskImageView.frame.size.height == height) {
        isColorMaskViewMatched = YES;
    }
    
    return isColorMaskViewMatched;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

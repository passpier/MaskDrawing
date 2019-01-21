//
//  FakeColorMaskViewModel.m
//  MaskDrawingTests
//
//  Created by Vincent Cheng on 2018/1/17.
//  Copyright © 2018年 Vincent Cheng. All rights reserved.
//

#import "FakeColorMaskViewModel.h"

@implementation FakeColorMaskViewModel

#pragma mark - ColorMaskViewRecordProtocol methods

- (void)saveColorMasks:(NSMutableArray<ColorMask *> *)colorMasks {
    
}

- (NSMutableArray<ColorMask *> *)loadColorMasks {
    return [NSMutableArray new];
}

@end

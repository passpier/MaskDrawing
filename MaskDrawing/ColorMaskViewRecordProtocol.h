//
//  ColorMaskViewRecordProtocol.h
//  MaskDrawing
//
//  Created by Vincent Cheng on 2018/1/17.
//  Copyright © 2018年 Vincent Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ColorMask;

@protocol ColorMaskViewRecordProtocol <NSObject>
@required
- (void)saveColorMasks:(NSMutableArray<ColorMask *> *)colorMasks;
- (NSMutableArray<ColorMask *> *)loadColorMasks;
@end

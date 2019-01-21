//
//  ColorMask.h
//  MaskDrawing
//
//  Created by Vincent Cheng on 2018/1/12.
//  Copyright © 2018年 Vincent Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorMask : NSObject

/**
 The display view over the ip cam view
 */
@property (strong, nonatomic) UIImageView *rectangleView;
/**
 Contain four vertices in rectangle: leftTop, rightTop, leftBottom, rightBottom
 */
@property (strong, nonatomic) NSArray *vertices;
/**
 The display name for ColorMask
 */
@property (strong, nonatomic) NSString *name;

@end

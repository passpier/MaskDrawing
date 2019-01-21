//
//  ColorMaskViewModel.h
//  MaskDrawing
//
//  Created by Vincent Cheng on 2018/1/12.
//  Copyright © 2018年 Vincent Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorMaskViewRecordProtocol.h"
#import "ColorMask.h"

typedef NS_ENUM(NSUInteger, ColorMaskViewEditMode) {
    ColorMaskViewEditModeUnknown,
    ColorMaskViewEditModeAdd,
    ColorMaskViewEditModeChangePosition,
    ColorMaskViewEditModeResizing,
    ColorMaskViewEditModeDone
};

@protocol ColorMaskViewModelDelegate <NSObject>
@optional
- (void)createNewColorMaskViewCompletion;
@end


@interface ColorMaskViewModel : NSObject <ColorMaskViewRecordProtocol>

@property (weak, nonatomic) id <ColorMaskViewModelDelegate> delegate;
@property (nonatomic) ColorMaskViewEditMode colorMaskViewEditMode;
@property (strong, nonatomic) NSArray<ColorMask *> *colorMaskList;
@property (strong, nonatomic, readonly) UIView *colorView;


- (instancetype)initWithColorView:(UIView *)colorView;

- (void)colorViewTouchesBegan:(CGPoint)touchPoint;
- (void)colorViewTouchesMoved:(CGPoint)touchPoint;
- (void)colorViewTouchesEnded:(CGPoint)touchPoint;

- (void)selectColorMaskByIndex:(NSUInteger)index;
- (void)removeColorMaskByIndex:(NSUInteger)index;

@end

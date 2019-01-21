//
//  ColorMaskViewModel.m
//  MaskDrawing
//
//  Created by Vincent Cheng on 2018/1/12.
//  Copyright © 2018年 Vincent Cheng. All rights reserved.
//

#import "ColorMaskViewModel.h"

#define COLOR_MASKS @"color masks"

@interface ColorMaskViewModel ()
{
    ColorMask *_selectedColorMask;
    CGPoint _maskImageAnchorPoint;
    BOOL _isSelectedMaskImageInResizingMode;
    
    NSMutableArray<ColorMask *> *_colorMasks;
}

@property (strong, nonatomic, readwrite) UIView *colorView;

@end

@implementation ColorMaskViewModel

- (instancetype)initWithColorView:(UIView *)colorView {
    self = [super init];
    if (self) {
        self.colorView = colorView;
        _selectedColorMask = [ColorMask new];
        _colorMasks = [self loadColorMasks];
        for (ColorMask *mask in _colorMasks) {
            [_colorView addSubview:mask.rectangleView];
        }
        self.colorMaskList = [NSArray arrayWithArray:_colorMasks];
    }
    
    return self;
}

#pragma mark - Touch methods

- (void)colorViewTouchesBegan:(CGPoint)touchPoint {
    switch (_colorMaskViewEditMode) {
        case ColorMaskViewEditModeAdd:
        {
            _maskImageAnchorPoint = touchPoint;
            _selectedColorMask = [ColorMask new];
            [_colorView addSubview:_selectedColorMask.rectangleView];
            break;
        }
        case ColorMaskViewEditModeResizing:
        {
            int nearstVertexIndex = [self findNearestVertexIndexInMaskImageVertices:_selectedColorMask.vertices inputPoint:touchPoint];
            if (nearstVertexIndex < 0) {
                _isSelectedMaskImageInResizingMode = NO;
            } else {
                _maskImageAnchorPoint = [self getNewMaskImageAnchorPoint:_selectedColorMask.vertices fromNearstVertexIndex:nearstVertexIndex];
                _isSelectedMaskImageInResizingMode = YES;
            }
            break;
        }
        default:
            break;
    }
}

- (void)colorViewTouchesMoved:(CGPoint)touchPoint {
    switch (_colorMaskViewEditMode) {
        case ColorMaskViewEditModeAdd:
        {
            [self ceateMaskImageViewSize:touchPoint];
            break;
        }
        case ColorMaskViewEditModeChangePosition:
        {
            [self moveMaskImageToPosition:touchPoint];
            break;
        }
        case ColorMaskViewEditModeResizing:
        {
            if (!_isSelectedMaskImageInResizingMode) {
                return;
            }
            [self ceateMaskImageViewSize:touchPoint];
            break;
        }
        default:
            break;
    }
}

- (void)colorViewTouchesEnded:(CGPoint)touchPoint {
    switch (_colorMaskViewEditMode) {
        case ColorMaskViewEditModeAdd:
        {
            self.colorMaskViewEditMode = ColorMaskViewEditModeChangePosition;
            _selectedColorMask.vertices = [self getAllVerticesFromView:_selectedColorMask.rectangleView];
            [_colorMasks addObject:_selectedColorMask];
            self.colorMaskList = [NSArray arrayWithArray:_colorMasks];
            [self saveColorMasks:_colorMasks];
            if ([_delegate respondsToSelector:@selector(createNewColorMaskViewCompletion)]) {
                [_delegate createNewColorMaskViewCompletion];
            }
            break;
        }
        case ColorMaskViewEditModeChangePosition:
            _selectedColorMask.vertices = [self getAllVerticesFromView:_selectedColorMask.rectangleView];
            self.colorMaskList = [NSArray arrayWithArray:_colorMasks];
            [self saveColorMasks:_colorMasks];
            break;
        case ColorMaskViewEditModeResizing:
            if (!_isSelectedMaskImageInResizingMode) {
                return;
            }
            _selectedColorMask.vertices = [self getAllVerticesFromView:_selectedColorMask.rectangleView];
            self.colorMaskList = [NSArray arrayWithArray:_colorMasks];
            [self saveColorMasks:_colorMasks];
            break;
        default:
            break;
    }
}

#pragma mark - Selection methods

- (void)selectColorMaskByIndex:(NSUInteger)index {
    _selectedColorMask = _colorMasks[index];
    self.colorMaskViewEditMode = ColorMaskViewEditModeChangePosition;
    [_colorView bringSubviewToFront:_selectedColorMask.rectangleView];
}

- (void)removeColorMaskByIndex:(NSUInteger)index {
    [_colorMasks[index].rectangleView removeFromSuperview];
    [_colorMasks removeObjectAtIndex:index];
    self.colorMaskList = [NSArray arrayWithArray:_colorMasks];
    [self saveColorMasks:_colorMasks];
}

#pragma mark - Edit Color mask view methods

- (void)moveMaskImageToPosition:(CGPoint)touchPoint {
    NSLog(@"x:%f, y:%f",touchPoint.x, touchPoint.y);
    
    _selectedColorMask.rectangleView.center = [self getConvertPointToMakeChildView:_selectedColorMask.rectangleView inParentView:_colorView centerTouch:touchPoint];
}

- (void)ceateMaskImageViewSize:(CGPoint)touchPoint {
    CGPoint inBoundPoint = [self getConvertPointToMakeVertexTouch:touchPoint inView:_colorView];
    CGFloat width = fabs(inBoundPoint.x - _maskImageAnchorPoint.x);
    CGFloat height = fabs(inBoundPoint.y - _maskImageAnchorPoint.y);
    _selectedColorMask.rectangleView.image = [self drawMaskWithWidh:width Height:height];
    _selectedColorMask.rectangleView.frame = [self getMaskImageRectFrom:_maskImageAnchorPoint to:inBoundPoint width:width height:height];
}

#pragma mark - Private methods

- (UIImage *)drawMaskWithWidh:(CGFloat)width Height:(CGFloat)height {
    width = width < 2 ? 2 : width;
    height = height < 2 ? 2 : height;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 255, 0, 255, 0.5);
    CGContextFillRect(context, CGRectMake(1, 1, width - 2, height - 2));
    
    CGContextSetLineWidth(context, 1);
    CGContextSetRGBStrokeColor(context, 255, 255, 0, 1);
    CGContextAddRect(context, CGRectMake(1, 1, width - 2, height - 2));
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGPoint)getConvertPointToMakeChildView:(UIView *)childView inParentView:(UIView *)parentView centerTouch:(CGPoint)touchPoint {
    CGFloat minLeftPosition = childView.frame.size.width * 0.5;
    CGFloat minTopPosition = childView.frame.size.height * 0.5;
    CGFloat maxRightPosition = parentView.frame.size.width - childView.frame.size.width * 0.5;
    CGFloat maxBottomPosition = parentView.frame.size.height - childView.frame.size.height * 0.5;
    
    CGFloat realX = touchPoint.x < minLeftPosition ? minLeftPosition : (touchPoint.x > maxRightPosition ? maxRightPosition : touchPoint.x);
    CGFloat realY = touchPoint.y < minTopPosition ? minTopPosition : (touchPoint.y > maxBottomPosition ? maxBottomPosition : touchPoint.y);
    
    return CGPointMake(realX, realY);
}

- (CGPoint)getConvertPointToMakeVertexTouch:(CGPoint)touchPoint inView:(UIView *)view {
    CGFloat realX = touchPoint.x < 0 ? 0 : (touchPoint.x > view.frame.size.width ? view.frame.size.width : touchPoint.x);
    CGFloat realY = touchPoint.y < 0 ? 0 : (touchPoint.y > view.frame.size.height ? view.frame.size.height : touchPoint.y);
    
    return CGPointMake(realX, realY);
}

- (CGRect)getMaskImageRectFrom:(CGPoint)startPoint to:(CGPoint)endPoint width:(CGFloat)width height:(CGFloat)height {
    CGRect aRect = CGRectZero;
    if (endPoint.x >= startPoint.x && endPoint.y >= startPoint.y) {
        aRect = CGRectMake(startPoint.x, startPoint.y, width, height);
    } else if (endPoint.x >= startPoint.x && endPoint.y < startPoint.y) {
        aRect = CGRectMake(startPoint.x, startPoint.y - height, width, height);
    } else if (endPoint.x < startPoint.x && endPoint.y >= startPoint.y) {
        aRect = CGRectMake(startPoint.x - width, startPoint.y, width, height);
    } else {
        aRect = CGRectMake(startPoint.x - width, startPoint.y - height, width, height);
    }
    
    return aRect;
}

- (NSArray *)getAllVerticesFromView:(UIView *)view {
    CGPoint leftTopPoint = CGPointMake(view.frame.origin.x, view.frame.origin.y);
    CGPoint rightTopPoint = CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y);
    CGPoint leftBottomPoint = CGPointMake(view.frame.origin.x, view.frame.origin.y + view.frame.size.height);
    CGPoint rightBottomPoint = CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y + view.frame.size.height);
    return @[@(leftTopPoint), @(rightTopPoint), @(leftBottomPoint), @(rightBottomPoint)];
}

- (int)findNearestVertexIndexInMaskImageVertices:(NSArray *)maskImageVertices inputPoint:(CGPoint)inputPoint {
    int index = 0;
    for (NSValue *value in maskImageVertices) {
        CGPoint p = [value CGPointValue];
        if (fabs(p.x - inputPoint.x) <= 20 && fabs(p.y - inputPoint.y) <= 20) {
            return index;
        }
        index++;
    }
    
    return -1;
}

- (CGPoint)getNewMaskImageAnchorPoint:(NSArray *)maskImageVertices fromNearstVertexIndex:(int)index {
    int anchorIndex = (int)(maskImageVertices.count - 1) - index;
    return [maskImageVertices[anchorIndex] CGPointValue];
}

#pragma mark - ColorMaskViewRecordProtocol methods

- (void)saveColorMasks:(NSMutableArray<ColorMask *> *)colorMasks {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:colorMasks] forKey:COLOR_MASKS];
    [userDefaults synchronize];
}

- (NSMutableArray<ColorMask *> *)loadColorMasks {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray<ColorMask *> *masks = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:COLOR_MASKS]];
    if (masks) {
        return masks;
    }
    return [NSMutableArray new];
}

@end

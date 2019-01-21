//
//  ColorMask.m
//  MaskDrawing
//
//  Created by Vincent Cheng on 2018/1/12.
//  Copyright © 2018年 Vincent Cheng. All rights reserved.
//

#import "ColorMask.h"

@implementation ColorMask

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rectangleView = [UIImageView new];
        self.vertices = [NSArray new];
        self.name = [NSString new];
    }
    
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_rectangleView forKey:@"rectangleView"];
    [aCoder encodeObject:_vertices forKey:@"vertices"];
    [aCoder encodeObject:_name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.rectangleView = [aDecoder decodeObjectForKey:@"rectangleView"];
        self.vertices = [aDecoder decodeObjectForKey:@"vertices"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end

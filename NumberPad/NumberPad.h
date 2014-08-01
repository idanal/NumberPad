//
//  NumberPad.h
//  Caipiao
//
//  Created by danal on 8/1/14.
//  Copyright (c) 2014 yz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NumberPad : UIView {
    CGSize      _gridSize;
    CGFloat     _tick;
}
+ (instancetype)instance;

- (void)setReturnKey:(NSString *)key;
@end


@interface NumberPadGrid : UIView {
    UIImageView *_imageView;
}
@property (nonatomic, assign) UILabel *numberLabel;
@property (nonatomic, assign) UILabel *textLabel;
@property (nonatomic, strong) UIImage *image;       //Icon image if has
@property (nonatomic)   BOOL centerAlignment;       //Number or icon image will align center
@property (nonatomic)   BOOL reverseState;          //Reverse the color of active state
@property (nonatomic)   BOOL isBackspace;
@property (nonatomic)   BOOL isReturn;
@property (nonatomic)   BOOL active;


@end

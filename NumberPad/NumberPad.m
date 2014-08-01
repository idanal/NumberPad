//
//  NumberPad.m
//  Caipiao
//
//  Created by danal on 8/1/14.
//  Copyright (c) 2014 yz. All rights reserved.
//

#import "NumberPad.h"

#if __has_feature(objc_arc)
#error Error: Add -fno-objc-arc to Compiler Flags in the Build phases
#endif


@interface NumberPad ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NumberPadGrid *returnGrid;
@end

@implementation NumberPad

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        _gridSize = CGSizeMake((frame.size.width)/3, (frame.size.height)/4);
        NSArray *numbers = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"Return",@"0",@"←"];
        NSArray *texts = @[@"",@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"PQRS",@"TUV",@"WXYZ",@"",@"",@""];
        
        NSInteger row,col;
        for (NSInteger i = 0; i < numbers.count; i++) {
            row = i/3, col = i%3;
            NumberPadGrid *grid = [[NumberPadGrid alloc] initWithFrame:
                                   CGRectMake(col*_gridSize.width, row*_gridSize.height, _gridSize.width, _gridSize.height)];
            grid.numberLabel.text = numbers[i];
            grid.textLabel.text = texts[i];
            if ([numbers[i] integerValue] == 0){    //0,text,and icons should align center
                grid.centerAlignment = YES;
            }
            if (i == 9) {   //Return
                grid.reverseState = YES;
                grid.isReturn = YES;
                grid.numberLabel.font = [UIFont systemFontOfSize:18.f];
                self.returnGrid = grid;
            }
            if (i == 11) {  //Backspace
                grid.reverseState = YES;
                grid.isBackspace = YES;
                grid.image = [UIImage imageNamed:@"NumberPad-back"];
            }
            grid.active = NO;
            [self addSubview:grid];
            [grid release];
        }
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing grids, 3 cols and 4 rows
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    CGContextSetLineWidth(c, 0.5);
    CGContextSetAllowsAntialiasing(c, false);
    CGContextSetShouldAntialias(c, false);
    
    [[UIColor colorWithRed:185/255.f green:188/255.f blue:193/255.f alpha:1.f] set];
    for (NSInteger col = 1; col < 3; col++) {
        CGContextMoveToPoint(c, _gridSize.width*col, 0);
        CGContextAddLineToPoint(c, _gridSize.width*col, rect.size.height);
    }
    for (NSInteger row = 1; row < 4; row++) {
        CGContextMoveToPoint(c, 0, _gridSize.height*row);
        CGContextAddLineToPoint(c, rect.size.width, _gridSize.height*row);
    }
    CGContextStrokePath(c);
    CGContextRestoreGState(c);
}

- (void)setReturnKey:(NSString *)key{
    _returnGrid.numberLabel.text = key;
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    for (NumberPadGrid *v in self.subviews){
        v.active = CGRectContainsPoint(v.frame, p);
    }
    _tick = 0.f;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    for (NumberPadGrid *v in self.subviews){
        v.active = CGRectContainsPoint(v.frame, p);
    }
    _tick = 0.f;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //Find the textfield
    UITextField *textField = (id)self.nextResponder;
    
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    for (NumberPadGrid *v in self.subviews){
        v.active = NO;
        if (CGRectContainsPoint(v.frame, p)){
            if (v.isReturn){
                [textField.delegate textFieldShouldReturn:textField];
            }
            else if (v.isBackspace){
                if ([textField.text length] > 0){
                    if (textField.delegate && [textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]){
                        BOOL b = [textField.delegate textField:textField shouldChangeCharactersInRange:NSMakeRange(textField.text.length-1, -1) replacementString:nil];
                        if (b){
                            textField.text = [textField.text substringToIndex:textField.text.length - 1];
                        }
                    } else {
                        textField.text = [textField.text substringToIndex:textField.text.length - 1];
                    }
                }
            }
            else {  //Number
                if (textField.delegate && [textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]){
                    BOOL b = [textField.delegate textField:textField shouldChangeCharactersInRange:NSMakeRange(textField.text.length-1, 1) replacementString:v.numberLabel.text];
                    if (b){
                        textField.text = [textField.text stringByAppendingString:v.numberLabel.text];
                    }
                    
                } else {
                    textField.text = [textField.text stringByAppendingString:v.numberLabel.text];
                }
            }
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    for (NumberPadGrid *v in self.subviews){
        v.active = NO;
    }
}

+ (instancetype)instance{
    NumberPad *__npad = nil;
    if (!__npad){
        __npad = [[[self alloc] initWithFrame:CGRectMake(0, 0, 320, 216)] autorelease];
    }
    [__npad setReturnKey:NSLocalizedString(@"Done", nil)];
    
    return __npad;
}

@end


@implementation NumberPadGrid

- (void)dealloc{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        CGFloat marY = 6.f;
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, marY, frame.size.width, frame.size.height/3*2 - marY)];
        _numberLabel.adjustsFontSizeToFitWidth = NO;
        _numberLabel.font = [UIFont systemFontOfSize:26.f];
        [self addSubview:_numberLabel];
        [_numberLabel release];
        
        _textLabel = [[UILabel alloc] initWithFrame:
                      CGRectMake(0, _numberLabel.frame.origin.y + _numberLabel.frame.size.height, frame.size.width, frame.size.height/3*1-marY)];
        _textLabel.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:_textLabel];
        [_textLabel release];
        
        _numberLabel.textAlignment = _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    if (!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];
    }
    _numberLabel.hidden = _textLabel.hidden = YES;
    _imageView.image = image;
}

- (void)setCenterAlignment:(BOOL)centerAlignment{
    _centerAlignment = centerAlignment;
    _numberLabel.frame = self.bounds;
}

- (void)setActive:(BOOL)active{
    _active = active;
    if (_reverseState){
        self.backgroundColor = !active ? [UIColor colorWithRed:185/255.f green:188/255.f blue:193/255.f alpha:.8f] : [UIColor clearColor];
    } else {
        self.backgroundColor = active ? [UIColor colorWithRed:185/255.f green:188/255.f blue:193/255.f alpha:.8f] : [UIColor clearColor];
    }
}

@end
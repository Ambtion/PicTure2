//
//  ImageQualitySwitch.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-29.
//
//

#import "CusSwitch.h"
#import "LoginStateManager.h"
#import "PerfrenceSettingManager.h"


@implementation CusSwitch
@synthesize isTure = _isTure;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame IconImage:(UIImage *)Aimage TureImage:(UIImage *)AtureImage falueimage:(UIImage *)AfalueImage
{
    if (self = [super initWithFrame:frame]) {
        tureImage = AtureImage;
        falueImage = AfalueImage;
        [self setSubViews];
        [_button setImage:Aimage forState:UIControlStateNormal];
    }
    return self;
}
- (void)setSubViews
{
    [self setUserInteractionEnabled:YES];
    self.backgroundColor = [UIColor clearColor];
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    UISwipeGestureRecognizer * gesutre = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDrag:)];
    gesutre.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [_button addGestureRecognizer:gesutre];
    [_button addTarget:self action:@selector(buttonDrag:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDrag:)];
    [self addGestureRecognizer:tap];
    [self addSubview:_button];    
    [self setIsTure:NO];
    [self setbuttinImage];
}
- (void)setIsTure:(BOOL)isTure
{
    if (!isTure) {
        _button.frame = (CGRect) {0, 0,self.frame.size.height, self.frame.size.height};
    }else{
        _button.frame = (CGRect) {self.frame.size.width - self.frame.size.height,0, self.frame.size.height, self.frame.size.height};
    }
    _isTure = isTure;
    [self setbuttinImage];
}
-(void)setbuttinImage
{
    if (_isTure) {
        self.image = tureImage;
    }else {
        self.image = falueImage;
    }
    if ([_delegate respondsToSelector:@selector(cusSwitchValueChange:)])
        [_delegate cusSwitchValueChange:self];
}
-(void)buttonDrag:(UISwipeGestureRecognizer *)gesture
{
    _isTure = !_isTure;
    UIViewAnimationOptions  options = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:0.2 delay:0 options:options animations:^{
        if (!_isTure) {
            _button.frame = (CGRect) {0, 0, self.frame.size.height, self.frame.size.height};
        }else {
            _button.frame = (CGRect) {self.frame.size.width - self.frame.size.height,0, self.frame.size.height, self.frame.size.height};
        }
    } completion:^(BOOL finished) {
        [self setbuttinImage];
    }];
}

@end

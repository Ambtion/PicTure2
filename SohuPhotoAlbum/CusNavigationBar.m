//
//  CusNavigationBar.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CusNavigationBar.h"


@interface CusNavigationBar()


@end
@implementation CusNavigationBar
@synthesize leftButton,labelImage,labelText,rightButton1,rightButton2,rightButton3;
- (void)dealloc
{
    [leftButton release];
    [labelImage release];
    [labelText release];
    [rightButton1 release];
    [rightButton2 release];
    [rightButton3 release];
    [super dealloc];
}
- (id)initwithDelegate:(id<CusNavigationBarDelegate>)Adelegate
{
    self.delegate = Adelegate;
    return [self initWithFrame:CGRectMake(0, 0, 320, 44)];
}
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        self.image = [UIImage imageNamed:@"title-bar.png"];
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 44, 44);
        leftButton.tag = LEFTBUTTON;
        [self.leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        self.labelImage = [[[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 90, 44)] autorelease];
        [self addSubview:labelImage];
        self.labelText = [[[UILabel alloc] initWithFrame:CGRectMake(50, 0, 90, 44)] autorelease];
        self.labelText.backgroundColor = [UIColor clearColor];
        [self addSubview:labelText];
        
        [self addRightButtons];
    }
    return self;
}
- (void)addRightButtons
{
    self.rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    rightButton1.frame = CGRectMake(320 - 50, 0, 44, 44);
    rightButton1.tag = RIGHT1BUTTON;
    [self addSubview:rightButton1];
    
    self.rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    rightButton2.frame = CGRectMake(320 - 100, 0, 44, 44);
    rightButton2.tag = RIGHT2BUTTON;
    [self addSubview:rightButton2];
    
    self.rightButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    rightButton3.frame = CGRectMake(320 - 150, 0, 44, 44);
    rightButton3.tag = RIGHT3BUTTON;
    [self addSubview:rightButton3];
}

- (void)buttonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(cusNavigationBar:buttonClick:)]) {
        [_delegate cusNavigationBar:self buttonClick:button];
    }
}
@end

//
//  shareBox.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-20.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "ShareBox.h"
#import "AppDelegate.h"

@implementation ShareBox
@synthesize delegate = _delegate;

#pragma mark Share
- (void)showShareViewWithWeixinShow:(BOOL)showWeiXin photoWall:(BOOL)showWall andWriteImage:(BOOL)isShowWrite OnView:(UIView *)view
{
    showView = view;
    isShowWeixin = showWeiXin;
    isShowWall = showWall;
    SHActionSheet * sheet = [[SHActionSheet alloc] init];
    sheet.delegate = self;
    if (isShowWall) {
        [sheet addButtonWithTitle:@"图片墙"];
    }
    [sheet addButtonWithTitle:@"新浪微博"];
    [sheet addButtonWithTitle:@"人人网"];
    [sheet addButtonWithTitle:@"腾讯QQ空间"];
    if (isShowWeixin) {
        [sheet addButtonWithTitle:@"微信"];
    }
   
    //    if (isShowWrite) {
    //        [sheet addButtonWithTitle:@"保存到本地"];
    //    }
    [sheet addButtonWithTitle:@"取消"];
    [sheet showInView:showView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (weixinAtion == actionSheet) {
        switch (buttonIndex) {
            case 0:
                if ([_delegate respondsToSelector:@selector(shareBoxViewWeiXinShareToScene:)])
                    [_delegate shareBoxViewWeiXinShareToScene:WXSceneTimeline];
                break;
            case 1:
                if ([_delegate respondsToSelector:@selector(shareBoxViewWeiXinShareToScene:)])
                    [_delegate shareBoxViewWeiXinShareToScene:WXSceneSession];
                break;
            default:
                break;
        }
        return;
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] hasPrefix:@"新浪"]) {
        model = SinaWeiboShare;
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] hasPrefix:@"人人"]) {
        model = RenrenShare;
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] hasPrefix:@"腾讯"]) {
        model = QQShare;
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"微信"]) {
        model = WeixinShare;
        [[self Appdelegate] weiXinregisterWithDelegate:_delegate];
        [self weixinUploadPic];
        return;
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"图片墙"]) {
        model = SohuShare;
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"保存到本地"]) {
        if ([_delegate respondsToSelector:@selector(shareBoxViewWriteImageTolocal)]) {
            [_delegate shareBoxViewWriteImageTolocal];
            return;
        }
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"取消"]) {
        return;
    }
    [self bindToModel];
}
- (void)bindToModel
{
    switch (model) {
        case SinaWeiboShare:
            if (![LoginStateManager isSinaBind]) {
                [(UIViewController *)_delegate showBingViewWithShareModel:SinaWeiboShare delegate:self andShowWithNav:NO];
                return;
            }
            break;
        case QQShare:
            if (![LoginStateManager isQQBing]) {
                [(UIViewController *)_delegate showBingViewWithShareModel:QQShare delegate:self andShowWithNav:NO];
                return;
            }
            break;
        case RenrenShare:
            if (![LoginStateManager isRenrenBind]) {
                [(UIViewController *)_delegate showBingViewWithShareModel:RenrenShare delegate:self andShowWithNav:NO];
                return;
            }
            break;
        default:
            break;
    }
    if ([_delegate respondsToSelector:@selector(shareBoxViewShareTo:)])
        [_delegate shareBoxViewShareTo:model];
}

- (void)oauthorController:(OAuthorController *)controller bingSucessInfo:(NSDictionary *)dic
{
    [self bindToModel];
}

#pragma mark Action
- (AppDelegate *)Appdelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)weixinUploadPic
{
    if ([WXApi isWXAppInstalled]) {
        weixinAtion = [[SHActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"朋友圈",@"会话", nil];
        [weixinAtion showInView:showView];
    }else{
        [self showInvalidTokenOrOpenIDMessageWithMes:@"请确认已安装微信"];
    }
}

- (void)showInvalidTokenOrOpenIDMessageWithMes:(NSString *)Amessage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:Amessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [self laySubViews:actionSheet];
}

- (void)laySubViews:(UIActionSheet *)sheet
{
    UIImage *theImage = [UIImage imageNamed:@"actionSheet_BgView"];
    theImage = [theImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:theImage];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.frame = CGRectMake(0, -20, sheet.frame.size.width, sheet.frame.size.height + 20);
    [sheet addSubview:imageView];
    
    for (UIView * view in sheet.subviews)
    {
        if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
            UIButton * button  = (UIButton *)view;
            if (![[[button titleLabel] text] isEqualToString:@"取消"]){
                UIView * bgView = [sheet viewWithTag:10000];
                if (!bgView) {
                    bgView = [[UIView alloc] initWithFrame:CGRectMake(21, 11, 278, 0)];
                    bgView.backgroundColor = [UIColor whiteColor];
                    bgView.tag = 10000;
                    [sheet insertSubview:bgView aboveSubview:imageView];
                }
                //其他按钮
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                button.contentEdgeInsets = UIEdgeInsetsMake(0, 67, 0, 0);
                [button setTitleColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1] forState:UIControlStateHighlighted];
                button.frame = CGRectMake(button.frame.origin.x, view.frame.origin.y - 10, button.frame.size.width, button.frame.size.height + 6);
                [self setButtonImage:button];
                CGRect rect = bgView.frame;
                rect.size.height = button.frame.size.height + button.frame.origin.y - rect.origin.y;
                bgView.frame = rect;
            }else{
                //取消按钮
                [button setBackgroundImage:[UIImage imageNamed:@"button_gray_normal.png"]  forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"button_gray_press.png"]  forState:UIControlStateHighlighted];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width, button.frame.size.height + 6);
                [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
                [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
                UIView * bgView = [button.superview viewWithTag:10000];
                [button.superview insertSubview:button aboveSubview:bgView];
            }
        }
    }
}

- (void)setButtonImage:(UIButton *)button
{
    UIView * bgView = [button.superview viewWithTag:10000];
    [button setBackgroundImage:[self getNormalImage:button] forState:UIControlStateNormal];
    [button setBackgroundImage:[self getPressImage:button] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fengxiang-line.png"]];
    line.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y+button.frame.size.height, button.frame.size.width, 1);
    [button.superview addSubview:line];
    [button.superview insertSubview:button aboveSubview:bgView];
}
- (UIImage*)getNormalImage:(UIButton *)button
{
    NSString * str = button.titleLabel.text;
    if ([str hasPrefix:@"图片墙"]) {
        return [UIImage imageNamed:@"fenxiang-tupianqiang-normal.png"];
    }
    if ([str hasPrefix:@"新浪"]) {
        return [UIImage imageNamed:@"fenxiang-xinlang-normal.png"];
    }
    if ([str hasPrefix:@"微信"]) {
        return [UIImage imageNamed:@"fengxiang-weixin-normal.png"];
    }
    if ([str hasPrefix:@"人人"]) {
        return [UIImage imageNamed:@"fenxiang-renren-normal.png"];
    }
    if ([str hasPrefix:@"腾讯"]) {
        return [UIImage imageNamed:@"fenxiang-QQ-normal.png"];
    }
    if ([str hasPrefix:@"朋友圈"]) {
        return [UIImage imageNamed:@"fenxiang-pengyouquan-normal.png"];
    }
    if ([str hasPrefix:@"会话"]) {
        return [UIImage imageNamed:@"fenxiang-huihua-normal.png"];
    }
    return nil;
}
- (UIImage*)getPressImage:(UIButton *)button
{
    NSString * str = button.titleLabel.text;
    if ([str hasPrefix:@"图片墙"]) {
        return [UIImage imageNamed:@"fenxiang-tupianqiang-press.png"];
    }
    if ([str hasPrefix:@"新浪"]) {
        return [UIImage imageNamed:@"fenxiang-xinlang-press.png"];
    }
    if ([str hasPrefix:@"微信"]) {
        return [UIImage imageNamed:@"fengxiang-weixin-press.png"];
    }
    if ([str hasPrefix:@"人人"]) {
        return [UIImage imageNamed:@"fenxiang-renren-press.png"];
    }
    if ([str hasPrefix:@"腾讯"]) {
        return [UIImage imageNamed:@"fenxiang-QQ-press.png"];
    }
    if ([str hasPrefix:@"朋友圈"]) {
        return [UIImage imageNamed:@"fenxiang-pengyouquan-press.png"];
    }
    if ([str hasPrefix:@"会话"]) {
        return [UIImage imageNamed:@"fenxiang-huihua-press.png"];
    }
    return nil;
}
@end

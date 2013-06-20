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
    //    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    sheet.delegate = self;
    [sheet addButtonWithTitle:@"新浪微博"];
    [sheet addButtonWithTitle:@"人人网"];
    [sheet addButtonWithTitle:@"腾讯QQ空间"];
    sheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    if (isShowWeixin) {
        [sheet addButtonWithTitle:@"微信"];
    }
    if (isShowWall) {
        [sheet addButtonWithTitle:@"图片墙"];
    }
    if (isShowWrite) {
        [sheet addButtonWithTitle:@"保存到本地"];
    }
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
    switch (buttonIndex) {
        case 0:
            model = SinaWeiboShare;
            break;
        case 1:
            model = RenrenShare;
            break;
        case 2:
            model = QQShare;
            break;
        default:
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
            break;
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
        weixinAtion = [[SHActionSheet alloc] initWithTitle:@"发送到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"朋友圈",@"会话", nil];
        [weixinAtion showInView:showView];
    }else{
        [self showInvalidTokenOrOpenIDMessageWithMes:@"请确认安装微信"];
    }
}

- (void)showInvalidTokenOrOpenIDMessageWithMes:(NSString *)Amessage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:Amessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    CGSize theSize = actionSheet.frame.size;
    // draw the background image and replace layer content
    UIGraphicsBeginImageContext(theSize);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, theSize.width, theSize.height));
    UIImage *  theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[actionSheet layer] setContents:(id)theImage.CGImage];
}

@end

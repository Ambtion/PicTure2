//
//  CloudAlbumDetailController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-19.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CloundAlbumDetailController.h"

@implementation CloundAlbumDetailController
- (void)getMoreAssetsAfterCurNum
{
    
}
- (void)getMoreAssetsBeforeCurNum
{
    
}

- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(NSDictionary *)asset folderId:(NSString *)folderID
{
    self = [super initWithAssetsArray:array andCurAsset:asset];
    if (self) {
        _folderId = folderID;
    }
    return self;
}

//重载删除函数..调用的删除接口不同
- (void)popAlertView:(PopAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString * photoId = [NSString stringWithFormat:@"%@",[[self.assetsArray objectAtIndex:self.curPageNum] objectForKey:@"id"]];
        [RequestManager deleteFoldersPhotosWithAccessToken:[LoginStateManager currentToken] folderId:_folderId photos:[NSArray arrayWithObject:photoId] success:^(NSString *response) {
            [self.assetsArray removeObject:[self.assetsArray objectAtIndex:self.curPageNum]];
            if (self.assetsArray.count) {
                [self refreshScrollView];
            }else{
                self.isPushView = YES;
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self showPopAlerViewRatherThentasView:NO WithMes:@"删除成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:DELETEPHOTO object:nil];
        } failure:^(NSString *error) {
            [self showPopAlerViewRatherThentasView:NO WithMes:@"删除失败"];
        }];
    }
}
@end

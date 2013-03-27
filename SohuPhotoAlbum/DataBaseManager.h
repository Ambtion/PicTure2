//
//  DataBaseManager.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBaseManager : NSObject
{
    sqlite3 * _dataBase;
}
@property(nonatomic,assign)sqlite3 * dataBase;

+ (DataBaseManager *)defaultDataBaseManager;

- (BOOL)insertPhotoURLIntoTable:(NSString *)photoURL;   //插入数据
- (BOOL)deletePhotoURLFromTable:(NSString *)photoURL;   //删除数据
- (BOOL)canSelectedPhotoURL:(NSString *)photoURL;         //查找数据
@end

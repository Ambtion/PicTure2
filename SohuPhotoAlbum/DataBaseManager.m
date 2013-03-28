//
//  DataBaseManager.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "DataBaseManager.h"

#define DATABASENAME @"SQLITES.sqlite3"
#define TABLENAME @"UploadphotoURL"

static DataBaseManager * defaultDataBaseManager = nil;
@implementation DataBaseManager
@synthesize dataBase = _dataBase;


+ (DataBaseManager *)defaultDataBaseManager
{
    if (!defaultDataBaseManager) {
        @synchronized(self){
            defaultDataBaseManager = [[self alloc] init];
        }
    }
    return defaultDataBaseManager;
}


#pragma mark init -
- (id)init
{
    NSLog(@"%s",__FUNCTION__);
    self = [super init];
    if (self) {
        [self initDataBase];
        [self createTable];
    }
    return self;
}
- (NSString *)dataBasePath
{
    //获取数据库存储路径
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [path stringByAppendingPathComponent:DATABASENAME];
}
- (void)initDataBase
{
    //初始化数据库,打开数据库,若无,创建数据库
    NSString * name = [self dataBasePath];
    
    if (sqlite3_open([name UTF8String], &_dataBase) !=SQLITE_OK) {
        NSLog(@"error to init sqlite");
        _dataBase = NULL;
    }
}
- (void)createTable
{
    //创建表photoUploadInfo, id  photoURL
    NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@"
                      "(ID INTEGER PRIMARY KEY AUTOINCREMENT,PhotoURL TEXT)",TABLENAME];
    char *errsql = NULL;
    if (sqlite3_exec(_dataBase, [sql UTF8String], NULL, NULL, &errsql)!= SQLITE_OK) {
        NSLog(@"error to exec %s", errsql);
        free(errsql);
    }
}

#pragma - close
- (void)dealloc
{
    [self closedatebase];
    [super dealloc];
}
-(void)closedatebase
{
    if (_dataBase) {
        sqlite3_close(_dataBase);
    }
}

#pragma mark - action
- (BOOL)insertPhotoURLIntoTable:(NSURL *)photoURL
{
    NSString * photoURLS = [photoURL absoluteString];
    NSString* insertSql = [NSString stringWithFormat:
                           @"INSERT INTO %@(PhotoURL) VALUES('%@')",
                           TABLENAME,photoURLS];
    char * error = NULL;
    if (sqlite3_exec(_dataBase, [insertSql UTF8String], NULL, NULL, &error)!= SQLITE_OK) {
        NSLog(@"insert error::%s", error);
        free(error);
        return NO;
    }
    return YES;
}

- (BOOL)deletePhotoURLFromTable:(NSURL *)photoURL
{
    NSString * photoURLS = [photoURL absoluteString];
    NSString * deletaSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE PhotoURL = '%@'",TABLENAME,photoURLS];
    
    char* error = NULL;
    if (sqlite3_exec(_dataBase, [deletaSql UTF8String], NULL, NULL, &error)!=SQLITE_OK) {
        NSLog(@"delete error:%s",error);
        free(error);
        return NO;
    }
    return YES;
}

- (BOOL)hasPhotoURL:(NSURL *)photoURL
{
    NSString * photoURLS = [photoURL absoluteString];
    int count = 0;
    NSString * selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE PhotoURL = '%@'",TABLENAME,photoURLS];
    sqlite3_stmt * statment = NULL;
    if (sqlite3_prepare_v2(_dataBase, [selectSql UTF8String], -1, &statment, NULL) == SQLITE_OK) {
//        NSLog(@"%s",__FUNCTION__);
        while (sqlite3_step(statment) == SQLITE_ROW) {
            count++;
        }
    }
    return count != 0;
}

@end

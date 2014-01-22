//
//  ResturantManager.m
//  MyGourmet
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ResturantManager.h"

@implementation ResturantManager{
    sqlite3 *db;
    NSMutableArray *_ResturantList;
}

static ResturantManager *_instance = nil;


+ (id)sharedResturantManager{
    if (nil == _instance) {
        _instance = [[ResturantManager alloc] init];
        [_instance openDB];
    }
    return _instance;
}
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)openDB {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbFilePath = [docPath stringByAppendingPathComponent:@"db.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existFile = [fileManager fileExistsAtPath:dbFilePath];
    
    int ret = sqlite3_open([dbFilePath UTF8String], &db);
    
    if (SQLITE_OK != ret) {
        return NO;
    }
    
    if (existFile == NO) {
        //CREATE  TABLE  IF NOT EXISTS "main"."RESTURANT" ("Name" VARCHAR, "Tag" VARCHAR, "Detail" VARCHAR, "LocationName" VARCHAR, "lon" FLOAT, "lat" FLOAT)
        char *creatSQL = "CREATE  TABLE  IF NOT EXISTS RESTURANT (Name TEXT, Tag TEXT, Detail TEXT, LocationName TEXT, lon FLOAT, lat FLOAT, insetIndex INTEGER)";
        char *errorMsg;
        ret = sqlite3_exec(db, creatSQL, NULL, NULL, &errorMsg);
        if (SQLITE_OK != ret) {
            [fileManager removeItemAtPath:dbFilePath error:nil];
            NSLog(@"creating table with ret : %d", ret);
            return NO;
        }
    }
    return YES;
}
//맛집을 디비에 추가
- (void)addRestruantWithResturant:(Resturant *)resturant {
    NSInteger rowID = (NSInteger)sqlite3_last_insert_rowid(db);
    resturant.rowID = rowID+1;
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO RESTURANT (Name, Tag , Detail , LocationName , lon , lat, insetIndex ) VALUES ( '%@','%@','%@','%@',%f,%f, %d)", resturant.name, resturant.tag, resturant.detail, resturant.locationName, resturant.lon, resturant.lat, resturant.rowID];
    NSLog(@"sql : %@", sql);
    
    char *errMsg;
    int ret = sqlite3_exec(db, [sql UTF8String], NULL, nil, &errMsg);
    
    if (SQLITE_OK != ret) {
        NSLog(@"Error on Insert New data : %s", errMsg);
    }

    NSLog(@"rowID : %d", (int)sqlite3_last_insert_rowid(db));
}

//맛집을 디비에서 제거
- (void)removeRestruantWithRowID:(NSInteger)rowID {
    //DELETE FROM ARTICLES WHERE GUID ='http://www.google.com'
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM RESTURANT WHERE insetIndex=%d", rowID];
    NSLog(@"sql : %@", sql);
    
    char *errMsg;
    int ret = sqlite3_exec(db, [sql UTF8String], NULL, nil, &errMsg);
    
    if (SQLITE_OK != ret) {
        NSLog(@"Error on Insert New data : %s", errMsg);
    }
}

// 현재 DB에 있는 맛집 갯수
- (NSInteger)getNumberOfResturants {
    return _ResturantList.count;
}

//맛집 정보를 디비에서 가져와 리스트에 저장함
- (void)requestRestrant {
    _ResturantList = [[NSMutableArray alloc] init];
    NSString *queryStr = @"SELECT * FROM RESTURANT ";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"Error(%d) on resolving data : %s", ret,sqlite3_errmsg(db));
    NSString *nameString;
    NSString *tagString;
    NSString *detailString;
    NSString *locationNameString;
    

    while (SQLITE_ROW == sqlite3_step(stmt)) {
        char *name = (char *)sqlite3_column_text(stmt, 0);
        nameString = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        char *tag = (char *)sqlite3_column_text(stmt, 1);
        tagString = [NSString stringWithCString:tag encoding:NSUTF8StringEncoding];
        
        char *detail = (char *)sqlite3_column_text(stmt, 2);
        detailString = [NSString stringWithCString:detail encoding:NSUTF8StringEncoding];
        
        char *locationName = (char *)sqlite3_column_text(stmt, 3);
        locationNameString = [NSString stringWithCString:locationName encoding:NSUTF8StringEncoding];
        
        float lon = (float)sqlite3_column_double(stmt, 4);
        
        float lat = (float)sqlite3_column_double(stmt, 5);
        NSLog(@"name:%@,tag:%@,detail:%@,locationName:%@,lon:%f,lat:%f",nameString,tagString,detailString,locationNameString,lon,lat);
        Resturant *resturant= [[Resturant alloc] initWithName:nameString locationName:locationNameString tag:tagString detail:detailString lon:lon lat:lat];
        
        resturant.rowID = sqlite3_column_int(stmt, 6);;
        
        [_ResturantList addObject:resturant];
    }
    sqlite3_finalize(stmt);
}

//맛집 가져오기
- (Resturant *)getResturantAtIndex:(NSInteger)index {
    return _ResturantList[index];
}

@end

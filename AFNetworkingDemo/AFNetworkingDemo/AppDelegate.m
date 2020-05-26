//
//  AppDelegate.m
//  AFNetworkingDemo
//
//  Created by Alan on 4/8/20.
//  Copyright © 2020 zhaixingzhi. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking.h>
#import <CoreTelephony/CTCellularData.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (__IPHONE_10_0) {
        [self cellularData];
    }else{
        [self startMonitoringNetwork];
    }
    

    
    // Override point for customization after application launch.
    return YES;
}

#pragma mark - 网络权限监控
- (void)cellularData{
    
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        
        switch (state) {
            case kCTCellularDataRestrictedStateUnknown:
                NSLog(@"不明错误.....");
                break;
            case kCTCellularDataRestricted:
                NSLog(@"没有授权....");
                [self testBD]; // 默认没有授权 ... 发起短小网络 弹框
                break;
            case kCTCellularDataNotRestricted:
                NSLog(@"授权了////");
                [self startMonitoringNetwork];
                break;
            default:
                break;
        }
    };
}

#pragma mark - startMonitoringNetwork

- (void)startMonitoringNetwork{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络,请检查互联网");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络,请检查互联网");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"连接蜂窝网络");
                [self testBD];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                [self testBD];
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];

}

#pragma mark - 网络测试接口
- (void)testBD{
    NSString *urlString = @"http://api.douban.com/v2/movie/top250";
    NSDictionary *dic = @{@"start":@(1),
                          @"count":@(5)
                          };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功:%@---%@",task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误提示:%@---%@",task,error);
    }];
}



#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end

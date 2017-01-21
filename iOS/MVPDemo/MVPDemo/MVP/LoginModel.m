//
//  LoginModel.m
//  MVPDemo
//
//  Created by WxkMac on 2017/1/20.
//  Copyright © 2017年 Wxk. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel
-(instancetype)initWithListener:(id<OnLoginFinishedListener>)listener{
    if (self = [super init]) {
        self.listener = listener;
    }
    return self;
}


-(void)loginWithUserName:(NSString *)userName password:(NSString *)pwd{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //模拟加载
        Boolean error = false;
        if (userName.length==0) {
            [self.listener onUsernameError];
            error = true;
        }
        if (pwd.length == 0) {
            [self.listener onPasswordError];
            error = true;
        }
        if (!error) {
            [self.listener onSuccess];
        }
        
    });
}

@end

//
//  LoginModel.h
//  MVPDemo
//
//  Created by WxkMac on 2017/1/20.
//  Copyright © 2017年 Wxk. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol OnLoginFinishedListener;
@interface LoginModel : NSObject

@property (nonatomic,copy) NSString *userName,*password;
@property (nonatomic,weak) id<OnLoginFinishedListener> listener;

-(instancetype)initWithListener:(id<OnLoginFinishedListener>)listener;

-(void)loginWithUserName:(NSString *)userName password:(NSString *)pwd;

@end



@protocol OnLoginFinishedListener <NSObject>

-(void) onUsernameError;

-(void) onPasswordError;

-(void) onSuccess;

@end

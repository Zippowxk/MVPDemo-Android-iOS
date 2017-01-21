//
//  LoginPresenter.h
//  MVPDemo
//
//  Created by WxkMac on 2017/1/20.
//  Copyright © 2017年 Wxk. All rights reserved.
//



#import <Foundation/Foundation.h>
@protocol LoginViewProtocol;
@interface LoginPresenter : NSObject
@property (nonatomic,weak) id<LoginViewProtocol>view;

-(instancetype)initWithView:(id<LoginViewProtocol>)view;

-(void)validateCredentialsWithUserName:(NSString *)userName pwd:(NSString*)pwd;

@end




@protocol LoginViewProtocol <NSObject>


-(void) showProgress;

-(void) hideProgress;

-(void) setUsernameError;

-(void) setPasswordError;

-(void) navigateToHome;

@end

//
//  LoginPresenter.m
//  MVPDemo
//
//  Created by WxkMac on 2017/1/20.
//  Copyright © 2017年 Wxk. All rights reserved.
//

#import "LoginPresenter.h"
#import "LoginModel.h"

@interface LoginPresenter ()<OnLoginFinishedListener>
{
    LoginModel *_model;
}
@end

@implementation LoginPresenter
-(instancetype)initWithView:(id<LoginViewProtocol>)view{

    if (self = [super init]) {
        self.view = view;
        _model = [[LoginModel alloc] initWithListener:self];
    }
    return self;
}



#pragma mark -  [View --> Presenter]
-(void)validateCredentialsWithUserName:(NSString *)userName pwd:(NSString*)pwd{
    [_model loginWithUserName:userName password:pwd];
    [self.view showProgress];
}

#pragma mark - OnLoginFinishedListener protocol ([Model --> Presenter])
-(void) onUsernameError{
    
    [self.view hideProgress];
    [self.view setUsernameError];
    
}

-(void) onPasswordError{
    [self.view setPasswordError];

}

-(void) onSuccess{
    [self.view navigateToHome];
}

@end

//
//  LoginViewController.m
//  MVPDemo
//
//  Created by WxkMac on 2017/1/20.
//  Copyright © 2017年 Wxk. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginPresenter.h"

@interface LoginViewController () <LoginViewProtocol>
{
    LoginPresenter *_presenter;
    IBOutlet UITextField *_userNameTxf,*_pwdTxf;
    IBOutlet UIActivityIndicatorView *_progressView;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _presenter = [[LoginPresenter alloc] initWithView:self];
}



#pragma mark - user interface action


-(IBAction)onClickGoButton{
    
    [_presenter validateCredentialsWithUserName:_userNameTxf.text pwd:_pwdTxf.text];
    
}


#pragma mark - Login Protocol
-(void) showProgress{
    [_progressView startAnimating];
    _progressView.hidden = NO;
}

-(void) hideProgress{

    [_progressView stopAnimating];
    _progressView.hidden = YES;
}

-(void) setUsernameError{
    //show alertView
}

-(void) setPasswordError{
    
    //show alertView
}

-(void) navigateToHome{
    UIViewController *home = [UIViewController new];
    [self.navigationController pushViewController:home animated:YES];
}



@end

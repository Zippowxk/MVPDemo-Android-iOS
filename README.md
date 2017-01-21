# MVP架构的实现和分析

>Author:[zippowxk.com](http://www.zippowxk.com)

>MVP框架网上有很多分析文章，本文是给还未接触或者对`MVP`、`MVVM`框架感觉很朦胧,甚至是觉得MVP纯粹无用的同学一块砖头，抛砖引玉，希望能引发大家的思考和套路。最后也会给出我的结论，怎么用MVP之我见。

_提示：部分内容中的链接需要科学上网工具才能访问。_

_PS:如果您觉得代码太多，文章太长，我为您标记了几个本文的重点，您可以直接看重点：_<br>
1. [MVC转换为MVP的核心观点](#101) 2.[MVP中的逻辑](#102) 3. [MVP和MVVM的区别](#3) 4. [为什么用MVP/MVVM](#104)

**开始前抛出一个供大家思考的问题，欢迎在评论区讨论自己的想法：什么是逻辑**


正文
----


**目录：**

1. [概述](#1)
2. [MVP在Android和iOS上的实现](#2)
3. [MVVM哪里有不同](#3)
4. [结论分析](#4)

--
### <span id="1">① MVP的概述</span>

`MVP`的由来不赘述，想了解历史的可以点[WIKIPEDIA](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter)

以往的代码结构中应用最广的就是[MVC](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)结构了，其实`MVC`在应用的时候，大家还是有意识的在做一种工作，那就是__抽象出逻辑__,我们都期望把逻辑控制代码放到`C`中，这也是`MVC`的设计初衷，但是我们尴尬的发现[Apple给出的解决方案](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html)，`Controller`中包含了一个默认绑定的`View`，并且管理着这个`View`的生命周期。这样的设计，导致`MVC`中，并未均衡的分担代码量，大量的代码分布在`C`中，而`M`和`V`则显得没有那么复杂， `Android`同理可见`Activity`。最后得到一个很难维护的`Controller`/`Activity `，和在迭代中基本不会修改的`View`和`Model`。这就尴尬了，大家都在维护`Controller`，所有关键代码都在一起，文件动辄两三千行是很常见的事情。

![](http://ohhwzwq69.bkt.clouddn.com/17-1-20/31189098-file_1484891811240_6f79.png)

很多程序员经历过此类痛苦之后，受到其他平台架构的启发，终于开始在Android和iOS上开始使用更加先进的架构模式，说先进其实有点不妥，每种架构都有自己的优势，并不能简单的一较高下。那么MVP是什么样子的，看图：
![](http://ohhwzwq69.bkt.clouddn.com/17-1-20/96985816-file_1484891767720_2bb4.png)<br>
有同学就纳闷了，这不和`MVC`一样吗？没错，在我看来就是一样的，大家设计初衷就是一样的，但是我们需要做一些改变，把`ViewController`/`Activity`看做`View`，这时候我们需要专门创建一个类作为逻辑类`Presenter`。

<span id="101"></span>
**在实现编码时，这部分总结一下就是两点：**

1. 把`ViewController`/`Activity`看做`View`
2. `View`和`Model`之间不进行任何直接交互，在编码中就是不互相调用方法。

<span id="104"></span>
**说到这有些人会有疑问，这么做除了能让代码分离开，还有没有别的好处。我能想到的好处还有：**

1. **增加了代码的单元测试能力**，因为`View`和`Presenter-Model`彻底分离，我们可以单独对`Presenter-Model`部分编写进行大量的单元测试用例，来检验迭代时逻辑有没有产生BUG，也可以针对`View`传输模拟信息，做单元测试。
2. **可以快速定位问题原因**，当一个问题出现，我们可以很快判定问题出在哪个环节，是数据、逻辑还是展示层出了问题。
3. **增加代码的复用性**，这个就不用多解释了。
4. **修改业务逻辑时更加清晰，不易产生新问题**,下一章节会举例说明。

--
### <span id = "2">② 在Android和iOS上的实现</span>

实现部分有大量的代码，想看源码的同学可以点击这里，[MVPSampleCode-Android-iOS]()

#### 2.1 目录结构

###### View:  <kbd>JAVA</kbd> `LoginActivity.java` / <kbd>objc</kbd> `LoginViewController`
###### Model: <kbd>JAVA</kbd>`LoginModel.java` / <kbd>objc</kbd>`LoginModel`
###### Presenter: <kbd>JAVA</kbd>`LoginPresenter.java` / <kbd>objc</kbd>`LoginPresenter`


#### 2.2.1 View的实现
<kbd>Java</kbd>实现

```java
//File LoginActivity.java 

public class LoginActivity extends Activity implements LoginView, View.OnClickListener {

    private ProgressBar progressBar;
    private EditText username;
    private EditText password;
    private LoginPresenter presenter;

	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        progressBar = (ProgressBar) findViewById(R.id.progress);
        username = (EditText) findViewById(R.id.username);
        password = (EditText) findViewById(R.id.password);
        findViewById(R.id.button).setOnClickListener(this);

        presenter = new LoginPresenterImpl(this);
    }
	
	//Presenter回调
    @Override
    protected void onDestroy() {
        presenter.onDestroy();
        super.onDestroy();
    }

    @Override
    public void showProgress() {
        progressBar.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideProgress() {
        progressBar.setVisibility(View.GONE);
    }

    @Override
    public void setUsernameError() {
        username.setError(getString(R.string.username_error));
    }

    @Override
    public void setPasswordError() {
        password.setError(getString(R.string.password_error));
    }

    @Override
    public void navigateToHome() {
        Toast.makeText(this,"login success",Toast.LENGTH_SHORT).show();
    }

	//UI响应
    @Override
    public void onClick(View v) {
        //信息发送给Presenter
        presenter.validateCredentials(username.getText().toString(), password.getText().toString());
    }

}
```
<kbd>objc</kbd>实现

```objective-c

//File LoginViewController.m

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

```
**View中的代码功能如下：**

1. 控制UI的状态和生命周期
2. 响应用户的行为 
3. 发送事件给Presenter 
5. 接收来自Presenter的事件 
6. 负责Presenter的声明周期

#### 2.2.2 Presenter的实现

<kbd>Java</kbd>实现

```java
//File LoginPresenterImpl.java

package com.wxk.androidmvpdemo.login;

/**
 *
 */
public class LoginPresenterImpl implements LoginPresenter, OnLoginFinishedListener {
    private LoginView loginView;
    private LoginModel loginModel;

    public LoginPresenterImpl(LoginView loginView) {
        this.loginView = loginView;
        this.loginModel = new LoginModelImpl();
    }

    @Override
    public void validateCredentials(String username, String password) {
        if (loginView != null) {
            loginView.showProgress();
        }

        loginModel.login(username, password, this);
    }

    @Override
    public void onDestroy() {
        loginView = null;
    }

    @Override
    public void onUsernameError() {
        if (loginView != null) {
            loginView.setUsernameError();
            loginView.hideProgress();
        }
    }

    @Override
    public void onPasswordError() {
        if (loginView != null) {
            loginView.setPasswordError();
            loginView.hideProgress();
        }
    }

    @Override
    public void onSuccess() {
        if (loginView != null) {
            loginView.navigateToHome();
        }
    }
}
```
<kbd>objc</kbd>实现

```objective-c
//File LoginPresenter.m

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


```
**Presenter有以下作用：**

1. 接收来自`View`的用户操作消息，抽象成对数据的处理操作，发送给`Model`
2. 接收来自`Model`的状态变化，具象成对UI的具体操作展示给用户，发送到`View`
3. 管理View的生命周期

<span id="102"></span>
##### 理解下面的话很重要

>从这个角度可以看到，**抽象成数据**和**具象成UI事件**的过程**就是逻辑**。比如“文字的长度变成了6到10位，显示成绿色”，这句话中前半句额就是一个抽象逻辑，后半部分就是一个具象逻辑，整个过程的信息过程是：<br>
>>`View`(用户输入字符串'xxxxxxxx')->`Presenter`(抽象逻辑，输入字符串'xxxxxxxx',抽象为长度为8，发送给Model)->`Model`(长度为8，符合长度为6到10的状态`α`)->`Presenter`(具象逻辑,状态`α`显示为绿色)->`View`(展示给用户)

#### 2.2.3 Model的实现

<kbd>Java</kbd>实现

```java
//File LoginModelImpl
package com.wxk.androidmvpdemo.login;

import android.os.Handler;
import android.text.TextUtils;
/**
 * 延时模拟登陆（2s），如果名字或者密码为空则登陆失败，否则登陆成功
 */
public class LoginModelImpl implements LoginModel {

    @Override
    public void login(final String username, final String password, final OnLoginFinishedListener listener) {

        new Handler().postDelayed(new Runnable() {
            @Override public void run() {
                boolean error = false;
                if (TextUtils.isEmpty(username)){
                    listener.onUsernameError();//model层里面回调listener
                    error = true;
                }
                if (TextUtils.isEmpty(password)){
                    listener.onPasswordError();
                    error = true;
                }
                if (!error){
                    listener.onSuccess();
                }
            }
        }, 2000);
    }
}


```
<kbd>objc</kbd>实现

```objective-c
// File LoginModel.m
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


```
**Model有以下作用：**

1. 接收`Presenter`消息，更新当前的数据
2. 从本地数据库或者通过网络接口在网络数据库中更新数据
3. 把复杂的数据处理成UI需要使用的具象状态 （例如从某个字段变成展示给用户的信息）

--
### <span id = "3">③ MVVM哪里有不同</span>

`MVVM`和`MVP`在架构上几乎完全一样，只是在`View`和`ViewModel`之间交互的时候，实现了更加全面的数据绑定功能，这部分我们会单独进行讨论，实现的方式比较常见的就是**函数响应式编程**[FRP](https://en.wikipedia.org/wiki/Functional_reactive_programming), 在`Android`上有[Rxjava](https://github.com/ReactiveX/RxJava),`iOS`上有[ReactCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)。 参考[Angular](https://github.com/angular/angular)的`View`和`Model`之间的数据绑定概念，我们可以实现`View`和`ViewModel`之间的绑定。2017年前端预研中，关于`FRP`和`MVP`都可能会作为重点出现，这二者合而为一，最后可能得到的就是一个`MVVM`架构。
![](http://ohhwzwq69.bkt.clouddn.com/17-1-20/98357087-file_1484891767842_1dc.png)

--
### <span id = "4">④ 结论分析</span>

结论很简单，有两点：

1. 使用`MVP`架构，必然增加代码量和开发难度。
2. 使用`MVP`架构必然让代码更加清晰易维护，迭代成本更低和效率更高，单元测试覆盖率更高。so，做外包项目不建议使用，但是做产品的话，你说呢？

END
--
### 最后再抛出两个问题供大家在活动一下大脑

1. <b>MVP中，M负责提供数据，那么网络请求，以及处理response，是放在M中，还是P中呢？</b><br>我的看法是都行，更倾向于放在M中，可以更好的单元测试，逻辑分离的更彻底。
2. <b>MVP还有哪些缺陷？</b> <br>砖还是得靠人搬啊。

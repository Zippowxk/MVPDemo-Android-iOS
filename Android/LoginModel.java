package com.wxk.androidmvpdemo.login;

/**
* 相当于声明方法，类似于协议。Model需要响应的事件
*/
public interface LoginModel {
    void login(String username, String password, OnLoginFinishedListener listener);
}

//
//  PTOAuthViewController.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTOAuthViewController.h"
#import "PTControllerTool.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "PTAccount.h"
#import "PTAccountTool.h"
#import "PTAccessTokenParam.h"

@interface PTOAuthViewController () <UIWebViewDelegate>

@end

@implementation PTOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.创建UIWebView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.frame;
    [self.view addSubview:webView];
    
    // 2.加载登录页面
    NSString *str = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", OAuthClientID, OAuthRedirectURI];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];
    
    // 3.设置代理
    webView.delegate = self;
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1.获得请求地址
    NSString *urlStr = request.URL.absoluteString;
    
    // 2.判断url是否为回调地址
    NSString *str = [NSString stringWithFormat:@"%@/?code=", OAuthRedirectURI];
    NSRange range = [urlStr rangeOfString:str];
    
    if (range.length > 0) { // 是回调地址
        // 截取授权成功后的请求标记
        NSString *code = [urlStr substringFromIndex:(range.length + range.location)];
        
        // 根据code获得一个accessToken
        [self accessTokenWithCode:code];
        
        // 禁止加载回调页面，跳转到根控制器
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
    PTLog(@"%@", error);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载中"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (void)accessTokenWithCode:(NSString *)code
{
    // 1.封装请求参数
    PTAccessTokenParam *param = [PTAccessTokenParam param];
    param.client_id = OAuthClientID;
    param.client_secret = OAuthClientSecret;
    param.grant_type = OAuthGrantType;
    param.code = code;
    param.redirect_uri = OAuthRedirectURI;
    
    // 2.获取授权的账号模型
    [PTAccountTool accessTokenWithParam:param success:^(PTAccount *account) {
    	// 隐藏HUD
        [MBProgressHUD hideHUD];
        
        [PTAccountTool save:account];
        
        // 切换控制器(可能去新特性/tabbar)
        [PTControllerTool chooseRootViewController];
    } failure:^(NSError *error) {
    	// 隐藏HUD
        [MBProgressHUD hideHUD];
        PTLog(@"请求失败---%@", error);
    }];
}

@end

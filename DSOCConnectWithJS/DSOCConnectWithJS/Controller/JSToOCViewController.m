//
//  JSToOCViewController.m
//  DSOCConnectWithJS
//
//  Created by dasheng on 16/1/21.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "JSToOCViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>


@protocol JSObjcDelegate <JSExport>

//此处我们测试几种参数的情况
-(void)TestNOParameter;
-(NSString *)TestOneParameter:(NSString *)message;
-(NSString *)TestTwoParameter:(NSString *)message1 SecondParameter:(NSString *)message2;

@end


@interface JSToOCViewController()<JSObjcDelegate,UIWebViewDelegate>

@end

@implementation JSToOCViewController{
    
    UIWebView *_myWebView;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    _myWebView.delegate = self;
    [self.view addSubview:_myWebView];
    
    //本地html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [_myWebView loadHTMLString:htmlCont baseURL:baseURL];
    
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    if ([self.title isEqualToString:@""]||!self.title) {
        NSString *navigationTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if (![navigationTitle isEqualToString:@""]) {
            [self setTitle:navigationTitle];
        }
    }
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"Toyun"]=self;
    
//    NSString *alertJS=@"alert(Toyun.TestOneParameter('参数1'))"; //准备执行的js代码
//    [context evaluateScript:alertJS];//通过oc方法调用js的alert
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType //这个方法是网页中的每一个请求都会被触发的
{
    
    return YES;
}


#pragma mark JSObjcDelegate

//一下方法都是只是打了个log 等会看log 以及参数能对上就说明js调用了此处的iOS 原生方法
-(void)TestNOParameter{
    
    NSLog(@"this is ios TestNOParameter");
}

-(NSString *)TestOneParameter:(NSString *)message{
    
    NSLog(@"this is ios TestOneParameter=%@",message);
    return @"this is ios TestOneParameter";
}

-(NSString *)TestTwoParameter:(NSString *)message1 SecondParameter:(NSString *)message2{
    
    NSLog(@"this is ios TestTwoParameter=%@  Second=%@",message1,message2);
    return @"this is ios TestTwoParameter";
}

@end

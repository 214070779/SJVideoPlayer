//
//  ViewControllerDefaultPlayer.m
//  SJVideoPlayer
//
//  Created by 畅三江 on 2018/9/30.
//  Copyright © 2018 畅三江. All rights reserved.
//

#import "ViewControllerDefaultPlayer.h"
#import "SJVideoPlayer.h"
#import <SJRouter/SJRouter.h>
#import <Masonry/Masonry.h>
#import <WebKit/WebKit.h>
#import <SJBaseVideoPlayer/SJBaseVideoPlayer+PlayStatus.h>

@interface ViewControllerDefaultPlayer ()<SJRouteHandler>
@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ViewControllerDefaultPlayer

+ (NSString *)routePath {
    return @"player/defaultPlayer";
}

+ (void)handleRequestWithParameters:(SJParameters)parameters topViewController:(UIViewController *)topViewController completionHandler:(SJCompletionHandler)completionHandler {
    [topViewController.navigationController pushViewController:[self new] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // create a player of the default type
    _player = [SJVideoPlayer player];

    [self.view addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        else make.top.offset(0);
        make.leading.trailing.offset(0);
        make.height.equalTo(self->_player.view.mas_width).multipliedBy(9 / 16.0f);
    }];
    
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:@"https://xy2.v.netease.com/2018/0815/c4f8e15cf43e4404911c2e9d17d89d3fqt.mp4"]];
    _player.URLAsset.title = @"一次邂逅, 遇见一生所爱";
    
    _player.hideBackButtonWhenOrientationIsPortrait = YES;
    _player.pausedToKeepAppearState = YES; 
    _player.enableFilmEditing = YES;
    _player.filmEditingConfig.saveResultToAlbumWhenExportSuccess = YES;
    _player.resumePlaybackWhenAppDidEnterForeground = YES;
    
    SJEdgeControlButtonItem *titleItem = [_player.defaultEdgeControlLayer.topAdapter itemForTag:SJEdgeControlLayerTopItem_Title];
    titleItem.numberOfLines = 1;
    
#pragma mark
    UILabel *noteLabel = [UILabel new];
    noteLabel.numberOfLines = 0;
    noteLabel.text = @"This is a simple demo, please use other demos to understand how to use.\n此为简单Demo, 请通过其他Demo来了解如何使用.";
    noteLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:noteLabel];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(8);
        make.trailing.offset(-8);
        make.centerY.offset(0);
    }];
    
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.allowsInlineMediaPlayback = YES;
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    
    _webView.frame = CGRectMake(0, 400, self.view.bounds.size.width, 300);
    [self.view insertSubview:_webView atIndex:0];
    
    NSURL *URL = [NSURL URLWithString:@"https://mp.weixin.qq.com/s/_ppwbyHn9ag3zrkV7qu4qw"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [_webView loadRequest:request];

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player vc_viewDidDisappear];
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

@end

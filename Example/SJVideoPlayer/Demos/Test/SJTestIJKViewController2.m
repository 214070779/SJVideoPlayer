//
//  SJTestViewController2.m
//  SJVideoPlayer_Example
//
//  Created by BlueDancer on 2019/10/12.
//  Copyright © 2019 changsanjiang. All rights reserved.
//

#import "SJTestIJKViewController2.h"
#import "SJSourceURLs.h"
#import "SJVideoPlayer.h"
#import "Masonry.h"

#if __has_include(<IJKMediaFrameworkWithSSL/IJKMediaFrameworkWithSSL.h>)
#import "SJIJKMediaPlaybackController.h"
#endif

@interface SJTestIJKViewController2 ()
@property (nonatomic, strong) SJVideoPlayer *player;
@end

@implementation SJTestIJKViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    _player = SJVideoPlayer.player;
#if __has_include(<IJKMediaFrameworkWithSSL/IJKMediaFrameworkWithSSL.h>)
    _player.playbackController = SJIJKMediaPlaybackController.new;
#endif
    
    _player.URLAsset = [SJVideoPlayerURLAsset.alloc initWithURL:VideoURL_Level4];
    _player.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.left.right.offset(0);
        make.height.equalTo(self.player.view.mas_width).multipliedBy(9/16.0);
    }];
}
- (IBAction)seek:(id)sender {
    [_player seekToTime:_player.currentTime + 60 completionHandler:^(BOOL finished) {}];
}
- (IBAction)play:(id)sender {
    [_player play];
}
- (IBAction)pause:(id)sender {
    [_player pause];
}
- (IBAction)next:(id)sender {
    _player.URLAsset = [SJVideoPlayerURLAsset.alloc initWithURL:VideoURL_Level1];
}
@end

#pragma mark -

#import <SJRouter/SJRouter.h>

@interface SJTestIJKViewController2 (RouteHandler)<SJRouteHandler>
@end

@implementation SJTestIJKViewController2 (RouteHandler)
+ (NSString *)routePath {
    return @"test2";
}

+ (void)handleRequest:(SJRouteRequest *)request topViewController:(UIViewController *)topViewController completionHandler:(SJCompletionHandler)completionHandler {
    [topViewController.navigationController pushViewController:SJTestIJKViewController2.new animated:YES];
}
@end

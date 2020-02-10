//
//  OSETutorialDetailViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/7.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSETutorialDetailViewController.h"
#import <AVKit/AVKit.h>

@interface OSETutorialDetailViewController ()

@property (nonatomic,strong) AVPlayerLayer * videoPlayer;

@end

@implementation OSETutorialDetailViewController {
    NSURL * _url ;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    _url = [[NSBundle mainBundle] URLForResource:title withExtension:@".mp4"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoDidPlayEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat top = self.navigationController.navigationBar.bottom;
    self.videoPlayer.frame = CGRectMake(0, top,self.view.width,self.view.height - top);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_videoPlayer.player play];
}

- (void)videoDidPlayEnd {
    self.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"重新播放", nil)
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(rePlayVideo)];
}

- (void)layoutSubviews {
    CGFloat top = self.navigationController.navigationBar.bottom;
    self.videoPlayer.frame = CGRectMake(0, top,self.view.width,self.view.height - top);
    [self.view.layer addSublayer:self.videoPlayer];
}

- (AVPlayerLayer *)videoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [AVPlayerLayer playerLayerWithPlayer:[AVPlayer playerWithURL:_url]];
    }
    return _videoPlayer;
}

- (void)rePlayVideo {
    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    _videoPlayer.player = [AVPlayer playerWithURL:_url];
    [_videoPlayer.player play];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

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

- (instancetype)init {
    if (self = [super init]) {
        _url = [[NSBundle mainBundle] URLForResource:self.title withExtension:@".mp4"];
    }
    return self;
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
    UIView * navigationBar = self.navigationController.navigationBar;
    self.videoPlayer.frame = CGRectMake(0, navigationBar.bottom,self.view.width,self.view.height - navigationBar.bottom);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_videoPlayer.player play];
}

- (void)videoDidPlayEnd {
    self.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"重新播放"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(rePlayVideo)];
}

- (void)layoutSubviews {
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

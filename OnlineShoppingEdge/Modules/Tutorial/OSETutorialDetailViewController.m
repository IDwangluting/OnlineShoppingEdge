//
//  OSETutorialDetailViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/7.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSETutorialDetailViewController.h"
@import AVFoundation;

@interface OSETutorialDetailViewController ()

@property (nonatomic,strong) AVPlayerLayer * videoPlayer;

@end

@implementation OSETutorialDetailViewController {
    NSURL * _url ;
}

- (void)setTitle:(NSString *)title {
    if ([@[@"当当",@"當當"] containsObject:title]) {
        _url = [[NSBundle mainBundle] URLForResource:@"当当" withExtension:@".mp4"];
    }else  if([@[@"京东",@"京東"] containsObject:title]) {
        _url = [[NSBundle mainBundle] URLForResource:@"京东" withExtension:@".mp4"];
    }else  if([@[@"天猫",@"天貓"] containsObject:title]) {
        _url = [[NSBundle mainBundle] URLForResource:@"天猫" withExtension:@".mp4"];
    }else  if([@[@"亚马逊",@"亞馬遜",@"amazon"] containsObject:title]) {
        _url = [[NSBundle mainBundle] URLForResource:@"亚马逊" withExtension:@".mp4"];
    }else  if([@[@"淘宝",@"淘寶"] containsObject:title]) {
        _url = [[NSBundle mainBundle] URLForResource:@"淘宝" withExtension:@".mp4"];
    }else  if([@[@"考拉海购",@"考拉海購"] containsObject:title]) {
        _url = [[NSBundle mainBundle] URLForResource:@"考拉海购" withExtension:@".mp4"];
    }
    [super setTitle:[NSString stringWithFormat:@"%@App--%@",title,NSLocalizedString(@"使用教程", nil)]];
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

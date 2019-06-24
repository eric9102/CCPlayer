//
//  ViewController.m
//  CCPlayer
//
//  Created by 李雪峰 on 2019/6/18.
//  Copyright © 2019 eric9102. All rights reserved.
//

#import "ViewController.h"
#import "NSData+ASE128.h"
#import <AVFoundation/AVFoundation.h>
#import "CCAssetResourceLoader.h"
#import "HTTPServer.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"

@interface ViewController ()

@property(nonatomic, strong)AVURLAsset *URLAsset;
@property (nonatomic, strong)AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) CCAssetResourceLoader *ccResourceLoader;

@property (nonatomic, strong) HTTPServer * httpServer;

@property (strong, nonatomic) GCDWebServer* gcdWebServer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self openHttpServer];
    [self openGCDWebServer];
}

- (IBAction)copyFileToDocument:(id)sender {
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp3"]];
    
//    NSData *mp3Data = [[[NSData alloc] initWithContentsOfURL:url] AES128EncryptWithKey:@"123"];

    NSData *mp3Data = [[NSData alloc] initWithContentsOfURL:url];
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = [NSString stringWithFormat:@"%@/11.mp3", documentDirectory];
    [mp3Data writeToFile:fileName atomically:YES];
    
    NSLog(@"%@", fileName);
    
}


- (IBAction)playMusic:(id)sender {
    
    NSString *playUrl = @"zxsy://127.0.0.1:12123/11.mp3";
    
    self.URLAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:playUrl] options:nil];
    
    self.ccResourceLoader = [[CCAssetResourceLoader alloc] init];
    [self.URLAsset.resourceLoader setDelegate:_ccResourceLoader queue:dispatch_queue_create("ccAssetResource loader", nil)];
    
     AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:_URLAsset];
    
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
    } else {
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
    }
    
    [self.player play];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)openHttpServer
{
    
    self.httpServer = [[HTTPServer alloc] init];
    [self.httpServer setType:@"_http._tcp."];  // 设置服务类型
    [self.httpServer setPort:12123]; // 设置服务器端口
    
    // 获取本地Library/Cache路径下downloads路径
    NSString *WebBasePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSLog(@"-------------\nSetting document root: %@\n", WebBasePath);
    // 设置服务器路径
    [self.httpServer setDocumentRoot:WebBasePath];
    NSError *error;
    if(![self.httpServer start:&error])
    {
        NSLog(@"-------------\nError starting HTTP Server: %@\n", error);
    }
}

- (void)openGCDWebServer{

        self.gcdWebServer = [[GCDWebServer alloc] init];
        NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
        [_gcdWebServer addGETHandlerForBasePath:@"/" directoryPath:documentDirectory indexFilename:nil cacheAge:3600 allowRangeRequests:YES];
        [_gcdWebServer startWithPort:12123 bonjourName:nil];
    
        NSLog(@"Visit %@ in your web browser", _gcdWebServer.serverURL);
    
}

@end



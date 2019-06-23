//
//  CCAssetResourceLoader.m
//  CCPlayer
//
//  Created by 李雪峰 on 2019/6/23.
//  Copyright © 2019 eric9102. All rights reserved.
//

#import "CCAssetResourceLoader.h"

@implementation CCAssetResourceLoader

- (BOOL) resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
//    NSString* scheme = [[[loadingRequest request] URL] scheme];
//
//    if ([self isRedirectSchemeValid:scheme])
//        return [self handleRedirectRequest:loadingRequest];
//
//    if ([self isCustomPlaylistSchemeValid:scheme]) {
//        dispatch_async (dispatch_get_main_queue(),  ^ {
//            [self handleCustomPlaylistRequest:loadingRequest];
//        });
//        return YES;
//    }
    
    
    return YES;
}


@end

//
//  CCAssetResourceLoader.m
//  CCPlayer
//
//  Created by 李雪峰 on 2019/6/23.
//  Copyright © 2019 eric9102. All rights reserved.
//

#import "CCAssetResourceLoader.h"
#import <CoreServices/CoreServices.h>
#import "NSData+ASE128.h"

static int redirectErrorCode = 302;
static int badRequestErrorCode = 400;

@interface CCAssetResourceLoader ()

@property (strong, nonatomic) NSData *yourDataSource;

@end

@implementation CCAssetResourceLoader

- (BOOL) resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    NSString* scheme = [[[loadingRequest request] URL] scheme];
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
    
    NSLog(@"shouldWaitForLoadingOfRequestedResource");
    
    if ([scheme isEqualToString:@"zxsy"]) {
        
//        [self handleRedirectRequest:loadingRequest];
        
        [self handleRedirectRequestForEncryptData:loadingRequest];
        
    }
    
    return YES;
}

- (void) handleRedirectRequestForEncryptData:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = [NSString stringWithFormat:@"%@/11.mp3", documentDirectory];
    
    if (!self.yourDataSource) {
        
        self.yourDataSource = [[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:fileName]] AES128DecryptWithKey:@"123"];
        
    }
    
    loadingRequest.contentInformationRequest.contentType    = (__bridge NSString *)kUTTypeMP3;
    loadingRequest.contentInformationRequest.contentLength  = _yourDataSource.length;
    loadingRequest.contentInformationRequest.byteRangeAccessSupported   = YES;
    NSRange range = NSMakeRange((NSUInteger)loadingRequest.dataRequest.requestedOffset, loadingRequest.dataRequest.requestedLength);
    [loadingRequest.dataRequest respondWithData:[_yourDataSource subdataWithRange:range]];
    [loadingRequest finishLoading];
    
}

- (BOOL) handleRedirectRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    NSURLRequest *redirect = nil;
    
    redirect = [self generateRedirectURL:(NSURLRequest *)[loadingRequest request]];
    if (redirect)
    {
        [loadingRequest setRedirect:redirect];
        NSLog(@"\n[Function]:%s\n" "[line]:%d\n" "[value]:%@\n",__FUNCTION__, __LINE__, [redirect URL]);
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[redirect URL] statusCode:redirectErrorCode HTTPVersion:nil headerFields:nil];
        [loadingRequest setResponse:response];
        [loadingRequest finishLoading];
        
    } else
    {
        [self reportError:loadingRequest withErrorCode:badRequestErrorCode];
    }
    return YES;
}

-(NSURLRequest* ) generateRedirectURL:(NSURLRequest *)sourceURL
{
    NSURLRequest *redirect = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[sourceURL URL] absoluteString] stringByReplacingOccurrencesOfString:@"zxsy" withString:@"http"]]];
    return redirect;
}

- (void) reportError:(AVAssetResourceLoadingRequest *) loadingRequest withErrorCode:(int) error
{
    [loadingRequest finishLoadingWithError:[NSError errorWithDomain: NSURLErrorDomain code:error userInfo: nil]];
}



@end

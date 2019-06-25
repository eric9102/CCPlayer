//
//  GCDWebServerFileResponseWithDecryption.m
//  CCPlayer
//
//  Created by 李雪峰 on 2019/6/25.
//  Copyright © 2019 eric9102. All rights reserved.
//

#import "GCDWebServerFileResponseWithDecryption.h"
#import "NSData+ASE128.h"

@implementation GCDWebServerFileResponseWithDecryption

- (NSData*)readData:(NSError**)error
{
    NSData* data = [super readData:error];
    
    return [data AES128DecryptWithKey:@"123"];
    
}

@end

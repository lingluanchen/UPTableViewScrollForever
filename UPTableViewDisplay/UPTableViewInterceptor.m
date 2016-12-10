//
//  UPTableViewInterceptor.m
//  UPTableViewDisplay
//
//  Created by wust_LiTao on 2016/12/6.
//  Copyright © 2016年 李锦民. All rights reserved.
//

#import "UPTableViewInterceptor.h"

@implementation UPTableViewInterceptor

#pragma mark - forward & response override
- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    if ([self.middleMan respondsToSelector:aSelector]) return self.middleMan;
    if ([self.receiver respondsToSelector:aSelector]) return self.receiver;

    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    if ([self.middleMan respondsToSelector:aSelector]) return YES;
    if ([self.receiver respondsToSelector:aSelector]) return YES;

    return [super respondsToSelector:aSelector];
}

@end

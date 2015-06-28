//
//  NSObject_Extension.m
//  RealmBrowser
//
//  Created by Kittinun Vantasin on 6/27/15.
//  Copyright (c) 2015 Kittinun Vantasin. All rights reserved.
//

#import "NSObject_Extension.h"

#import "RealmBrowser.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[RealmBrowser alloc] initWithBundle:plugin];
        });
    }
}

@end

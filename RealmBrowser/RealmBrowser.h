//
//  RealmBrowser.h
//  RealmBrowser
//
//  Created by Kittinun Vantasin on 6/27/15.
//  Copyright (c) 2015 Kittinun Vantasin. All rights reserved.
//

#import <AppKit/AppKit.h>

@class RealmBrowser;

static RealmBrowser *sharedPlugin;

extern NSString *const RealmBrowserErrorDomain;

@interface RealmBrowser : NSObject

+ (instancetype)sharedPlugin;

- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle *bundle;

@end
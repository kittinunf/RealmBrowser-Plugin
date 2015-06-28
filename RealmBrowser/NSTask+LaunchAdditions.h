//
//  NSTask+LaunchAdditions.h
//  RealmBrowser
//
//  Created by Kittinun Vantasin on 6/28/15.
//  Copyright (c) 2015 Kittinun Vantasin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTask (LaunchAdditions)

+ (void)launchWithPath:(NSString *)path arguments:(NSArray *)args handler:(void (^)(NSData *output))handler;

@end

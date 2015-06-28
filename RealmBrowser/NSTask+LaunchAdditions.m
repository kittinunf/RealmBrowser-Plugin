//
//  NSTask+LaunchAdditions.m
//  RealmBrowser
//
//  Created by Kittinun Vantasin on 6/28/15.
//  Copyright (c) 2015 Kittinun Vantasin. All rights reserved.
//

#import "NSTask+LaunchAdditions.h"

@implementation NSTask (LaunchAdditions)

+ (void)launchWithPath:(NSString *)path arguments:(NSArray *)args handler:(void (^)(NSData *))handler {
    NSTask *task = [[NSTask alloc] init];

    task.launchPath = path;
    task.arguments = args;

    NSPipe *pipe = [NSPipe pipe];
    task.standardOutput = pipe;

    [task launch];
    [task waitUntilExit];

    NSData *output = [[pipe fileHandleForReading] readDataToEndOfFile];

    if (handler) {
        handler(output);
    }
}

@end

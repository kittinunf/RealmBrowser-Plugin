//
//  NSFileManager+GlobAdditions.m
//  RealmBrowser
//
//  Created by Kittinun Vantasin on 6/28/15.
//  Copyright (c) 2015 Kittinun Vantasin. All rights reserved.
//

#import "NSFileManager+GlobAdditions.h"

@implementation NSFileManager (GlobAdditions)

- (NSArray *)globFilesAtDirectoryURL:(NSURL *)directoryURL fileExtension:(NSString *)extension errorHandler:(BOOL (^)(NSURL *, NSError *))handler {
    return [self globFilesAtDirectoryURL:directoryURL predicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"pathExtension == '%@'", extension]] errorHandler:handler];
}

- (NSArray *)globFilesAtDirectoryURL:(NSURL *)directoryURL predicate:(NSPredicate *)filteredPredicate errorHandler:(BOOL (^)(NSURL *, NSError *))handler {
    NSDirectoryEnumerator *directoryEnumerator = [self enumeratorAtURL:directoryURL
                                            includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                                               options:NSDirectoryEnumerationSkipsHiddenFiles
                                                          errorHandler:handler];
    NSMutableArray *fileURLs = [NSMutableArray array];
    for (NSURL *fileURL in directoryEnumerator) {
        NSString *fileName;
        [fileURL getResourceValue:&fileName forKey:NSURLNameKey error:nil];

        NSString *isDirectory;
        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];

        //check it is not a directory
        if (![isDirectory boolValue]) {
            [fileURLs addObject:fileURL];
        }
    }

    return [fileURLs filteredArrayUsingPredicate:filteredPredicate];
}

@end

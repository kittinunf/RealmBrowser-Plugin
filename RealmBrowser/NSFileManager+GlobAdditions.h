//
//  NSFileManager+GlobAdditions.h
//  RealmBrowser
//
//  Created by Kittinun Vantasin on 6/28/15.
//  Copyright (c) 2015 Kittinun Vantasin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (GlobAdditions)

- (NSArray *)globFilesAtDirectoryURL:(NSURL *)directoryURL fileExtension:(NSString *)extension errorHandler:(BOOL (^)(NSURL *URL, NSError *error))handler;

- (NSArray *)globFilesAtDirectoryURL:(NSURL *)directoryURL predicate:(NSPredicate *)filteredPredicate errorHandler:(BOOL (^)(NSURL *URL, NSError *error))handler;

@end

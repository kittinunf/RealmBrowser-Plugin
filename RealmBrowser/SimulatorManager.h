//
//  SimulatorHandler.h
//  RealmBrowser
//
//  Created by Kittinun Vantasin on 6/28/15.
//  Copyright (c) 2015 Kittinun Vantasin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimulatorManager : NSObject

+ (instancetype)defaultManager;

- (NSString *)bootedDeviceUUID;

@property (copy, nonatomic, readonly) NSDictionary *devices;

@end

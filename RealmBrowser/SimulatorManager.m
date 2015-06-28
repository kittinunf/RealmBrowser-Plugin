//
//  SimulatorHandler.m
//  RealmBrowser
//
//  Created by Kittinun Vantasin on 6/28/15.
//  Copyright (c) 2015 Kittinun Vantasin. All rights reserved.
//

#import "SimulatorManager.h"

#import "NSTask+LaunchAdditions.h"

@interface SimulatorManager ()

@property (strong, nonatomic) NSMutableDictionary *data;

@end

@implementation SimulatorManager

#pragma mark - Instantiation

+ (instancetype)defaultManager {
    static SimulatorManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SimulatorManager alloc] init];
    });

    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _data = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Properties

- (NSDictionary *)devices {
    return [self.data copy];
}

#pragma mark - Public

- (NSString *)bootedDeviceUUID {
    NSString *deviceData = [self loadDeviceDetail];
    [self parseDeviceDetail:deviceData];

    NSString *bootedDevice;
    for (NSString *key in [self.data allKeys]) {
        NSString *deviceStatus = self.data[key];
        if ([deviceStatus isEqualToString:@"Booted"]) {
            bootedDevice = key;
            break;
        }
    }
    return bootedDevice;
}

#pragma mark - Privates

- (NSString *)loadDeviceDetail {
    NSString *path = @"/usr/bin/xcrun";
    NSArray *args = @[@"simctl", @"list", @"devices"];

    __block NSString *deviceData;
    [NSTask launchWithPath:path
                 arguments:args
                   handler:^(NSData *output) {
                       deviceData = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
                   }];

    return deviceData;
}

- (void)parseDeviceDetail:(NSString *)detail {
    [self.data removeAllObjects];

    NSScanner *scanner = [NSScanner scannerWithString:detail];
    //skip punctuation ( )
    scanner.charactersToBeSkipped = [NSCharacterSet punctuationCharacterSet];
    while (![scanner isAtEnd]) {
        NSString *deviceKey;
        NSString *deviceStatus;
        //scan to (
        [scanner scanUpToString:@"(" intoString:nil];

        if ([scanner scanUpToString:@")" intoString:&deviceKey]) {
        }

        //scan to (
        [scanner scanUpToString:@"(" intoString:nil];

        if ([scanner scanUpToString:@")" intoString:&deviceStatus]) {
        }

        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:nil];

        if (deviceKey && deviceStatus) {
            _data[deviceKey] = deviceStatus;
        }
    }
}

@end

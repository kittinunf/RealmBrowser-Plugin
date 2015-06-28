//
//  RealmBrowser.m
//  RealmBrowser
//
//  Created by Kittinun Vantasin on 6/27/15.
//  Copyright (c) 2015 Kittinun Vantasin. All rights reserved.
//

#import "RealmBrowser.h"

#import "SimulatorManager.h"

#import "NSFileManager+GlobAdditions.h"
#import "NSTask+LaunchAdditions.h"

NSString *const RealmBrowserErrorDomain = @"org.realmbrowser.error";

NSString *const RealmBrowserApp = @"Realm Browser";
NSString *const RootDeviceSimulatorPath = @"Library/Developer/CoreSimulator/Devices";
NSString *const DeviceSimulatorApplicationPath = @"data/Containers/Data/Application";

@interface RealmBrowser ()

@property (strong, nonatomic, readwrite) NSBundle *bundle;

@end

@implementation RealmBrowser

#pragma mark - Instantiation

+ (instancetype)sharedPlugin {
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];

        //instantiate simulator manager
        [SimulatorManager defaultManager];
    }
    return self;
}

#pragma mark - Life Cycles

- (void)didApplicationFinishLaunchingNotification:(NSNotification *)noti {
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];

    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"View"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Open Realm Browser" action:@selector(openRealmBrowser) keyEquivalent:@"w"];
        [actionMenuItem setKeyEquivalentModifierMask:NSShiftKeyMask | NSCommandKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Privates

- (void)openRealmBrowser {
    NSString *deviceUUID = [[SimulatorManager defaultManager] bootedDeviceUUID];

    if (!deviceUUID) {
        NSError *bootedDeviceNotFoundError = [NSError errorWithDomain:RealmBrowserErrorDomain code:-1 userInfo:@{ NSLocalizedDescriptionKey: @"Cannot find active Simulator" }];
        [[NSAlert alertWithError:bootedDeviceNotFoundError] runModal];
        return;
    }

    NSArray *realmFileURLs = [self realmFilesURLWithDeviceUUID:deviceUUID];
    for (NSURL *realmFileURL in realmFileURLs) {
        [[NSWorkspace sharedWorkspace] openFile:[realmFileURL path] withApplication:RealmBrowserApp];
    }
}

- (NSArray *)realmFilesURLWithDeviceUUID:(NSString *)deviceUUID {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *homeURL = [NSURL URLWithString:NSHomeDirectory()];

    NSMutableString *fullPath = [NSMutableString string];
    [fullPath appendFormat:@"%@/%@/%@", RootDeviceSimulatorPath, deviceUUID, DeviceSimulatorApplicationPath];
    NSURL *bootedDeviceURL = [homeURL URLByAppendingPathComponent:fullPath];

    NSArray *fileURLs = [fileManager globFilesAtDirectoryURL:bootedDeviceURL
                                               fileExtension:@"realm"
                                                errorHandler:^BOOL(NSURL *URL, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        return NO;
                                                    }
                                                    return YES;
                                                }];
    return fileURLs;
}

@end

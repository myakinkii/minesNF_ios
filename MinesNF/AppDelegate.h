//
//  AppDelegate.h
//  MinesNF
//
//  Created by Alex Myakinkii on 14/06/14.
//  Copyright (c) 2014 Alex Myakinkii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonSocket.h"
#import "SingletonModel.h"
#import "AsyncSocket/GCDAsyncSocket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

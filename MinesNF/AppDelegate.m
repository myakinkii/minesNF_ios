//
//  AppDelegate.m
//  MinesNF
//
//  Created by Alex Myakinkii on 14/06/14.
//  Copyright (c) 2014 Alex Myakinkii. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate()
@property (strong, nonatomic) NSString *tcpDataBuffer;
@end

@implementation AppDelegate

#define DEV (0)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //init settings object and load it into model
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"server"])
        [defaults setObject:@"minesnf.com" forKey:@"server"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[SingletonModel getInstance] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"server"] forKey:@"server"];
    
    [SingletonSocket initWithDelegate:self AndSocketHost:(DEV?@"localhost":[SingletonModel getInstance][@"server"]) AndPort:8081];
    return YES;
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [self receivedMessage:data];
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error {
    if (error)
        NSLog(@"ERROR %@",[error description]);
    else
        NSLog(@"Disconnected somehow");
}

- (NSString *)tcpDataBuffer
{
    if (!_tcpDataBuffer)
        _tcpDataBuffer = @"";
    return _tcpDataBuffer;
}

-(void)receivedMessage:(NSData *)data
{
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    self.tcpDataBuffer= [self.tcpDataBuffer stringByAppendingString:str];
    
    if ([self.tcpDataBuffer hasSuffix:@"\n"]) {
        NSArray *array = [self.tcpDataBuffer componentsSeparatedByString:@"\n"];
        for (NSString *re in array){
            NSData* data = [re dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (json)
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TcpData"
                                                                    object:self
                                                                  userInfo:json];
        }
        self.tcpDataBuffer=@"";
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

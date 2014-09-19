//
//  SingletonSocket.m
//  MinesNF
//
//  Created by Alex Myakinkii on 14/06/14.
//  Copyright (c) 2014 Alex Myakinkii. All rights reserved.
//

#import "SingletonSocket.h"

@implementation SingletonSocket

static GCDAsyncSocket *asyncSocket = nil;

+(void)initWithDelegate:(id)delegateObject AndSocketHost:(NSString*)host AndPort:(NSInteger)port {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:delegateObject
                                                 delegateQueue:dispatch_get_main_queue()];
        NSError* err;
        if(![asyncSocket connectToHost:host onPort:port error:&err])
            NSLog(@"ERROR %@",[err description]);
    });
}

+(GCDAsyncSocket *)getInstance
{
    return asyncSocket;
}

@end

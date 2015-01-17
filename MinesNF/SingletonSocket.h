//
//  SingletonSocket.h
//  MinesNF
//
//  Created by Alex Myakinkii on 14/06/14.
//  Copyright (c) 2014 Alex Myakinkii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASyncSocket/GCDAsyncSocket.h"

@interface SingletonSocket : NSObject

+(void)initWithDelegate:(id)delegateObject AndSocketHost:(NSString*)host AndPort:(NSInteger)port;
+(GCDAsyncSocket *)getInstance;

@end

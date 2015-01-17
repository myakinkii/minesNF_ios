//
//  SingletonModel.m
//  MinesNF
//
//  Created by Alex Myakinkii on 17/01/15.
//  Copyright (c) 2015 Alex Myakinkii. All rights reserved.
//

#import "SingletonModel.h"

@implementation SingletonModel

static NSMutableDictionary *model = nil;

+(NSMutableDictionary *)getInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        model = [[NSMutableDictionary alloc] init];
    });
    return model;
}

@end

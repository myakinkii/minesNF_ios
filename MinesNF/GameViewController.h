//
//  GameViewController.h
//  MinesNF
//
//  Created by Alex Myakinkii on 27/06/14.
//  Copyright (c) 2014 Alex Myakinkii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonSocket.h"
#import "AsyncSocket/GCDAsyncSocket.h"

@interface GameViewController : UIViewController
//@property (nonatomic, strong) NSString *board;
@property (nonatomic) int rows;
@property (nonatomic) int cols;
@property (nonatomic, strong) NSString *mode;

@end

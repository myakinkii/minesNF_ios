//
//  CellView.m
//  MinesNF
//
//  Created by Alex Myakinkii on 30/06/14.
//  Copyright (c) 2014 Alex Myakinkii. All rights reserved.
//

#import "CellView.h"

@implementation CellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.contentMode = UIViewContentModeRedraw;
        self.cellValue = -1;
    }
    return self;
}

- (void)setCellValue:(int)cellValue
{
    _cellValue = cellValue;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.cellValue >=0 || self.cellValue ==-8) {
        
//        [[UIColor whiteColor] setFill];
//        UIRectFill(self.bounds);
        CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        font = [font fontWithSize:[font pointSize] * self.bounds.size.width * 0.04];
        NSArray *colors=@[@"ffffff",@"0000ff",@"339900",@"ff0000",@"330099",@"993300",@"009999",@"993399",@"000000"];
        NSString *str = self.cellValue == -8? @"x":[NSString stringWithFormat:@"%d",self.cellValue];
        UIColor *color = self.cellValue == -8?[CellView colorWithHexString:@"000000"]:[CellView colorWithHexString:colors[self.cellValue]];
        NSAttributedString *valueString = [[NSAttributedString alloc] initWithString:str
                                                                          attributes:@{ NSFontAttributeName : font,
                                                                                        NSForegroundColorAttributeName:color}];
        CGSize textSize = [valueString size];
        CGPoint origin = CGPointMake(middle.x-textSize.width/2, middle.y-textSize.height/2);
        [valueString drawAtPoint:origin];
    } else {
        
        float shapeHeight=self.bounds.size.height;
        float shapeWidth=self.bounds.size.width;
        float padding = 2.5;
        
        UIBezierPath *shape = [UIBezierPath bezierPath];
        [shape moveToPoint:CGPointMake(padding, padding)];
        [shape addLineToPoint:CGPointMake(shapeWidth-padding, padding)];
        [shape addLineToPoint:CGPointMake(shapeWidth-padding, shapeHeight-padding)];
        [shape addLineToPoint:CGPointMake(padding, shapeHeight-padding)];
        [shape closePath];
        
//        [[UIColor blueColor] setStroke];
        [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] setStroke];
        [shape stroke];
        //self.backgroundColor = [CellView colorWithHexString:@"bbbbbb"] ;
        
    }
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    unsigned int hex;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hex];
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

@end

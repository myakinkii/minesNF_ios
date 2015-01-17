//
//  GameViewController.m
//  MinesNF
//
//  Created by Alex Myakinkii on 27/06/14.
//  Copyright (c) 2014 Alex Myakinkii. All rights reserved.
//

#import "GameViewController.h"
#import "CellView.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (strong, nonatomic) NSMutableArray *cellViews;
@property (nonatomic) double cellSize;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;


@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"TcpData" object:nil];
    
    self.cellSize = 32.0;
    
    for (int i=0; i<self.rows*self.cols; i++) {
        CellView *newView = [self createViewAtIndex:(int)[self.cellViews count]];
        [self.boardView addSubview:newView];
        [self.cellViews addObject:newView];
    }
    
}

- (void)viewDidLayoutSubviews
{
#warning "hardcoded screen resolution!"
    [self.boardView setFrame:CGRectMake((1024.0-self.cols*self.cellSize)/2,(768.0-100-self.rows*self.cellSize)/2,
                                        self.cols*self.cellSize,self.rows*self.cellSize)];
}

- (NSMutableArray *)cellViews
{
    if (!_cellViews)
        _cellViews = [[NSMutableArray alloc] init];
    return _cellViews;
}

- (CellView *)createViewAtIndex:(int)index
{
    double offset = 0.0;
    int column = index%self.cols;
    int row = index/self.cols;
    CGRect frame = CGRectMake(0, 0, self.cellSize, self.cellSize);
    frame.origin.x += column * (offset+self.cellSize);
    frame.origin.y += row * (offset+self.cellSize);
    frame.size = CGSizeMake(self.cellSize, self.cellSize);
    CellView *cellView = [[CellView alloc] initWithFrame:frame];
    [cellView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapCell:)]];
    return cellView;
}


- (void)handleNotification:(NSNotification *)note {
    
    NSDictionary *json=note.userInfo;
    NSString *func = json[@"func"];
    NSString *context = json[@"contextId"];
    
    if ([context isEqualToString:@"game"]) {
        if ([func isEqualToString:@"CellValues"])
            [self openCells:json[@"arg"] ];
        if ([func isEqualToString:@"OpenLog"])
            [self openLog:json[@"arg"]];
        if ([func isEqualToString:@"StartGame"])
            [self restart];
        if ([func isEqualToString:@"ShowResultRank"])
            [self showResult:json[@"arg"] mode:@"rank"];
        
    }
}

- (void)openLog:(NSDictionary *)cells {
    for (id time in cells)
        [self openCells:[cells objectForKey:time][@"cellsOpened"]];
}

- (void)openCells:(NSDictionary *)cells {
    for (NSString *s in cells) {
        NSArray *arr = [s componentsSeparatedByString:@"_"];
        int index = ([arr[2] integerValue]-1)*self.cols+[arr[1] integerValue]-1;
        CellView *cell = self.cellViews[index];
        cell.cellValue = [cells[s] integerValue];;
    }
}

- (void)showResult:(NSDictionary *)res mode:(NSString *)mode {
    if ([res[@"result"] isEqualToString:@"win"])
        self.resultLabel.text = [NSString stringWithFormat:@"current: %@s, best: %@s",res[@"time"],res[@"bestTime"]];
    else
        self.resultLabel.text = @"";
}

- (void)restart {
    for (CellView *cell in self.cellViews)
        cell.cellValue = -1;
}

- (void)tapCell:(UITapGestureRecognizer *)sender {
    int index = [self.cellViews indexOfObject:sender.view];
    index++;
    int row, col;
    if (index%self.cols==0) {
        row = index/self.cols;
        col = self.cols;
    } else {
        row = index/self.cols+1;
        col = index%self.cols;
    }
    NSString *command=[[NSString stringWithFormat:@"/check %d %d",col,row] stringByAppendingString:@"\n"];
    [[SingletonSocket getInstance] writeData:[command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.cellViews = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

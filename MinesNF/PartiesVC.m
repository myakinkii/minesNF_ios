//
//  PartiesVC.m
//  MinesNF
//
//  Created by Alex Myakinkii on 17/07/14.
//  Copyright (c) 2014 Alex Myakinkii. All rights reserved.
//

#import "PartiesVC.h"

@interface PartiesVC ()

@end

@implementation PartiesVC

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)addParty:(UIStoryboardSegue *)segue{
    //GameViewController *gameVC = (GameViewController *)segue.sourceViewController;
}

@end

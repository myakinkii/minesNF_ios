//
//  iPadMainViewController.m
//  MinesNF
//
//  Created by Alex Myakinkii on 14/06/14.
//  Copyright (c) 2014 Alex Myakinkii. All rights reserved.
//

#import "iPadMainViewController.h"
#import "GameViewController.h"

@interface iPadMainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *chat;
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (strong) UIPopoverController *popover;

@end

@implementation iPadMainViewController

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
    
    NSString *iamhash = [[NSUserDefaults standardUserDefaults] stringForKey:@"iamhash"]?[[NSUserDefaults standardUserDefaults] stringForKey:@"iamhash"]:@"";
    [[SingletonModel getInstance] setObject:iamhash forKey:@"iamhash"];
    
    NSString *iam = [NSString stringWithFormat:@"/iam %@\n",iamhash];
    [[SingletonSocket getInstance] writeData:[iam dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

- (IBAction)quitGame:(UIStoryboardSegue *)segue{
    [[SingletonSocket getInstance] writeData:[@"/quit\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

- (void)handleNotification:(NSNotification *)note {
    
    NSDictionary *json=note.userInfo;
    NSString *func = json[@"func"];
    NSString *context = json[@"contextId"];
    
//NSLog(@"from MainVC %@",json);
    
    if ([func isEqualToString:@"Message"]){
        if ([context isEqualToString:@"system"])
            [self showMessage:json[@"arg"]];
        if ([context isEqualToString:@"chat"])
            [self handleChatMessage:json[@"arg"]];
    }
    
    if ([func isEqualToString:@"IamHash"])
        [self handleIam:json];
    
    if ([func isEqualToString:@"StartGame"])
        [self startGame:json[@"arg"]];
    
}

- (void)startGame:(NSDictionary *)arg{
    if (![SingletonModel getInstance][@"inGame"]){
        [[SingletonModel getInstance] setObject:arg forKey:@"inGame"];
        [self performSegueWithIdentifier:@"StartGame" sender:nil];
     }
}

- (void)handleIam:(NSDictionary *)json{
    
    NSString *iamhash = json[@"arg"];
    [[NSUserDefaults standardUserDefaults] setObject:iamhash forKey:@"iamhash"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[SingletonModel getInstance] setObject:iamhash forKey:@"iamhash"];
    
    NSString *str= [NSString stringWithFormat:@"iam: %@, hash: %@",json[@"usr"],json[@"arg"]];
    [self showMessage:str];
}

- (void)handleChatMessage:(NSDictionary *)message{
    NSString *str= [NSString stringWithFormat:@"%@: %@",message[@"from"],message[@"text"]];
    [self showMessage:str];
}

- (void)showMessage:(NSString *)message{
    self.chat.text = [[NSString stringWithFormat:@"%@\n",message] stringByAppendingString:self.chat.text];
    self.chat.frame = CGRectMake(20,115,984,633);
    [self.chat sizeToFit];
}

- (IBAction)sendCommand:(id)sender {
    NSString *command=[self.input.text stringByAppendingString:@"\n"];
    [[SingletonSocket getInstance] writeData:[command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    self.input.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"QuickGame"]) {
        self.popover = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
    
    if ([segue.identifier isEqualToString:@"StartGame"]) {
        if (self.popover) [self.popover dismissPopoverAnimated:NO];
        GameViewController *gvc = [segue destinationViewController];
        gvc.cols = [[SingletonModel getInstance][@"inGame"][@"c"] integerValue];
        gvc.rows = [[SingletonModel getInstance][@"inGame"][@"r"] integerValue];
    }
}


@end

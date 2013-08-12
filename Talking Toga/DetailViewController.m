//
//  DetailViewController.m
//  Talking Toga
//
//  Created by SystemTOGA on 8/11/13.
//  Copyright (c) 2013 Yuta Toga. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    NSLog(@"きたよー");
    NSLog([self.detailItem description]);
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem objectForKey:@"name"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
// FIXME: change 2 to which row was pushed
    self.title = [self.detailItem objectForKey:@"voice"];
    UIImage *image = [UIImage imageNamed:[self.detailItem objectForKey:@"imageFileName"]];
    [self.talkImageView initWithImage:image];

    
    //FIXME: to more flexible
    //audio
    audioFileArray = [NSMutableArray array];
    [audioFileArray addObject:@"hai"];
    [audioFileArray addObject:@"kora"];
    [audioFileArray addObject:@"yabakunaisuka"];
    [audioFileArray addObject:@"nansuka"];
    
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)playButtonPushed:(id)sender {
    //player
    //avplayer
    NSString *path2 = [[NSBundle mainBundle] pathForResource:[audioFileArray objectAtIndex:self.which] ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path2];
    AVAudioPlayer *audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [player play];
}
@end

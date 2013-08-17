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
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem objectForKey:@"name"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    self.title = [self.detailItem objectForKey:@"voice"];
    UIImage *image = [UIImage imageNamed:[self.detailItem objectForKey:@"imageFileName"]];
    NSString *format = [[[self.detailItem objectForKey:@"imageFileName"] componentsSeparatedByString:@"."] lastObject];
    NSLog(format);
    playPattern = 0;
    if ([format isEqual: @"jpg"] || [format isEqual:@"png"] || [format isEqual:@"jpeg"] || [format isEqual:@"JPG"] || [format isEqual:@"JPEG"] || [format isEqual:@"PNG"]) {
        playPattern = 1;
        [self.talkImageView initWithImage:image];
    }else if ([format isEqual:@"mov"]){
        //動画再生
        playPattern = 2;
        moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[self.detailItem objectForKey:@"imageFileName"]]];
        moviePlayer.view.frame = CGRectMake(85, 20, 150, 200);
        moviePlayer.controlStyle = MPMovieControlStyleNone;
        [self.view addSubview:moviePlayer.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)playButtonPushed:(id)sender {
    //player
    switch (playPattern) {
        case 0:
            //do nothing
            break;
        case 1:
        {
            NSString *path2 = [[NSBundle mainBundle] pathForResource:[[self.detailItem objectForKey:@"audioFileName"] componentsSeparatedByString:@"."][0] ofType:[[self.detailItem objectForKey:@"audioFileName"] componentsSeparatedByString:@"."][1]];
            NSURL *url = [NSURL fileURLWithPath:path2];
            //    AVAudioPlayer *audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [player play];
        }
            break;
        case 2:
            moviePlayer.currentPlaybackTime = 0;
            [moviePlayer play];
            break;
        default:
            break;
    }
}

@end

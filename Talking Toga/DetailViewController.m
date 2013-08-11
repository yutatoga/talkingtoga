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
    self.title = [self.detailItem objectForKey:@"name"];
    
    NSData *dt = [NSData dataWithContentsOfURL:
                  [NSURL URLWithString:[self.detailItem objectForKey:@"photo"]]];
    UIImage *image = [[UIImage alloc] initWithData:dt];
    [self.talkImageView initWithImage:image];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

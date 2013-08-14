//
//  DetailViewController.h
//  Talking Toga
//
//  Created by SystemTOGA on 8/11/13.
//  Copyright (c) 2013 Yuta Toga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DetailViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate>{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    NSMutableArray *audioFileArray;
}

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, nonatomic) IBOutlet UIImageView *talkImageView;
- (IBAction)playButtonPushed:(id)sender;

@end

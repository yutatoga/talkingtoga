//
//  VoiceListTableViewController.h
//  Talking Toga
//
//  Created by SystemTOGA on 8/11/13.
//  Copyright (c) 2013 Yuta Toga. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VoiceListTableViewDelegate <NSObject>
- (void)updateUserDefaults:(int32_t)value;
@end

@interface VoiceListTableViewController : UITableViewController
@property (strong, nonatomic) id detailItem;
@property(weak, nonatomic) id<VoiceListTableViewDelegate> delegate;

@end

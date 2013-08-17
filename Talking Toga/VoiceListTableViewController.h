//
//  VoiceListTableViewController.h
//  Talking Toga
//
//  Created by SystemTOGA on 8/11/13.
//  Copyright (c) 2013 Yuta Toga. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol NextViewDelegate <NSObject>
//- (void)nextViewValueDidChanged:(int32_t)value;
//@end

@interface VoiceListTableViewController : UITableViewController
@property (strong, nonatomic) id detailItem;
//@property(weak, nonatomic) id<NextViewDelegate> delegate;

@end

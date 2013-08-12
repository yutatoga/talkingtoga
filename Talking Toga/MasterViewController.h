//
//  MasterViewController.h
//  Talking Toga
//
//  Created by SystemTOGA on 8/11/13.
//  Copyright (c) 2013 Yuta Toga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController{
    NSMutableDictionary *talkDict;
}
- (NSMutableDictionary*)createVoiceDict:(NSString *)voice
                                   name:(NSString *)name
                                belongs:(NSString *)belongs
                                address:(NSString *)address
                          photoFileName:(NSString *)photoFileName
                                  IDNum:(NSNumber *)IDNum;

@end

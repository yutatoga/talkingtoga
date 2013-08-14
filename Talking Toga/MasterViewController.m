//
//  MasterViewController.m
//  Talking Toga
//
//  Created by SystemTOGA on 8/11/13.
//  Copyright (c) 2013 Yuta Toga. All rights reserved.
//

#import "MasterViewController.h"

#import "VoiceListTableViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    
    NSMutableArray *voiceArray = [NSMutableArray array];
    
    NSMutableArray *voiceMutableArray = [NSArray arrayWithObjects:
                                         @"はーい",
                                         @"こら",
                                         @"やばくないすか",
                                         @"なんすか", nil];
    NSMutableArray *instantImageFileName = [NSArray arrayWithObjects:
                                         @"hai.jpg",
                                         @"kora.jpg",
                                         @"yabakunaisuka.jpg",
                                         @"nansuka.jpg", nil];
    
    NSString *instantName = @"James Toga";
    NSString *instantAddress = @"Tokyo";
    NSString *instantBelongs = @"Future Lab";
    
    for (int i = 0; i<voiceMutableArray.count; i++) {
        [voiceArray addObject:[self createVoiceDict:voiceMutableArray[i] name:instantName belongs:instantBelongs address:instantAddress imageFileName:instantImageFileName[i] IDNum:[NSNumber numberWithInt:i]]];
    }
    
    _objects = [NSMutableArray array];
    [_objects addObject:voiceArray];
}

- (NSMutableDictionary *)createVoiceDict:(NSString *)voice
                                name:(NSString *)name
                                belongs:(NSString *)belongs
                                address:(NSString *)address
                                imageFileName:(NSString *)imageFileName
                                   IDNum:(NSNumber *)IDNum{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:name forKey:@"name"];
    [dict setObject:belongs forKey:@"belongs"];
    [dict setObject:address forKey:@"address"];
    [dict setObject:imageFileName forKey:@"imageFileName"];
    [dict setObject:voice forKey:@"voice"];
    [dict setObject:IDNum forKey:@"IDNum"];
    
    return dict;
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSLog(@"foobar");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Please enter the title" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        someTextField = [alert textFieldAtIndex:0];
        someTextField.keyboardType = UIKeyboardTypeAlphabet;
        someTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        someTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //left button(cancel) was tapeed
            //do nothing
            break;
        case 1:
            //right button(done) was tapped
            //add cell which is named that user entered in alert view
            if (!_objects) {
                _objects = [[NSMutableArray alloc] init];
            }
//            NSMutableArray *voiceArray = [NSMutableArray array];
//            NSMutableArray *voiceMutableArray = [NSArray arrayWithObjects:
//                                                 @"はーい",
//                                                 @"こら",
//                                                 @"やばくないすか",
//                                                 @"なんすか", nil];
//            NSMutableArray *instantImageFileName = [NSArray arrayWithObjects:
//                                                    @"hai.jpg",
//                                                    @"kora.jpg",
//                                                    @"yabakunaisuka.jpg",
//                                                    @"nansuka.jpg", nil];
//            NSString *instantName = someTextField.text;
//            NSString *instantAddress = @"Tokyo";
//            NSString *instantBelongs = @"Future Lab";
//
//            for (int i = 0; i<voiceMutableArray.count; i++) {
//                [voiceArray addObject:[self createVoiceDict:voiceMutableArray[i] name:instantName belongs:instantBelongs address:instantAddress imageFileName:instantImageFileName[i] IDNum:[NSNumber numberWithInt:i]]];
//            }

            //now here
            NSMutableArray *newArray = [NSMutableArray array];
            NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
            [newDict setObject:someTextField.text forKey:@"name"];
            [newArray addObject:newDict];
            
            [_objects insertObject:newArray atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//
//    NSDate *object = _objects[indexPath.row];
//    NSLog([object description]);
//    cell.textLabel.text = [object description];
    cell.textLabel.text = [[_objects objectAtIndex:indexPath.row][0] objectForKey:@"name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        NSLog(@"foobar");
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showVoiceListTableView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *selectedDict = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:selectedDict];
    }
}

@end

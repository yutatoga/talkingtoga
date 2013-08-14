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
    NSMutableArray *imageFileNameArray = [NSArray arrayWithObjects:
                                         @"hai.jpg",
                                         @"kora.jpg",
                                         @"yabakunaisuka.jpg",
                                         @"nansuka.jpg", nil];
    
    NSMutableArray *audioFileNameArray = [NSMutableArray array];
    [audioFileNameArray addObject:@"hai.wav"];
    [audioFileNameArray addObject:@"kora.wav"];
    [audioFileNameArray addObject:@"yabakunaisuka.wav"];
    [audioFileNameArray addObject:@"nansuka.wav"];
    
    NSString *instantName = @"James Toga";    
    
    for (int i = 0; i<voiceMutableArray.count; i++) {
        [voiceArray addObject:[self createContentsDict:voiceMutableArray[i] name:instantName imageFileName:imageFileNameArray[i] audioFileName:audioFileNameArray[i] IDNum:[NSNumber numberWithInt:i]]];
    }
    _objects = [NSMutableArray array];
    
    NSMutableDictionary *dict = [self createOutlineDict:@"James Toga" contentsDictArray:voiceArray belongs:@"Future Lab" address:@"Tokyo" IDNum:[NSNumber numberWithInt:0]];
    [_objects addObject:dict];
}

- (NSMutableDictionary *)createContentsDict:(NSString *)voice
                                       name:(NSString *)name
                              imageFileName:(NSString *)imageFileName
                              audioFileName:(NSString *)audioFileName
                                      IDNum:(NSNumber *)IDNum{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:voice forKey:@"voice"];
    [dict setObject:name forKey:@"name"];
    [dict setObject:imageFileName forKey:@"imageFileName"];
    [dict setObject:audioFileName forKey:@"audioFileName"];
    [dict setObject:IDNum forKey:@"IDNum"];
    
    return dict;
}

- (NSMutableDictionary *)createOutlineDict:(NSString *)name
                         contentsDictArray:(NSMutableArray *)contsntsDictArray
                                   belongs:(NSString *)belongs
                                   address:(NSString *)address
                                     IDNum:(NSNumber *)IDNum{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:name forKey:@"name"];
    [dict setObject:contsntsDictArray forKey:@"contentsDictArray"];
    [dict setObject:belongs forKey:@"belongs"];
    [dict setObject:address forKey:@"address"];
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

            NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
            [newDict setObject:someTextField.text forKey:@"name"];
            [_objects insertObject:newDict atIndex:0];
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
    cell.textLabel.text = [[_objects objectAtIndex:indexPath.row] objectForKey:@"name"];
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

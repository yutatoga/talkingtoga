//
//  VoiceListTableViewController.m
//  Talking Toga
//
//  Created by SystemTOGA on 8/11/13.
//  Copyright (c) 2013 Yuta Toga. All rights reserved.
//

#import "VoiceListTableViewController.h"
#import "RecordViewController.h"
#import "DetailViewController.h"

@interface VoiceListTableViewController ()

@end

@implementation VoiceListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = [self.detailItem objectForKey:@"name"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.    
    return [[self.detailItem objectForKey:@"contentsDictArray"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    //逆順
    //cell.textLabel.text = [[[self.detailItem objectForKey:@"contentsDictArray"] objectAtIndex:[[self.detailItem objectForKey:@"contentsDictArray"] count]-indexPath.row-1]  objectForKey:@"voice"];
    cell.textLabel.text = [[[self.detailItem objectForKey:@"contentsDictArray"] objectAtIndex:indexPath.row] objectForKey:@"voice"];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog([[NSString stringWithFormat:@"%d", [self.tableView indexPathForSelectedRow].row] stringByAppendingFormat:@"番目が押されたよ"]);
    if ([[segue identifier] isEqualToString:@"showPlayView"]) {
        int touchRowNum = [self.tableView indexPathForSelectedRow].row;
        [[segue destinationViewController] setDetailItem:[[self.detailItem objectForKey:@"contentsDictArray"] objectAtIndex:touchRowNum]];
    }
    if ([[segue identifier] isEqualToString:@"showRecordView"]) {
        NSLog(@"recoooooooooooooooding!!!!");
        RecordViewController *rvc = [segue destinationViewController];
        rvc.delegate = (id<NextViewDelegate>)self;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear!!!!!!!!!!!!!!!!!!!!!!");
    [self.tableView reloadData];
}

- (void)nextViewValueDidChanged:(NSString *)voiceName savePath:(NSString *)savePath{
    NSLog(@"つながってます");
    //make dict
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:voiceName forKey:@"voice"];
    [dict setObject:[self.detailItem objectForKey:@"name"] forKey:@"name"];
    [dict setObject:savePath forKey:@"imageFileName"];
    [dict setObject:@"nansuka.wav" forKey:@"audioFileName"];
    [dict setObject:@"42" forKey:@"IDNum"];
    //add to array
    [[self.detailItem objectForKey:@"contentsDictArray"] addObject:dict];
    //default にも摘要
    NSLog(@"ここから");
    if ( [self.delegate respondsToSelector:@selector(updateUserDefaults:)] ) {
        //入力してもらったファイル名
        NSLog(@"うごいてる");
        [self.delegate updateUserDefaults:32];
    }
}

@end

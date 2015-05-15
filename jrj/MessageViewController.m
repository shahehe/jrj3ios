//
//  MessageViewController.m
//  financialDistrict
//
//  Created by USTB on 13-5-2.
//  Copyright (c) 2013年 USTB. All rights reserved.
//

#import "MessageViewController.h"
#import "ApiService.h"

@interface MessageViewController (){
    NSArray *msgArray;
    int credit;
}

@end

@implementation MessageViewController
@synthesize msgString;

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
    self.navigationItem.title = @"个人消息列表";
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.tableView.backgroundView = [[UIView alloc]init];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
    
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    [self getMessageArray];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) getMessageArray{
    //parsing msg String
    if(msgString != nil){
        NSDictionary *outputDic = [[NSDictionary alloc] init];
        
        NSData *jsonData = [msgString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        if(jsonObject != nil && error == nil){
            if([jsonObject isKindOfClass:[NSDictionary class]]){
                outputDic = (NSDictionary *)jsonObject;
            }
        }
        
        msgArray = [outputDic objectForKey:@"data"];
        //NSLog(@"--------%@",[msgArray[0] objectForKey:@"message"]);
        
    }
}


- (void)viewWillAppear:(BOOL)animated{
    //get the credit
    NSMutableURLRequest *creditRequest = [[NSMutableURLRequest alloc] init];
    NSString *creditUrl =[NSString stringWithFormat:@"http://%@/jrj/credit.php?uid=%d",[ApiService sharedInstance].host,[ApiService sharedInstance].userID];
    
    [creditRequest setURL:[NSURL URLWithString:creditUrl]];
    [creditRequest setHTTPMethod:@"GET"];
    
    NSData *creditReturnData = [NSURLConnection sendSynchronousRequest:creditRequest returningResponse:nil error:nil];
    NSString *creditReturnString = [[NSString alloc] initWithData:creditReturnData encoding:NSUTF8StringEncoding];
    credit = [MessageViewController extractCredit:creditReturnString];
    
}


+ (int) extractCredit:(NSString *)returnString{
    //parsing
    if(returnString != nil){
        NSDictionary *outputDic = [[NSDictionary alloc] init];
        
        NSData *jsonData = [returnString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        if(jsonObject != nil && error == nil){
            if([jsonObject isKindOfClass:[NSDictionary class]]){
                outputDic = (NSDictionary *)jsonObject;
            }
        }
        
        return [[outputDic objectForKey:@"credit"] intValue];
    }
    else return (-1);
    
}

-(void)refreshTable{
    
    //set the title while refreshing
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing the TableView"];
    //set the date and time of refreshing
    NSDateFormatter *formattedDate = [[NSDateFormatter alloc]init];
    [formattedDate setDateFormat:@"MMM d, h:mm a"];
    NSString *lastupdated = [NSString stringWithFormat:@"Last Updated on %@",[formattedDate stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:lastupdated];
    
    //refreshing content    
    NSMutableURLRequest *msgRequest = [[NSMutableURLRequest alloc] init];
    NSString *msgUrl =[NSString stringWithFormat:@"http://%@/jrj/message.php?uid=%d",[ApiService sharedInstance].host,[ApiService sharedInstance].userID];
    
    [msgRequest setURL:[NSURL URLWithString:msgUrl]];
    [msgRequest setHTTPMethod:@"POST"];
    
    NSData *msgReturnData = [NSURLConnection sendSynchronousRequest:msgRequest returningResponse:nil error:nil];
    NSString *msgReturnString = [[NSString alloc] initWithData:msgReturnData encoding:NSUTF8StringEncoding];

    msgString = msgReturnString;
    [self getMessageArray];
    
    NSMutableURLRequest *creditRequest = [[NSMutableURLRequest alloc] init];
    NSString *creditUrl =[NSString stringWithFormat:@"http://%@/jrj/credit.php?uid=%d",[ApiService sharedInstance].host,[ApiService sharedInstance].userID];
    
    [creditRequest setURL:[NSURL URLWithString:creditUrl]];
    [creditRequest setHTTPMethod:@"GET"];
    
    NSData *creditReturnData = [NSURLConnection sendSynchronousRequest:creditRequest returningResponse:nil error:nil];
    NSString *creditReturnString = [[NSString alloc] initWithData:creditReturnData encoding:NSUTF8StringEncoding];
    credit = [MessageViewController extractCredit:creditReturnString];
    [self.tableView reloadData];  
    
    //end the refreshing
    [self.refreshControl endRefreshing];
    
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
//    if (section == 1){
        return [msgArray count];
//    }
//    else return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section == 1){
        return 90;
//    }
//    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"msgCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
//    if(indexPath.section == 0){
//        cell.textLabel.text = [NSString stringWithFormat:@"您目前的积分为: %d",credit];
//        cell.detailTextLabel.text = @"";
//        cell.textLabel.textColor = [UIColor orangeColor];
//        
//    }
//    else{
    
    // Configure the cell...
        cell.textLabel.text = [msgArray[[indexPath row]] objectForKey:@"message"];
        cell.detailTextLabel.text = [msgArray[[indexPath row]] objectForKey:@"create_time"];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
        cell.textLabel.textColor = [UIColor blackColor];
//    }
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

@end

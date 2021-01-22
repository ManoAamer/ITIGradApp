//
//  DetailsTableViewController.m
//  ITI Project
//
//  Created by Asmaa mohamed on 9/9/18.
//  Copyright © 2018 Abdul Rahman Aamer. All rights reserved.
//

#import "DetailsTableViewController.h"

@interface DetailsTableViewController ()
{
   
}

@end

@implementation DetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString* myNewString = [NSString stringWithFormat:@"%@", _theMovieID];
    NSString* detailsURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=d48734565398d23abd30a6ec3a333ec2&language=en-US", myNewString];
    NSString* trailersURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=d48734565398d23abd30a6ec3a333ec2&language=en-US", myNewString];
    NSString* reviewsURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/reviews?api_key=d48734565398d23abd30a6ec3a333ec2&language=en-US", myNewString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET: detailsURL
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             NSMutableString * imgID = [NSMutableString new];
             [imgID appendString:@"http://image.tmdb.org/t/p/w185/"];
             [imgID appendString:[responseObject valueForKey:@"poster_path"]];
             [_movieImage sd_setImageWithURL:[NSURL URLWithString:imgID] placeholderImage:[UIImage imageNamed:[responseObject objectForKey:@"poster_path"]]];
             _releaseDate.text = [responseObject valueForKey:@"release_date"];
             NSString * runTime = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"runtime"]];
             _duration.text = [runTime stringByAppendingString:@" Minutes"];
             NSString * movieRate = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"vote_average"]];
             _rate.text = [movieRate stringByAppendingString:@"/10"];
             _movietitle.text = [responseObject valueForKey:@"original_title"];
//             _overView.text = [responseObject valueForKey:@"overview"];
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
    AFHTTPSessionManager *trailers = [AFHTTPSessionManager manager];
    trailers.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET: trailersURL
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             self.trailerNames = [responseObject valueForKeyPath:@"results.name"];
             self.trailerPath = [responseObject valueForKeyPath:@"results.key"];
             [self.tableView reloadData];
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
    
    AFHTTPSessionManager *reviews = [AFHTTPSessionManager manager];
    reviews.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET: reviewsURL
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             self.reviewer = [responseObject valueForKeyPath:@"results.author"];
             self.theReview = [responseObject valueForKeyPath:@"results.content"];
             
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trailerscell" forIndexPath:indexPath];
    
//    if ([tableView isEqual:_trailersCell]){
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trailers" forIndexPath:indexPath];
    
        UIImageView * myImage = [cell viewWithTag:31];
        UILabel * myLabel = [cell viewWithTag:32];
        myLabel.text = [_trailerNames objectAtIndex:indexPath.row];
        NSString * imgID = [NSMutableString new];
        imgID = [NSString stringWithFormat:@"https://img.youtube.com/vi/%@/default.jpg",[self.trailerPath objectAtIndex:indexPath.row]];
        [myImage sd_setImageWithURL:[NSURL URLWithString:imgID] placeholderImage:[UIImage imageNamed:[self.trailerPath objectAtIndex:indexPath.row]]];
//        return cell;
//    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//
//- (IBAction)favAction:(id)sender {
//    NSArray *path =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentspath  = [path objectAtIndex:0];
//    NSString *plistpath =[documentspath stringByAppendingPathComponent:@"myPlist.plist"];
//    [self.movieId1 addObject:self.theMovieID];
//   // NSDictionary *plistdict =[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:self.movieId1, nil] forKeys:[NSArray arrayWithObjects:@"movieId", nil]];
//    NSDictionary *plistdict =[[NSDictionary alloc] initWithObjectsAndKeys:_movieId1, nil];
//    NSError *error= nil;
//    NSData *plistData=[NSPropertyListSerialization dataFromPropertyList:plistdict format:NSPropertyListXMLFormat_v1_0  errorDescription:&error];
//    if(plistData)
//    {
//        [plistData writeToFile:plistpath atomically:YES];
//        printf("Done");
//    }
//    else{
//        printf("Fail");
//    }
//}
@end

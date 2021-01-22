//
//  MovieDetails.m
//  ITI Project
//
//  Created by Abdul Rahman Aamer on 02/09/2018.
//  Copyright © 2018 Abdul Rahman Aamer. All rights reserved.
//

#import "MovieDetails.h"
#import "CollectionViewController.h"

@interface MovieDetails (){
    NSDictionary * response;
    int flagForDB;
    NSString *docsDir;
    NSArray *dirPaths;
}

@end

@implementation MovieDetails
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    /*self.imageWidth.constant = [[UIScreen mainScreen] bounds].size.width/2;
    self.imageHeight.constant = self.imageWidth.constant * 1.5;

    self.buttonHeight8.constant = self.imageHeight.constant / 7;
    self.buttonHeight9.constant = self.imageHeight.constant / 7;
    self.buttonHeight10.constant = self.imageHeight.constant / 7;
    */
    
    self.favouriteWidth.constant = [[UIScreen mainScreen] bounds].size.width/10;
    self.favouriteHeight.constant = [[UIScreen mainScreen] bounds].size.width/10;


    
    /*
    if (UIDevice.currentDevice.orientation == UIDeviceOrientationLandscapeLeft) {

        self.favouriteConstraint1.constant = [[UIScreen mainScreen] bounds].size.height/5;
        self.favouriteConstraint2.constant = [[UIScreen mainScreen] bounds].size.height/5;
    } else if (UIDevice.currentDevice.orientation == UIDeviceOrientationLandscapeRight) {
        self.favouriteWidth.constant = [[UIScreen mainScreen] bounds].size.height/10;
        self.favouriteHeight.constant = [[UIScreen mainScreen] bounds].size.height/10;
    } else if (UIDevice.currentDevice.orientation == UIDeviceOrientationPortrait) {
        self.favouriteWidth.constant = [[UIScreen mainScreen] bounds].size.width/10;
        self.favouriteHeight.constant = [[UIScreen mainScreen] bounds].size.width/10;
    }
    */
    
    UIActivityIndicatorView *spinner;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2)]; // I do this because I'm in landscape mode
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"contacts.db"]];
    
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt =
        "CREATE TABLE IF NOT EXISTS CONTACTS ( IDS TEXT,pics text)";
        
        if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table");
        }
        sqlite3_close(_contactDB);
    } else {
        printf("Failed to open/create database");
    }
    
    [_scrollView setScrollEnabled:YES];
    CGRect scrollView;
    [_scrollView setContentSize:CGSizeMake(375,1050)];
    
    scrollView.origin = _scrollView.frame.origin;
    scrollView.size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    _scrollView.frame = scrollView;

    [_trailersTable setDelegate:self];
    [_trailersTable setDataSource:self];

    [_reviewsTable setDelegate:self];
    [_reviewsTable setDataSource:self];

    
    NSString* myNewString = [NSString stringWithFormat:@"%@", _theMovieID];
    NSString* detailsURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=d48734565398d23abd30a6ec3a333ec2&language=en-US", myNewString];
    NSString* trailersURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=d48734565398d23abd30a6ec3a333ec2&language=en-US", myNewString];
    NSString* reviewsURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/reviews?api_key=d48734565398d23abd30a6ec3a333ec2&language=en-US", myNewString];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET: detailsURL
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             response = [NSDictionary new];
             response = responseObject;
//            _imgID = [NSMutableString new];
//             [_imgID appendString:@"http://image.tmdb.org/t/p/w185/"];
//             [_imgID appendString:[responseObject valueForKey:@"poster_path"]];
//             [self.posterImage sd_setImageWithURL:[NSURL URLWithString:_imgID] placeholderImage:[UIImage imageNamed:[responseObject objectForKey:@"poster_path"]]];
//             self.productionYear.text = [responseObject valueForKey:@"release_date"];
//             NSString * runTime = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"runtime"]];
//             self.duration.text = [runTime stringByAppendingString:@" Minutes"];
//             NSString *fullString = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"vote_average"]];;
//             NSString *prefix;
//
//             if ([fullString length] >= 3)
//                 prefix = [fullString substringToIndex:3];
//             else
//                 prefix = fullString;
//             NSString * movieRate = [NSString stringWithFormat:@"%@",prefix];
//             self.movieRate.text = [movieRate stringByAppendingString:@"/10"];
//             self.moviePlot.text = [responseObject valueForKey:@"overview"];
//             self.movieName.text = [responseObject valueForKey:@"original_title"];

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
             self.trailersTableHeight.constant = 67*[self.trailerPath count];
             [self.trailersTable reloadData];
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
             
             self.reviewsTableHeight.constant = 7000;
             _reviewsTable.frame = CGRectMake(_reviewsTable.frame.origin.x, _reviewsTable.frame.origin.y, _reviewsTable.frame.size.width, 7000);
             [self.reviewsTable reloadData];
              CGFloat heightoftable = 0.0;
             for (int i = 0; i<[self.reviewsTable.visibleCells count]; i++) {
                 heightoftable += [self.reviewsTable.visibleCells objectAtIndex:i].frame.size.height;
             }
             self.reviewsTableHeight.constant = heightoftable;
             _imgID = [NSMutableString new];
             [_imgID appendString:@"http://image.tmdb.org/t/p/w185/"];
             [_imgID appendString:[response valueForKey:@"poster_path"]];
             [self.posterImage sd_setImageWithURL:[NSURL URLWithString:_imgID] placeholderImage:[UIImage imageNamed:[response objectForKey:@"poster_path"]]];
             self.productionYear.text = [response valueForKey:@"release_date"];
             NSString * runTime = [NSString stringWithFormat:@"%@",[response valueForKey:@"runtime"]];
             self.duration.text = [runTime stringByAppendingString:@" Minutes"];
             NSString *fullString = [NSString stringWithFormat:@"%@",[response valueForKey:@"vote_average"]];;
             NSString *prefix;
             
             if ([fullString length] >= 3)
                 prefix = [fullString substringToIndex:3];
             else
                 prefix = fullString;
             NSString * movieRate = [NSString stringWithFormat:@"%@",prefix];
             self.movieRate.text = [movieRate stringByAppendingString:@"/10"];
             self.moviePlot.text = [response valueForKey:@"overview"];
             self.movieName.text = [response valueForKey:@"original_title"];
             self.moviePlot.textColor = [UIColor whiteColor];
             [spinner stopAnimating];
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
   /*
    [[self productionYear] setFont:[UIFont boldSystemFontOfSize:[[UIScreen mainScreen] bounds].size.width / 18.75]];
    [[self duration] setFont:[UIFont systemFontOfSize:[[UIScreen mainScreen] bounds].size.width / 18.75]];
    [[self movieRate] setFont:[UIFont systemFontOfSize:[[UIScreen mainScreen] bounds].size.width / 18.75]];
    [[self moviePlot] setFont:[UIFont systemFontOfSize:[[UIScreen mainScreen] bounds].size.width / 18.75]];
    [[self movieName] setFont:[UIFont systemFontOfSize:[[UIScreen mainScreen] bounds].size.width / 9]];
    [[self overViewLabel] setFont:[UIFont systemFontOfSize:[[UIScreen mainScreen] bounds].size.width / 22]];
    [[self releaseDateLabel] setFont:[UIFont systemFontOfSize:[[UIScreen mainScreen] bounds].size.width / 22]];
    [[self durationLabel] setFont:[UIFont systemFontOfSize:[[UIScreen mainScreen] bounds].size.width / 22]];
    [[self rateLabel] setFont:[UIFont systemFontOfSize:[[UIScreen mainScreen] bounds].size.width / 22]];
    [[self trailersLabel] setFont:[UIFont systemFontOfSize:[[UIScreen mainScreen] bounds].size.width / 22]];
    [[self reviewsLabel] setFont:[UIFont systemFontOfSize:[[UIScreen mainScreen] bounds].size.width / 22]];
    [[self favouriteLabel] setFont:[UIFont systemFontOfSize:[[UIScreen mainScreen] bounds].size.width / 22]];
*/
    [_favouriteLabel setImage:[UIImage imageNamed:@"thumb-up-icon.png"] forState:UIControlStateNormal];
    self.reviewsTable.estimatedRowHeight = 300;
    _reviewsTable.rowHeight = UITableViewAutomaticDimension;
    self.trailersTable.estimatedRowHeight = 167;
    
}

-(void)viewDidAppear:(BOOL)animated{

//    _reviewsTable.estimatedRowHeight = 44.0;
//    _reviewsTable.rowHeight = UITableViewAutomaticDimension;
//    self.reviewsTableHeight.constant = _reviewsTable.rowHeight*[_reviewer count];
/*
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = self.reviewsTable.frame;
        frame.size.height = self.reviewsTable.contentSize.height;
        self.reviewsTable.frame = frame;
        self.reviewsTableHeight.constant = frame.size.height;
    });
    */
}




-(void)viewWillAppear:(BOOL)animated{
    
    
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM contacts where ids = \"%@\" ",_theMovieID];
        
        //printf("here");
        
        const char *query_stmt = [querySQL UTF8String];
        //NSLog(@"%s",query_stmt);
        if (sqlite3_prepare_v2(_contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //printf("here2");
            while(sqlite3_step(statement) == SQLITE_ROW){
                
                _idString = [[NSMutableString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                [_idArray addObject:_idString];
                
                printf("Match found\n");
                flagForDB = 1;
            }
            sqlite3_finalize(statement);
        }else{
            printf("Match not found\n");
            flagForDB = 0;
        }
        sqlite3_close(_contactDB);
    }
    
    
    if(flagForDB == 1){
        _favouriteLabel.tintColor = [UIColor redColor];
        
    }
    else{
        _favouriteLabel.tintColor = [UIColor whiteColor];

    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _trailersTable){
        return [_trailerNames count];
    }
    else{
        return [_reviewer count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _trailersTable){
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trailers" forIndexPath:indexPath];
    UIImageView * myImage = [cell viewWithTag:21];
    UILabel * myLabel = [cell viewWithTag:22];
    myLabel.text = [_trailerNames objectAtIndex:indexPath.row];
    NSString * imgID = [NSMutableString new];
    imgID = [NSString stringWithFormat:@"https://img.youtube.com/vi/%@/default.jpg",[self.trailerPath objectAtIndex:indexPath.row]];
    [myImage sd_setImageWithURL:[NSURL URLWithString:imgID] placeholderImage:[UIImage imageNamed:[self.trailerPath objectAtIndex:indexPath.row]]];
            return cell;
        }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reviews" forIndexPath:indexPath];
    UILabel * reviewer = [cell viewWithTag:23];
    UILabel * review = [cell viewWithTag:24];
    reviewer.text = [_reviewer objectAtIndex:indexPath.row];
    review.text = [_theReview objectAtIndex:indexPath.row];
    
        return cell;}
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _trailersTable){
//        NSString *string = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", [_trailerPath objectAtIndex:indexPath.row]];
//        NSURL *url = [NSURL URLWithString:string];
//        UIApplication *app = [UIApplication sharedApplication];
//        [app openURL:url];
        NSURL *linkToAppURL = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://watch?v=%@",[_trailerPath objectAtIndex:indexPath.row]]];
        NSURL *linkToWebURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",[_trailerPath objectAtIndex:indexPath.row]]];
        
        if ([[UIApplication sharedApplication] canOpenURL:linkToAppURL]) {
            // Can open the youtube app URL so launch the youTube app with this URL
            [[UIApplication sharedApplication] openURL:linkToAppURL];
        }
        else{
            // Can't open the youtube app URL so launch Safari instead
            [[UIApplication sharedApplication] openURL:linkToWebURL];
        }
    }
}
/*
-(CGFloat)tableView:(UITableView *)trailersTable heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //tableView = _trailersTable;
        return 67;
}
*/



- (IBAction)favouriteAction:(id)sender {
    NSLog(@"sshshsh");
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"contacts.db"]];
    
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM contacts where ids = \"%@\" ",_theMovieID];
        
        //printf("here");
        
        const char *query_stmt = [querySQL UTF8String];
        //NSLog(@"%s",query_stmt);
        if (sqlite3_prepare_v2(_contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //printf("here2");
            while(sqlite3_step(statement) == SQLITE_ROW){
                
                _idString = [[NSMutableString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                [_idArray addObject:_idString];
                
                printf("Match found\n");
                flagForDB = 1;
            }
            sqlite3_finalize(statement);
        }else{
            printf("Match not found\n");
            flagForDB = 0;
        }
        sqlite3_close(_contactDB);
    }
    
    
    
    
    if(flagForDB == 0){
        _favouriteLabel.tintColor = [UIColor redColor];
        sqlite3_stmt    *statement;
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO CONTACTS (pics, ids  ) VALUES (\"%@\", \"%@\")",
                                   _imgID , _theMovieID];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_contactDB, insert_stmt,
                               -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                printf("movie is added\n");
            } else {
                printf("movie is not added\n");
            }
            sqlite3_finalize(statement);
            sqlite3_close(_contactDB);
            flagForDB = 1;
        }
    }else{
        _favouriteLabel.tintColor = [UIColor whiteColor];

        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        docsDir = dirPaths[0];
        _databasePath = [[NSString alloc]
                         initWithString: [docsDir stringByAppendingPathComponent:
                                          @"contacts.db"]];
        
        sqlite3_stmt    *statement;
        
        const char *dbpath = [_databasePath UTF8String];
        
        
        int rc;
        
        rc = sqlite3_open( dbpath, &_contactDB );
        
        if ( rc )
        {
            sqlite3_close(_contactDB);
        }
        else //Database connection opened successfuly
        {
            //char *zErrMsg = 0;
            
            // rc = sqlite3_exec( _contactDB, "DELETE name, pics, ids , overview , avgrate, releasedate FROM contacts where ids = \"%@\"", _movieId , NULL ,NULL ,zErrMsg);
            
            NSString *delete =  [NSString stringWithFormat:
                                 @"Delete from CONTACTS where ids=\"%@\"",
                                 _theMovieID];
            const char *del = [delete UTF8String];
            sqlite3_prepare_v2(_contactDB, del,
                               -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                printf("movie is deleted\n");
            }else {
                printf("movie is not deleted\n");
            }
            sqlite3_finalize(statement);
            sqlite3_close(_contactDB);
            flagForDB = 0;
        }
        
        
    }

}
@end

//
//  MovieDetails.h
//  ITI Project
//
//  Created by Abdul Rahman Aamer on 02/09/2018.
//  Copyright © 2018 Abdul Rahman Aamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPSessionManager.h"
#import <sqlite3.h>

@interface MovieDetails : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property (strong , nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactDB;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *productionYear;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *movieRate;
@property (weak, nonatomic) IBOutlet UILabel *moviePlot;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UITableView *trailersTable;
@property (weak, nonatomic) IBOutlet UITableView *reviewsTable;


@property (weak, nonatomic) IBOutlet UILabel *overViewLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *trailersLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewsLabel;
- (IBAction)favouriteAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *favouriteLabel;



@property NSString *theMovieID;
@property NSMutableArray *trailerNames;
@property NSMutableArray *trailerPath;
@property NSMutableArray *reviewer;
@property NSMutableArray *theReview;
@property NSString *idString;
@property NSMutableArray *idArray;
@property NSMutableString * imgID;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailersTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewsTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favouriteConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favouriteConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favouriteWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favouriteHeight;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight9;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight10;


@end

//
//  DetailsTableViewController.h
//  ITI Project
//
//  Created by Asmaa mohamed on 9/9/18.
//  Copyright © 2018 Abdul Rahman Aamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPSessionManager.h"


@interface DetailsTableViewController : UITableViewController
- (IBAction)favAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *movietitle;

@property (weak, nonatomic) IBOutlet UILabel *releaseDate;

@property (weak, nonatomic) IBOutlet UIImageView *movieImage;

@property (weak, nonatomic) IBOutlet UILabel *duration;

@property (weak, nonatomic) IBOutlet UILabel *rate;

@property (weak, nonatomic) IBOutlet UITableViewCell *trailersCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *reviewsCell;


@property NSString *theMovieID;
@property NSMutableArray *trailerNames;
@property NSMutableArray *trailerPath;
@property NSMutableArray *reviewer;
@property NSMutableArray *theReview;
@property NSMutableArray *movieId1;

@end

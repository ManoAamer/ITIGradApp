//
//  FavouritesViewController.h
//  ITI Project
//
//  Created by Asmaa mohamed on 9/7/18.
//  Copyright © 2018 Abdul Rahman Aamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <sqlite3.h>

@interface FavouritesViewController : UICollectionViewController


@property (strong, nonatomic) NSString *databasePath;
@property ( nonatomic) sqlite3 *contactDB ;


@property NSString *theMovieID;
@property NSString *posterPath;

@property NSMutableArray *poster_path;
@property NSMutableArray *ids;


@end

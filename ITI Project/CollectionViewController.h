//
//  CollectionViewController.h
//  ITI Project
//
//  Created by Asmaa mohamed on 9/7/18.
//  Copyright © 2018 Abdul Rahman Aamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MovieDetails.h"

@interface CollectionViewController : UICollectionViewController <UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, UISearchBarDelegate , UISearchControllerDelegate>

@property NSMutableArray *movieIDS;
@property NSMutableArray *moviePosters;
@property NSMutableArray *topRatedIDS;
@property NSMutableArray *topRatedPosters;
@property NSMutableArray *popularIDS;
@property NSMutableArray *popularPosters;
@property NSString *movieID;
@property UIBarButtonItem *sort;
@property UIBarButtonItem *sortAgain;

@property UISearchBarIcon *searchbar;

@property int sortOperator;
@property int topRatedPageNum;
@property int mostPopularPageNum;

@property(assign, nonatomic) CGFloat currentOffset;

@end

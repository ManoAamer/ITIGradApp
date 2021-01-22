//
//  FavouritesViewController.m
//  ITI Project
//
//  Created by Asmaa mohamed on 9/7/18.
//  Copyright © 2018 Abdul Rahman Aamer. All rights reserved.
//

#import "FavouritesViewController.h"
#import "MovieDetails.h"
#import "CollectionViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FavouritesViewController ()
{
    NSString *pic;
    NSString *idS;
    
}

@end

@implementation FavouritesViewController

static NSString * const reuseIdentifier = @"favCell";

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated{
    
    _ids = [NSMutableArray new];
    _poster_path = [NSMutableArray new];
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"contacts.db"]];
    
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        // NSString *ids = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
        //NSLog(@"%@",ids);
        NSString *querySQL = [NSString stringWithFormat:@"SELECT pics , ids FROM contacts"];
        
        //printf("here");
        
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"%s",query_stmt);
        if (sqlite3_prepare_v2(_contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //printf("here2");
            _poster_path= [NSMutableArray new];
            
            while(sqlite3_step(statement) == SQLITE_ROW){
                
                pic = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                [_poster_path addObject:pic];
                NSLog(@"inside database %@", _poster_path );
                
                idS = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                [_ids addObject:idS];
                
                
                printf("Match found");
            }
            sqlite3_finalize(statement);
        }else{
            printf("Match not found");
        }
        sqlite3_close(_contactDB);
    }
    
    [self.collectionView reloadData];
    
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_poster_path count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"favCell" forIndexPath:indexPath];
    
    UIImageView * myImage2 = [cell viewWithTag:87];
    //    NSLog(@"%@",_poster_path);
    //    NSString *image23 = [NSString stringWithFormat:@"%@", [_poster_path objectAtIndex:0]];
    //    NSLog(@"%@",image23);
    [myImage2 sd_setImageWithURL:[NSURL URLWithString:[_poster_path objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"123.jpg"]];
    
    
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = [[UIScreen mainScreen] bounds].size.width/2;
    CGFloat cellHeight = cellWidth*1.5;
    return CGSizeMake(cellWidth, cellHeight);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieDetails *obj2 = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieDetails"];
    NSLog(@"hhhhhhhh");
    [self.navigationController pushViewController:obj2 animated:YES];
    _theMovieID = [_ids objectAtIndex:indexPath.row];
    NSLog(@"%@",[_ids objectAtIndex:indexPath.row]);
    obj2.theMovieID = _theMovieID;
}


@end

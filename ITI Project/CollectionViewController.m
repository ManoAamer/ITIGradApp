//
//  CollectionViewController.m
//  ITI Project
//
//  Created by Asmaa mohamed on 9/7/18.
//  Copyright © 2018 Abdul Rahman Aamer. All rights reserved.
//

#import "CollectionViewController.h"
//#import "popOverViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topRatedPageNum = 2;
    self.mostPopularPageNum = 2;
    self.sortOperator = 1;
    
    self.sort = [[UIBarButtonItem alloc] initWithTitle:@"Sort: Popular" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    NSUInteger fontSize = 15;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    [self.sort setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.sort.tintColor = [UIColor darkTextColor];
    [self.navigationItem setRightBarButtonItem:self.sort];
    
    self.sortAgain = [[UIBarButtonItem alloc] initWithTitle:@"Sort: TopRated" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    self.sortAgain.tintColor = [UIColor darkTextColor];
    [self.sortAgain setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:self.sortAgain];
    
    self.movieIDS = [NSMutableArray new];
    self.moviePosters = [NSMutableArray new];
    self.topRatedIDS = [NSMutableArray new];
    self.topRatedPosters = [NSMutableArray new];
    self.popularIDS = [NSMutableArray new];
    self.popularPosters = [NSMutableArray new];
    
    
    NSString *url = @"https://api.themoviedb.org/3/movie/popular?api_key=d48734565398d23abd30a6ec3a333ec2&language=en-US";
    
    AFHTTPSessionManager *popular = [AFHTTPSessionManager manager];
    popular.requestSerializer = [AFJSONRequestSerializer serializer];
    [popular GET: url
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             /*self.movieIDS = [responseObject valueForKeyPath:@"results.id"];
             self.moviePosters = [responseObject valueForKeyPath:@"results.poster_path"];*/
             NSArray *movies = [responseObject valueForKeyPath:@"results.id"];
             [self.popularIDS addObjectsFromArray:movies];
            _movieIDS = _popularIDS;
             NSArray *posters = [responseObject valueForKeyPath:@"results.poster_path"];
             [self.popularPosters addObjectsFromArray:posters];
             _moviePosters = _popularPosters;
             [self.collectionView reloadData];
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    // Do any additional setup after loading the view.

    
    

    AFHTTPSessionManager *toprated = [AFHTTPSessionManager manager];
    toprated.requestSerializer = [AFJSONRequestSerializer serializer];
    [toprated GET: @"https://api.themoviedb.org/3/movie/top_rated?api_key=d48734565398d23abd30a6ec3a333ec2&language=en-US&page=1"
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             /*self.movieIDS = [responseObject valueForKeyPath:@"results.id"];
              self.moviePosters = [responseObject valueForKeyPath:@"results.poster_path"];*/
             NSArray *movies = [responseObject valueForKeyPath:@"results.id"];
             [self.topRatedIDS addObjectsFromArray:movies];
             //_movieIDS = _topRatedIDS;
             NSArray *posters = [responseObject valueForKeyPath:@"results.poster_path"];
             [self.topRatedPosters addObjectsFromArray:posters];
             //_moviePosters = _topRatedPosters;
             //[self.collectionView reloadData];
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];

// Do any additional setup after loading the view.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.moviePosters count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIActivityIndicatorView *spinner;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(cell.frame.size.width /2, cell.frame.size.height / 2)]; // I do this because I'm in landscape mode
    [cell addSubview:spinner];
    [spinner startAnimating];
    
    UIImageView * myImage = [cell viewWithTag:2];
    NSMutableString * imgID = [NSMutableString new];
    [imgID appendString:@"http://image.tmdb.org/t/p/w185/"];
    [imgID appendString:[self.moviePosters objectAtIndex:indexPath.row]];
    [myImage sd_setImageWithURL:[NSURL URLWithString:imgID] placeholderImage:[UIImage imageNamed:[self.moviePosters objectAtIndex:indexPath.row]]];
    [spinner stopAnimating];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = [[UIScreen mainScreen] bounds].size.width/2;
    CGFloat cellHeight = cellWidth*1.5;
    return CGSizeMake(cellWidth, cellHeight);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieDetails *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieDetails"];
    [self.navigationController pushViewController:obj animated:YES];
    self.movieID = [_movieIDS objectAtIndex:indexPath.row];
    obj.theMovieID = self.movieID;
}


-(void)rightAction{
        _movieIDS = _popularIDS;
        _moviePosters = _popularPosters;
        _sortOperator = 1;
        [self.collectionView performBatchUpdates:^{[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];} completion:nil];
        CGFloat end = self.navigationController.navigationBar.frame.size.height;
    [self.collectionView setContentOffset:CGPointMake(0, -end) animated:NO];
}


-(void)leftAction{
    _movieIDS = _topRatedIDS;
    _moviePosters = _topRatedPosters;
    [self.collectionView performBatchUpdates:^{[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];} completion:nil];
    _sortOperator = 2;
    CGFloat end = self.navigationController.navigationBar.frame.size.height;
    [self.collectionView setContentOffset:CGPointMake(0, -end) animated:NO];
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

//    CGFloat scrollPos = self.collectionView.contentOffset.y ;
//
//    if(scrollPos >= _currentOffset ){
//        //Fully hide your toolbar
//        [UIView animateWithDuration:2 animations:^{
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//            //  [self.tabBarController hidesBottomBarWhenPushed:YES];
//
//
//        }];
//    } else {
//        //Slide it up incrementally, etc.
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }

    // getting the scroll offset
    CGFloat bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;

    if (bottomEdge == scrollView.contentSize.height+[[[self tabBarController] tabBar] bounds].size.height)
    {
        
        if (_sortOperator == 1){
            NSString *url = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/popular?api_key=d48734565398d23abd30a6ec3a333ec2&language=en-US&page=%d",self.mostPopularPageNum];
            NSLog(@"func is running %@",url);
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager GET: url
              parameters:nil
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     NSArray *movies = [responseObject valueForKeyPath:@"results.id"];
                     [self.popularIDS addObjectsFromArray:movies];
                     _movieIDS = _popularIDS;
                     NSArray *posters = [responseObject valueForKeyPath:@"results.poster_path"];
                     [self.popularPosters addObjectsFromArray:posters];
                     _moviePosters = _popularPosters;
                     self.mostPopularPageNum = self.mostPopularPageNum+1;
                     NSLog(@"%i",self.mostPopularPageNum);
                     [self.collectionView reloadData];
                 }
                 failure:^(NSURLSessionTask *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
        }else{
            NSString *url = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/top_rated?api_key=d48734565398d23abd30a6ec3a333ec2&language=en-US&page=%d",self.topRatedPageNum];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager GET: url
              parameters:nil
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     NSArray *movies = [responseObject valueForKeyPath:@"results.id"];
                     [self.topRatedIDS addObjectsFromArray:movies];
                     _movieIDS = _topRatedIDS;
                     NSArray *posters = [responseObject valueForKeyPath:@"results.poster_path"];
                     [self.topRatedPosters addObjectsFromArray:posters];
                     _moviePosters = _topRatedPosters;
                     self.topRatedPageNum = self.topRatedPageNum+1;
                     [self.collectionView reloadData];
                 }
                 failure:^(NSURLSessionTask *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
        }
    }
}



@end

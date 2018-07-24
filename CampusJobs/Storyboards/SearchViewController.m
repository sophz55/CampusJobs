//
//  SearchViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/24/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.Webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.SearchBar.text]]]];
    [self.Webview addSubview:self.Indicator];
    [self.SearchBar resignFirstResponder];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(loading) userInfo:nil repeats:YES];
    
}

-(void)loading {
    
    if (!self.Webview.loading)
        [self.Indicator stopAnimating];
    else
        [self.Indicator startAnimating];
    
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.SearchBar.text = nil;
    [self.SearchBar resignFirstResponder];
    
    
    
}



@end

//
//  SearchVC.m
//  hoosright
//
//  Created by rupam on 7/15/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "SearchVC.h"
#import "NewsFeedDetailVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface SearchVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UISearchBar *search;
    IBOutlet UITableView *searchTable;
    NSMutableArray *SearchaArr;
    
}

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //searchbar delegare
    search.delegate = self;
    [search becomeFirstResponder];
    
    self.title = @"Search";
//    searchTable.frame = CGRectMake(searchTable.frame.origin.x,searchTable.frame.origin.y+5 , self.view.frame.size.width, self.view.frame.size.height - 49);
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(goback:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"%@",searchText);
    if ([searchText isEqual:@""]) {
        SearchaArr = [[NSMutableArray alloc]init];
        [searchTable reloadData];
        
    }
    else
    {
        [self searchPosts:searchText];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self searchPosts:searchBar.text];
    searchBar.text = nil;
    
    [searchBar resignFirstResponder];
}


-(void)searchPosts :(NSString *)keyword
{
    

    NSString *value = [NSString stringWithFormat:@"user_id=%@&search_key=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],keyword];
    NSLog(@"%@",value );
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/search.php"]];


    NSLog(@"my--%@",url);
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];



    SearchaArr = [[NSMutableArray alloc]init];
    NSDictionary *json = [NSJSONSerialization
                        JSONObjectWithData:urlData //1
                        
                        options:kNilOptions
                        error:&error];

    NSLog(@"%@",json);
    
    
    if ([[SearchaArr valueForKey:@"msg"] isEqual:@"No More Records Available!"]) {
        
    }
    else
    {
        
        for (NSDictionary *data in [json valueForKey:@"posts"]) {
            [SearchaArr addObject:data];
        }
        searchTable.delegate = self;
        searchTable.dataSource = self;
        
       
        [searchTable reloadData];

    }
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SearchaArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [cell.imageView setImageWithURL:[[SearchaArr objectAtIndex:indexPath.row]valueForKey:@"first_prof_image"]placeholderImage:[UIImage imageNamed:@"Noimage" ]];
    
    CGSize itemSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.layer.cornerRadius = 15;
    cell.imageView.layer.masksToBounds = YES;
    
    cell.textLabel.text = [[SearchaArr objectAtIndex:indexPath.row]valueForKey:@"post_name"];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFeedDetailVC *NewsFeedDetailVC_ = [[NewsFeedDetailVC alloc]init];
    
    NewsFeedDetailVC_.PostID = [[SearchaArr objectAtIndex:indexPath.row]valueForKey:@"id"];
    
    [self.navigationController pushViewController:NewsFeedDetailVC_ animated:YES];
    
}

@end

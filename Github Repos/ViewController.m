//
//  ViewController.m
//  Github Repos
//
//  Created by Marc Maguire on 2017-05-22.
//  Copyright © 2017 Marc Maguire. All rights reserved.
//

#import "ViewController.h"
#import "Repo.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray <Repo *> *repoNameArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.repoNameArray = [[NSMutableArray alloc]init];
    
    [self performNetworkTask];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repoNameArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = self.repoNameArray[indexPath.row].jsonData[@"name"];
    
    return cell;
    
}

#pragma mark - Network Requests

- (void)performNetworkTask {
    
   NSString *marcsGithub = @"https://api.github.com/users/marc-maguire/repos";
    
    //Create a new NSURL object from the github url string.
    NSURL *url = [[NSURL alloc]initWithString:marcsGithub];
    
    //Create a new NSURLRequest object using the URL object. Use this object to make configurations specific to the URL. For example, specifying if this is a GET or POST request, or how we should cache data.
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    //An NSURLSessionConfiguration object defines the behavior and policies to use when making a request with an NSURLSession object. We can set things like the caching policy on this object, similar to the NSURLRequest object, but we can use the session configuration to create many different requests, where any configurations we make to the NSURLRequest object will only apply to that single request. The default system values are good for now, so we'll just grab the default configuration.
    NSURLSessionConfiguration *configuraiton = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //Create an NSURLSession object using our session configuration. Any changes we want to make to our configuration object must be done before this.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuraiton];
    
    //We create a task that will actually get the data from the server. The session creates and configures the task and the task makes the request. Data tasks send and receive data using NSData objects. Data tasks are intended for short, often interactive requests to a server. Check out the NSURLSession API Referece for more info on this. We could optionally use a delegate to get notified when the request has completed, but we're going to use a completion block instead. This block will get called when the network request is complete, weather it was successful or not.
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            //If there was an error, we want to handle it straight away so we can fix it. Here we're checking if there was an error, logging the description, then returning out of the block since there's no point in continuing.
            NSLog(@"error: %@",error.localizedDescription);
        }
        
        NSError *jsonError = nil;
        //The data task retrieves data from the server as an NSData object because the server could return anything. We happen to know that this server is returning JSON so we need a way to convert this data to JSON. Luckily we can just use the NSJSONSerialization object to do just that. We know that the top level object in the JSON response is a JSON object (not an array or string) so we're setting the json as a dictionary.
        NSArray *repos = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            //If there was an error getting JSON from the NSData, like if the server actually returned XML to us, then we want to handle it here.
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        //if we reach this points we have successfully retrieved the JSON from the API
        
        for (NSDictionary *repo in repos) {
            //If we get to this point, we have the JSON data back from our request, so let's use it. When we made this request in our browser, we saw something similar to this:
            
            Repo *JSONrepo = [[Repo alloc]initWithJSON:repo];
    

//            NSString *repoName = repo[@"name"];
            [self.repoNameArray addObject:JSONrepo];
            NSLog(@"repo: %@",JSONrepo.jsonData[@"name"]);
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
           
           
            [self.tableView reloadData];
            
        }];
    }];
    //A task is created in a suspended state, so we need to resume it. We can also You can also suspend, resume and cancel tasks whenever we want. This can be incredibly useful when downloading larger files using a download task.
    [dataTask resume];
}


@end

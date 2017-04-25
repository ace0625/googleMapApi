//
//  AutoCompleteViewController.m
//  googleMapApi
//
//  Created by Dan Kim on 4/25/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

#import "AutoCompleteViewController.h"
#import "AutoCompleteTableViewCell.h"
@import GooglePlaces;

@interface AutoCompleteViewController ()
@property (nonatomic, strong) NSMutableArray *addressResults;
@property (nonatomic, strong) NSMutableArray *locationResults;
@end

@implementation AutoCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.resultTableView registerClass:[AutoCompleteTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AutoCompleteTableViewCell class])];
    [self.resultTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AutoCompleteTableViewCell class]) bundle:nil]
               forCellReuseIdentifier:NSStringFromClass([AutoCompleteTableViewCell class])];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchTextField becomeFirstResponder];
    });
    self.addressResults = [[NSMutableArray alloc]initWithCapacity:0];
    self.locationResults = [[NSMutableArray alloc]initWithCapacity:0];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    GMSPlacesClient *client = [[GMSPlacesClient alloc]init];
    [client autocompleteQuery:self.searchTextField.text bounds:nil filter:nil callback:^(NSArray<GMSAutocompletePrediction *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            [self.addressResults removeAllObjects];
            return;
        }
        [self.addressResults removeAllObjects];
        for (GMSAutocompletePrediction *result in results) {
            [self.addressResults addObject:result.attributedPrimaryText.string];
        }
        [self.resultTableView reloadData];
        
    }];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
        GMSPlacesClient *client = [[GMSPlacesClient alloc]init];
        [client autocompleteQuery:self.searchTextField.text bounds:nil filter:nil callback:^(NSArray<GMSAutocompletePrediction *> * _Nullable results, NSError * _Nullable error) {
            if (error) {
                [self.addressResults removeAllObjects];
                return;
            }
            [self.addressResults removeAllObjects];
            [self.locationResults removeAllObjects];
            for (GMSAutocompletePrediction *result in results) {
                [self.addressResults addObject:result.attributedPrimaryText.string];
                [self.locationResults addObject:result.placeID];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    GMSPlacesClient *placeClient = [GMSPlacesClient sharedClient];
//                    [placeClient lookUpPlaceID:result.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
//                        if (!error) {
//                            NSLog(@"place : %f,%f",result.coordinate.latitude, result.coordinate.longitude);
//                            NSLog(@"name: %@, %@, %@", result.name, result.formattedAddress, result.attributions);
//                        } else {
//                            NSLog(@"Error : %@",error.localizedDescription);
//                        }
//                    }];
//                });
                [self.resultTableView reloadData];
            }
        }];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AutoCompleteTableViewCell *cell = [self.resultTableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoCompleteTableViewCell class]) forIndexPath:indexPath];
    cell.addressLabel.text = self.addressResults[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *placeId = self.locationResults[indexPath.row];
    if (self.locationHandler) {
        self.locationHandler(placeId);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

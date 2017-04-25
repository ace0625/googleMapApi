//
//  AutoCompleteViewController.h
//  googleMapApi
//
//  Created by Dan Kim on 4/25/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoCompleteViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (copy, nonatomic) void (^locationHandler)(NSString *placeId);

@end

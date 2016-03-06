/*
 * Geocube
 * By Edwin Groothuis <geocube@mavetju.org>
 * Copyright 2015 Edwin Groothuis
 *
 * This file is part of Geocube.
 *
 * Geocube is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Geocube is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Geocube.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "Geocube-Prefix.pch"

@interface SettingsAccountsViewController ()
{
    NSArray *accounts;
    NSInteger accountsCount;
}

@end

#define THISCELL @"SettingsAccountsViewControllerCell"

@implementation SettingsAccountsViewController

enum {
    menuDownloadSiteInfo,
    menuMax
};

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.tableView registerClass:[GCTableViewCellSubtitleRightImage class] forCellReuseIdentifier:THISCELL];

    lmi = [[LocalMenuItems alloc] init:menuMax];
    [lmi addItem:menuDownloadSiteInfo label:@"Download site info"];
}

- (void)refreshAccountData
{
    accounts = [dbc Accounts];
    accountsCount = [accounts count];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshAccountData];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([accounts count] != 0)
        return;

    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Initialize site details"
                               message:@"Currently no site details have been initialized. Normally you update them by tapping on the local menu button at the top left and select 'Download site information'. But for now you can update them by pressing the 'Import' button"
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *import = [UIAlertAction
                             actionWithTitle:@"Import"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {
                                 [self downloadFiles];
                             }];

    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];

    [alert addAction:import];
    [alert addAction:cancel];
    [ALERT_VC_RVC(self) presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TableViewController related functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

// Rows per section
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return accountsCount;
}

// Return a cell for the index path
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCTableViewCellSubtitleRightImage *cell = [self.tableView dequeueReusableCellWithIdentifier:THISCELL forIndexPath:indexPath];

    dbAccount *a = [accounts objectAtIndex:indexPath.row];
    cell.textLabel.text = a.site;
    cell.detailTextLabel.text = a.accountname_string;
    cell.userInteractionEnabled = YES;
    if (a.enabled == NO) {
        cell.imageView.image = [imageLibrary get:ImageIcon_Dead];
    } else {
        if (a.accountname_string == nil || [a.accountname_string isEqualToString:@""] == YES) {
            cell.imageView.image = [imageLibrary get:ImageIcon_Target];
        } else {
            if (a.canDoRemoteStuff == YES)
                cell.imageView.image = [imageLibrary get:ImageIcon_Smiley];
            else
                cell.imageView.image = [imageLibrary get:ImageIcon_Sad];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dbAccount *account = [accounts objectAtIndex:indexPath.row];

    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Update account details"
                               message:@"Enter your account name"
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction *action) {
                             //Do Some action
                             UITextField *tf = [alert.textFields objectAtIndex:0];
                             NSString *username = tf.text;

                             account.accountname_string = username;

                             dbName *n = [dbName dbGetByName:username account:account];
                             if (n == nil) {
                                 n = [[dbName alloc] init:0 name:username code:nil account:account];
                                 [n dbCreate];
                             }

                             account.accountname = n;
                             account.accountname_id = n._id;
                             [account dbUpdateAccount];

                             [self.tableView reloadData];

                             if (account.enabled == NO)
                                 return;

                             account.remoteAPI.authenticationDelegate = self;
                             [account.remoteAPI Authenticate];
                         }];

    UIAlertAction *forget = nil;
    if (account.accountname_string != nil && [account.accountname_string length] != 0)
        forget = [UIAlertAction
                  actionWithTitle:@"Forget" style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction * action) {
                      account.accountname_string = nil;
                      account.accountname_id = 0;
                      account.accountname = nil;
                      [account dbUpdateAccount];
                      [account dbClearAuthentication];
                      [self refreshAccountData];
                      [self.tableView reloadData];
                  }];

    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];

    [alert addAction:ok];
    if (forget != nil)
        [alert addAction:forget];
    [alert addAction:cancel];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = account.accountname_string;
        textField.placeholder = @"Username";
    }];

    [ALERT_VC_RVC(self) presentViewController:alert animated:YES completion:nil];
}

- (void)remoteAPI:(RemoteAPI *)api failure:(NSString *)failure error:(NSError *)error
{
    NSMutableString *msg = [NSMutableString stringWithString:failure];
    [msg appendString:@" This means that you cannot obtain information for this account."];

    if (error != nil)
        [msg appendFormat:@" (%@)", [error description] ];

    NSLog(@"failure: %@", msg);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [MyTools messageBox:self header:@"Authentication failed" text:msg];
    }];

    [self refreshAccountData];
    [self.tableView reloadData];
}

- (void)remoteAPI:(RemoteAPI *)api success:(NSString *)success;
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [MyTools messageBox:self header:@"Authentication sucessful" text:@"Yay!"];
    }];

    [self refreshAccountData];
    [self.tableView reloadData];
}


#pragma mark - Local menu related functions

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index
{
    switch (index) {
        case menuDownloadSiteInfo:
            [self downloadFiles];
            return;
    }

    [super didSelectedMenu:menu atIndex:index];
}

- (void)downloadFiles
{
    [self downloadFile:@"url_sites" header:@"Site information download" revision:@"sites_revision"];
    [self downloadFile:@"url_externalmaps" header:@"External maps download" revision:@"externalmaps_revision"];
}

- (void)downloadFile:(NSString *)key_url header:(NSString *)header revision:(NSString *)key_revision
{
    NSURL *url = [NSURL URLWithString:[[dbConfig dbGetByKey:key_url] value]];

    GCURLRequest *urlRequest = [GCURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [MyTools sendSynchronousRequest:urlRequest returningResponse:&response error:&error];

    if (error == nil && response.statusCode == 200) {
        NSLog(@"%@: Downloaded %@ (%ld bytes)", [self class], url, (unsigned long)[data length]);
        [ImportGeocube parse:data];

        [MyTools messageBox:self header:header text:[NSString stringWithFormat:@"Successful downloaded (revision %@)", [[dbConfig dbGetByKey:key_revision] value]]];

        [dbc AccountsReload];
        [self refreshAccountData];
        [self.tableView reloadData];
    } else {
        NSLog(@"%@: Failed! %@", [self class], error);

        NSString *err;
        if (error != nil) {
            err = error.description;
        } else {
            err = [NSString stringWithFormat:@"HTTP status %ld", (long)response.statusCode];
        }

        [MyTools messageBox:self header:header text:[NSString stringWithFormat:@"Failed to download: %@", err]];
    }
}

@end

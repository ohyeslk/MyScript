// Copyright MyScript. All right reserved.

#import "MenuTableViewController.h"
#import "ViewController.h"
#import "ITFFilesViewController.h"
#import "SelectPageInterpreterViewController.h"
#import "GesturesTableViewController.h"
#import "PenTableViewController.h"

@interface MenuTableViewController () <UIAlertViewDelegate>

@end

@implementation MenuTableViewController
{
}

static NSString *CellIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    // remove empty cells
    [self.tableView setTableFooterView:[UIView new]];
    [self setTitle:@"Setting"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closePopoverOrModal)];
        
        self.navigationItem.rightBarButtonItem = close;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Clean";
            break;
            
        case 1:
        {
            cell.textLabel.text = @"Show guidelines";
            
             UISwitch *guidelinesSwitch = [[UISwitch alloc] init];
            guidelinesSwitch.On = _isGuidelinesShowed;
            [guidelinesSwitch addTarget:self action:@selector(guideLinesSwitchChangeAction:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = guidelinesSwitch;
        }
            break;
            
        case 2:
            cell.textLabel.text = @"Load ITF files";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 3:
            cell.textLabel.text = @"Change page interpreter";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 4:
        {
            cell.textLabel.text = @"Save ITF debug";
            UISwitch *ITFWriterSwitch = [[UISwitch alloc] init];
            ITFWriterSwitch.On = _isITFDebug;
            [ITFWriterSwitch addTarget:self action:@selector(ITFWriterSwitchChangeAction:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = ITFWriterSwitch;
        }
            break;
            
        case 5:
        {
            cell.textLabel.text = @"Save current Page as ITF";
        }
            break;
            
        case 6:
        {
            UISwitch *candidateSwitch = [[UISwitch alloc] init];
            candidateSwitch.On = _isCandidateShowed;
            [candidateSwitch addTarget:self action:@selector(showCandidateChangeAction:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = candidateSwitch;
            cell.textLabel.text = @"Show text";
        }
            break;
            
            
        case 7:
            cell.textLabel.text = @"Gestures";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 8:
            cell.textLabel.text = @"Pen";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 9:
            cell.textLabel.text = @"Typeset the page";
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [_viewController clear];
            [self closePopoverOrModal];
            break;
        case 1:
            break;
        case 2:
            [self presentITFFilesViewController];
            break;
        case 3:
            [self presentSelectPageInterpreterController];
            break;
        case 5:
            [self saveCurrentPageAsITF];
            break;
        case 7:
            [self presentGestureTableViewController];
            break;
        case 8:
            [self presentPenTableViewController];
            break;
        case 9:
            [self sendTypesetPage];
            break;
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)closePopoverOrModal
{
    if (_parentPopopController)
    {
        [_parentPopopController dismissPopoverAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)guideLinesSwitchChangeAction:(UISwitch *)uiSwitch
{
    [_viewController guidelinesChangedAction:uiSwitch.isOn];
}

- (void)showCandidateChangeAction:(UISwitch *)uiSwitch
{
    [_viewController candidateChangedAction:uiSwitch.isOn];
}

- (void)ITFWriterSwitchChangeAction:(UISwitch *)uiSwitch
{
    [_viewController ITFDebugChangedAction:uiSwitch.isOn];
}

- (void)presentITFFilesViewController
{
    ITFFilesViewController *itfvc = [[ITFFilesViewController alloc] initWithStyle:UITableViewStylePlain];
    itfvc.delegate = _viewController;
    
    [self.navigationController pushViewController:itfvc animated:YES];
}

- (void)saveCurrentPageAsITF
{
    UIAlertView *itfAlertView = [[UIAlertView alloc] initWithTitle:@"Enter the name for the ITF" message:@"The ITF file will be saved in the document directory." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [itfAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [itfAlertView show];
}

- (void)presentSelectPageInterpreterController
{
    SelectPageInterpreterViewController *selectPageViewController = [[SelectPageInterpreterViewController alloc] initWithStyle:UITableViewStylePlain];
    selectPageViewController.delegate = _viewController;
    selectPageViewController.indexCurrentPageInterpreter = _viewController.indexCurrentPageInterpreter;
    
    [self.navigationController pushViewController:selectPageViewController animated:YES];
}

- (void)presentGestureTableViewController
{
    GesturesTableViewController *gestureTableViewController = [[GesturesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    gestureTableViewController.itcGesturesSampleData = _itcGesturesSampleData;
    gestureTableViewController.delegate = _viewController.gestureManager;
    
    [self.navigationController pushViewController:gestureTableViewController animated:YES];
}

- (void)presentPenTableViewController
{
    PenTableViewController *penTableViewController = [[PenTableViewController alloc] initWithStyle:UITableViewStylePlain];
    penTableViewController.isRecoPen = _viewController.isRecoPen;
    penTableViewController.delegate = _viewController;
    
    [self.navigationController pushViewController:penTableViewController animated:YES];
}

- (void)sendTypesetPage
{
    [_viewController typesetPage];
}


#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Ok button
    if (buttonIndex == 1)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        [_viewController saveCurrentPageToITFWithName:textField.text];
    }
}

@end

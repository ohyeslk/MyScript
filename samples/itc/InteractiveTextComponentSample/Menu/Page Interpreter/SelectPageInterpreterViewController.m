// Copyright MyScript. All right reserved.

#import "SelectPageInterpreterViewController.h"

@interface SelectPageInterpreterViewController ()

@end

static NSString *CellIdentifier = @"Cell";

@implementation SelectPageInterpreterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
        
        self.title = NSLocalizedString(@"Change page interpreter", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // remove empty cells
    [self.tableView setTableFooterView:[UIView new]];
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_indexCurrentPageInterpreter == indexPath.row)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Page interpreter 1";
            break;
        case 1:
            cell.textLabel.text = @"Page interpreter 2";
            break;
        case 2:
            cell.textLabel.text = @"Page interpreter 3";
            break;
        case 3:
            cell.textLabel.text = @"Page interpreter 4";
            break;
        default:
            break;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate)
        [_delegate selectPageInterpreterViewController:self didChangePageInterpreterIndex:indexPath.row];
    
    _indexCurrentPageInterpreter = indexPath.row;
    [self.tableView reloadData];
}

@end

// Copyright MyScript. All right reserved.

#import "PenTableViewController.h"

@interface PenTableViewController ()

@end

static NSString *CellIdentifier = @"PensCell";
@implementation PenTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        
        // Custom initialization
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
        
        // remove empty cells
        [self.tableView setTableFooterView:[UIView new]];
        
        [self setTitle:@"Pens"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // remove empty cells
    [self.tableView setTableFooterView:[UIView new]];
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Recognition Pen";
            
            if (_isRecoPen)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            break;
        case 1:
            cell.textLabel.text = @"Drawing Pen";
            
            if (!_isRecoPen)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        default:
            break;
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _isRecoPen = indexPath.row == 0;
    
    if (_delegate)
        [_delegate penTableViewController:self didChangePen:_isRecoPen];
    
    [self.tableView reloadData];
}


@end

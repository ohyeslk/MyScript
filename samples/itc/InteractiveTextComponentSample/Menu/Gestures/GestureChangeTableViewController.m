// Copyright MyScript. All right reserved.

#import "GestureChangeTableViewController.h"

@interface GestureChangeTableViewController ()

@end

@implementation GestureChangeTableViewController
{
    ITCGestureType _gestureType;
}

static NSString *CellIdentifier = @"GestureChangeCell";

- (id)initWithStyle:(UITableViewStyle)style andGestureType:(ITCGestureType)gestureType
{
    self = [super initWithStyle:style];
    if (self) {
        _gestureType = gestureType;
        
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        
        // remove empty cells
        [self.tableView setTableFooterView:[UIView new]];
        
        [self setTitle:[self gestureTitle]];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return self;
}

- (NSString *)gestureTitle
{
    NSString *gestureTitle;
    
    switch (_gestureType) {
        case ITCGestureTypeErase:
            gestureTitle = @"Erase";
            break;
        case ITCGestureTypeInsert:
            gestureTitle = @"Insert";
            break;
        case ITCGestureTypeJoin:
            gestureTitle = @"Join";
            break;
        case ITCGestureTypeOverwrite:
            gestureTitle = @"Overwrite";
            break;
        case ITCGestureTypeReturn:
            gestureTitle = @"Return";
            break;
        case ITCGestureTypeSelection:
            gestureTitle = @"Selection";
            break;
        case ITCGestureTypeSingleTap:
            gestureTitle = @"Single Tap";
            break;
        case ITCGestureTypeUnderline:
            gestureTitle = @"Underline";
            break;
            
        default:
            break;
    }
    
    return gestureTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = YES;
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
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"Enable gesture";
            
            UISwitch *enableGestureSwitch = [[UISwitch alloc] init];
            enableGestureSwitch.On = _gestureData.isEnable;
            [enableGestureSwitch addTarget:self action:@selector(enableGestureSwitchChangeAction:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = enableGestureSwitch;
            break;
        }
            
        case 1:
        {
            cell.textLabel.text = @"Default processing";
            
            UISwitch *defaultGestureSwitch = [[UISwitch alloc] init];
            defaultGestureSwitch.On = _gestureData.isDefaultProcessing;
            [defaultGestureSwitch addTarget:self action:@selector(defaultProcessingGestureSwitchChangeAction:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = defaultGestureSwitch;
            break;
        }
    }
    return cell;
}

- (void)enableGestureSwitchChangeAction:(UISwitch *)uiSwitch
{
    if (_delegate)
        [_delegate gestureType:_gestureData.gestureType didEnable:uiSwitch.isOn];
}

- (void)defaultProcessingGestureSwitchChangeAction:(UISwitch *)uiSwitch
{
    if (_delegate)
        [_delegate gestureType:_gestureData.gestureType didDefaultProcessing:uiSwitch.isOn];
}

@end

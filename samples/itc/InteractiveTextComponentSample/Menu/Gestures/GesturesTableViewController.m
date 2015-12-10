// Copyright MyScript. All right reserved.

#import "GesturesTableViewController.h"
#import "GestureChangeTableViewController.h"

@interface GesturesTableViewController ()

@end

static NSString *CellIdentifier = @"GesturesCell";

@implementation GesturesTableViewController
{
    NSMutableArray *_gestureTypes;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        
        // Custom initialization
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
        
        // remove empty cells
        [self.tableView setTableFooterView:[UIView new]];
        
        [self setTitle:@"Gestures"];
        
        _gestureTypes = [NSMutableArray arrayWithCapacity:8];
        
        [_gestureTypes addObject:[NSNumber numberWithInt:ITCGestureTypeErase]];
        [_gestureTypes addObject:[NSNumber numberWithInt:ITCGestureTypeInsert]];
        [_gestureTypes addObject:[NSNumber numberWithInt:ITCGestureTypeJoin]];
        [_gestureTypes addObject:[NSNumber numberWithInt:ITCGestureTypeOverwrite]];
        [_gestureTypes addObject:[NSNumber numberWithInt:ITCGestureTypeReturn]];
        [_gestureTypes addObject:[NSNumber numberWithInt:ITCGestureTypeSelection]];
        [_gestureTypes addObject:[NSNumber numberWithInt:ITCGestureTypeSingleTap]];
        [_gestureTypes addObject:[NSNumber numberWithInt:ITCGestureTypeUnderline]];
    }
    return self;
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
    return _gestureTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ITCGestureType gestureType = [[_gestureTypes objectAtIndex:indexPath.row] intValue];
    NSString *cellText;
    switch (gestureType) {
        case ITCGestureTypeErase:
            cellText = @"Erase";
            break;
        case ITCGestureTypeInsert:
            cellText = @"Insert";
            break;
        case ITCGestureTypeJoin:
            cellText = @"Join";
            break;
        case ITCGestureTypeOverwrite:
            cellText = @"Overwrite";
            break;
        case ITCGestureTypeReturn:
            cellText = @"Return";
            break;
        case ITCGestureTypeSelection:
            cellText = @"Selection";
            break;
        case ITCGestureTypeSingleTap:
            cellText = @"Single Tap";
            break;
        case ITCGestureTypeUnderline:
            cellText = @"Underline";
            break;
            
        default:
            break;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = cellText;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITCGestureType gestureType = [[_gestureTypes objectAtIndex:indexPath.row] intValue];
    
    [self presentGestureChangeWithGesture:gestureType];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)presentGestureChangeWithGesture:(ITCGestureType)gestureType
{
    GestureChangeTableViewController *gestureChangeTableViewControoler = [[GestureChangeTableViewController alloc] initWithStyle:UITableViewStylePlain andGestureType:gestureType];
    gestureChangeTableViewControoler.delegate = _delegate;
    
    ITCSampleGestureData *gestureData = [self findGestureDataForGestureType:gestureType];
    [gestureChangeTableViewControoler setGestureData:gestureData];
    
    [self.navigationController pushViewController:gestureChangeTableViewControoler animated:YES];
}

- (ITCSampleGestureData *)findGestureDataForGestureType:(ITCGestureType)gestureType
{
    for (ITCSampleGestureData *gestureData in _itcGesturesSampleData)
    {
        if (gestureData.gestureType == gestureType)
            return gestureData;
    }
    
    return nil;
}

@end

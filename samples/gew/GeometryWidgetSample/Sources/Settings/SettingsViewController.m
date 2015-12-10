//
//  SettingsViewController.m
//  GeometryWidgetSample
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import "Customization.h"
#import "SettingsViewController.h"
#import <AtkGew/GWGeometryView.h>

NSString *const SettingsCellIdentifier = @"SettingsCell";

@interface SettingsViewController ()

// Possible ink colors
@property (strong, nonatomic) NSDictionary *colors;

@end

typedef NS_ENUM (NSUInteger, SettingsRow) {
    SettingsRowInkColor,
    SettingsRowInkWidth,
    SettingsRowInkDashed,
    SettingsRowCount,
};

@implementation SettingsViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(320, 44 * SettingsRowCount);
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:SettingsCellIdentifier];
    
    _colors = @{
                @"Gray" : [UIColor appTintColor],
                @"Blue" : [UIColor blueColor],
                @"Red"  : [UIColor redColor],
                };
    
    self.title = @"Settings";
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SettingsRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingsCellIdentifier
                                                            forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row)
    {
        case SettingsRowInkColor:
        {
            cell.textLabel.text = @"Ink Color";
            
            UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[_colors allKeys]];
            
            segmentedControl.tintColor            = [UIColor appTintColor];
            segmentedControl.selectedSegmentIndex = [[_colors allValues] indexOfObject:_geometryView.inkColor];
            
            [segmentedControl addTarget:self
                                 action:@selector(segmentedControlValueChanged:)
                       forControlEvents:UIControlEventValueChanged];
            
            cell.accessoryView = segmentedControl;
        }
            break;
            
        case SettingsRowInkWidth:
        {
            cell.textLabel.text = @"Ink Thickness";
            
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
            
            slider.minimumValue = 1.0;
            slider.maximumValue = 5.0;
            slider.value        = _geometryView.inkThickness;
            slider.tintColor    = [UIColor appTintColor];
            
            [slider addTarget:self
                       action:@selector(sliderValueChanged:)
             forControlEvents:UIControlEventValueChanged];
            
            cell.accessoryView = slider;
        }
            break;
            
        case SettingsRowInkDashed:
        {
            cell.textLabel.text = @"Ink Dashed";
            
            UISwitch *switchView = [[UISwitch alloc] init];
            
            switchView.on          = _geometryView.inkDashed;
            switchView.onTintColor = [UIColor appTintColor];
            
            [switchView addTarget:self
                           action:@selector(switchValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
            
            cell.accessoryView = switchView;
        }
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Controls update

- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl
{
    NSString *colorName = [segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex];
    
    UIColor *color = _colors[colorName];
    
    _geometryView.inkColor = color;
}

- (void)switchValueChanged:(UISwitch *)switchView
{
    _geometryView.inkDashed = switchView.on;
}

- (void)sliderValueChanged:(UISlider *)slider
{
    _geometryView.inkThickness = slider.value;
}

@end
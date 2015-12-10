// Copyright MyScript. All right reserved.

#import "ITFFilesViewController.h"

@interface ITFFilesViewController ()

@end

static NSString *CellIdentifier = @"Cell";

@implementation ITFFilesViewController
{
    NSMutableArray *_ITFFiles;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
        
        // remove empty cells
        [self.tableView setTableFooterView:[UIView new]];
        
        _ITFFiles = [[NSMutableArray alloc] init];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSMutableArray *files = [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:[self documentDirectory] error:nil]];
        
        // Order the files by the most recent in first.
        [files sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            obj1 = [self pathForFileInDocumentDirectory:obj1];
            obj2 = [self pathForFileInDocumentDirectory:obj2];
            NSDictionary *dict1 = [[NSFileManager defaultManager] attributesOfItemAtPath:obj1 error:nil];
            NSDictionary *dict2 = [[NSFileManager defaultManager] attributesOfItemAtPath:obj2 error:nil];
            NSDate* d1 = dict1[@"NSFileCreationDate"];
            NSDate* d2 = dict2[@"NSFileCreationDate"];
            return [d2 compare:d1];
        }];
        
        for (NSString *file in files)
        {
            if ([file.pathExtension isEqualToString:@"itf"])
            {
                [_ITFFiles addObject:file];
            }
        }
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return _ITFFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[_ITFFiles[indexPath.row] lastPathComponent] stringByDeletingPathExtension];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *file = _ITFFiles[indexPath.row];
    
    if (_delegate && [_delegate respondsToSelector:@selector(itfFilesViewController:didChooseFile:)])
    {
        [_delegate itfFilesViewController:self didChooseFile:[self pathForFileInDocumentDirectory:file]];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

- (void)closeView
{
    if (_parentPopopController)
        [_parentPopopController dismissPopoverAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)documentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return documentDirectory;
}

- (NSString *)pathForFileInDocumentDirectory:(NSString *)fileName
{
    NSString *documentDirectory = [self documentDirectory];
    NSString *fullPath          = [NSString stringWithFormat:@"%@/%@", documentDirectory, fileName];
    
    return fullPath;
}

@end

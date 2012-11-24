//
//  NLDictionaryView.m
//  StressIt
//
//  Created by Nikita Popov on 19.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLDictionaryView.h"
#import "NLAppDelegate.h"
#import "NLCD_Block.h"
#define letterCount 30

@interface NLDictionaryView ()

@end

@implementation NLDictionaryView
@synthesize arrayOfWords,tableViewLeft,tableViewRight;
@synthesize spin;
@synthesize fetchResultsController;
@synthesize searchDisplayController;
@synthesize filteredObjects;

-(id)init
{
  self = [super init];
  if (self) {
    //[self initArrays];
    spin = [[NLSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50,self.view.frame.size.height/2 -20, 100, 100) type:NLSpinnerTypeDefault startValue:0];
    UIView* back = [[UIView alloc] initWithFrame:CGRectMake(tableViewLeft.frame.origin.x, tableViewLeft.frame.origin.y, tableViewLeft.frame.size.width + tableViewRight.frame.size.width, tableViewLeft.frame.size.height)];
    back.backgroundColor = [UIColor blackColor];
    back.alpha = 0.5;
    back.tag = 1212;
    [self.view addSubview:back];
    [self.view addSubview:spin];
    [spin startSpin];
    [self performSelectorInBackground:@selector(initArrays) withObject:nil];
  }
  return self;
}

-(void)initArrays
{
  NSManagedObjectContext *managedObjectContext = [(NLAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  NSEntityDescription *entityDescription = [NSEntityDescription
                                            entityForName:@"Block" inManagedObjectContext:managedObjectContext];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entityDescription];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                      initWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
  [request setSortDescriptors:@[sortDescriptor]];
  
  [request setFetchBatchSize:20];
  
  NSFetchedResultsController *theFetchedResultsController =
  [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                      managedObjectContext:managedObjectContext sectionNameKeyPath:@"firstLetter"
                                                 cacheName:@"Root"];
  fetchResultsController = theFetchedResultsController;
  fetchResultsController.delegate = self;
  [fetchResultsController performFetch:nil];
  filteredObjects = nil;
  [tableViewLeft performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
  [tableViewRight performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
  [UIView animateWithDuration:0.3 animations:^{
    [spin setAlpha:0];
    [[self.view viewWithTag:1212] setAlpha:0];
  } completion:^(BOOL finished) {
    [spin stopSpin];
    [spin removeFromSuperview];
    [[self.view viewWithTag:1212] removeFromSuperview];
  }];
}

-(NSString*)getKeyFromNumber:(NSInteger)number
{
  switch (number) {
    case 0:
      return @"а";
      break;
    case 1:
      return @"б";
      break;
    case 2:
      return @"в";
      break;
    case 3:
      return @"г";
      break;
    case 4:
      return @"д";
      break;
    case 5:
      return @"е";
      break;
    case 6:
      return @"ё";
      break;
    case 7:
      return @"ж";
      break;
    case 8:
      return @"з";
      break;
    case 9:
      return @"и";
      break;
    case 10:
      return @"й";
      break;
    case 11:
      return @"к";
      break;
    case 12:
      return @"л";
      break;
    case 13:
      return @"м";
      break;
    case 14:
      return @"н";
      break;
    case 15:
      return @"о";
      break;
    case 16:
      return @"п";
      break;
    case 17:
      return @"р";
      break;
    case 18:
      return @"с";
      break;
    case 19:
      return @"т";
      break;
    case 20:
      return @"у";
      break;
    case 21:
      return @"ф";
      break;
    case 22:
      return @"х";
      break;
    case 23:
      return @"ц";
      break;
    case 24:
      return @"ч";
      break;
    case 25:
      return @"ш";
      break;
    case 26:
      return @"щ";
      break;
    /*case 27:
      return @"ъ";
      break;
    case 28:
      return @"ы";
      break;
    case 29:
      return @"ь";
      break;*/
    case 27:
      return @"э";
      break;
    case 28:
      return @"ю";
      break;
    case 29:
      return @"я";
      break;
      
    default:
      return NULL;
      break;
  }
}

-(int)getNumberFromFirstLetter:(NSString*)str
{
  int result = [str characterAtIndex:0];
  if (result<=1077) {
    return result - 1072;
  }
  if (result>=1078&&result<=1097) {
    return result - 1071;
  }
  switch (result) {
    case 1105:
      return 6;
      break;
    case 1101:
      return 27;
      break;
    case 1102:
      return 28;
      break;
    case 1103:
      return 29;
      break;
    default:
      return 0;
      break;
  }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(IBAction)goToMainMenu:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  [tableViewLeft setShowsVerticalScrollIndicator:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
  // Return the number of sections.
  if (tableView == [searchDisplayController searchResultsTableView]) {
    return 1;
  }
  return [[fetchResultsController sections] count];//[arrayOfWords count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
  // Return the number of rows in the section.
  //return [[arrayOfWords objectAtIndex:section] count]/2;
  if (tableView == [searchDisplayController searchResultsTableView]) {
    return [filteredObjects count];
  }
  id  sectionInfo =
  [[fetchResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects]/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell...
  if (tableView == [searchDisplayController searchResultsTableView]) {
    
    cell.textLabel.text = [[filteredObjects objectAtIndex:indexPath.row] title];
    return cell;
  }
  
  NSIndexPath* ind;
  
  if(tableView == tableViewLeft) ind = [NSIndexPath indexPathForRow:(indexPath.row*2) inSection:indexPath.section];
  if(tableView == tableViewRight) ind = [NSIndexPath indexPathForRow:(indexPath.row*2 + 1) inSection:indexPath.section];
    NLCD_Block *info = [fetchResultsController objectAtIndexPath:ind];
  cell.textLabel.text = info.title;
  
  return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
  if (scrollView == tableViewLeft) {
    [tableViewRight setContentOffset:scrollView.contentOffset];

  }
  if (scrollView == tableViewRight) {
    [tableViewLeft setContentOffset:scrollView.contentOffset];
  }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if(tableView == tableViewLeft) return [self getKeyFromNumber:section];
  if(tableView == tableViewRight) return @" ";
  if (tableView == [searchDisplayController searchResultsTableView]) return @"Найденные результаты";
  return nil;
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (tableView == tableViewRight) {
    NSMutableArray* ar = [NSMutableArray arrayWithCapacity:letterCount];
    for (int i=0; i<letterCount; ++i) {
      [ar addObject:[self getKeyFromNumber:i]];
    }
    return ar;
  }
  else return nil;
  
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(filterContentForSearchText:) object:nil];
  [self performSelectorInBackground:@selector(filterContentForSearchText:) withObject:searchString];
  //[self filterContentForSearchText:searchString];
  
  return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText
{
  NSPredicate *resultPredicate = [NSPredicate
                                  predicateWithFormat:@"SELF.title contains[cd] %@",
                                  searchText];
  
  filteredObjects = [[fetchResultsController fetchedObjects] filteredArrayUsingPredicate:resultPredicate];
  [[searchDisplayController searchResultsTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{

}

-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
  tableView.frame = CGRectMake(tableViewLeft.frame.origin.x, tableViewLeft.frame.origin.y, tableViewLeft.frame.size.width + tableViewRight.frame.size.width, tableViewLeft.frame.size.height);
}
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
  //[UIView animateWithDuration:0.5 animations:^{
    [searchDisplayController.searchBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
  //}];
}


@end

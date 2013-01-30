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
#import "NLCD_Word.h"
#define letterCount 29
#define xOffset 20
#define yOffset 40
#define kTableViewsHeight 220;

@interface NLDictionaryView ()

@end

@implementation NLDictionaryView
@synthesize arrayOfWords,tableViewLeft,tableViewRight;
@synthesize spin;
@synthesize fetchResultsController;
@synthesize searchDisplayController;
@synthesize filteredObjects;
@synthesize searchBar;

-(id)init
{
  self = [super init];
  if (self) {
    //configuring basic view
    CGRect viewFrame = [[UIScreen mainScreen] applicationFrame];
    int a = viewFrame.size.width;
    viewFrame.size.width = viewFrame.size.height;
    viewFrame.size.height = a;
    [self.view setFrame:viewFrame];
    
    //configuring table view's
    CGPoint customCenter = self.view.center;
    customCenter.y+=yOffset;
    float offset = [[UIScreen mainScreen] bounds].size.height/2 - xOffset;
    CGRect customFrame; //= tableViewLeft.frame;
    customCenter.x-=offset/2;
    customFrame.size.width = offset;
    customFrame.size.height = kTableViewsHeight;
    tableViewLeft.frame = customFrame;
    tableViewLeft.center = customCenter;
    customCenter.x+=offset;
    tableViewRight.frame = customFrame;
    tableViewRight.center = customCenter;
    
    //configuring search box
    customCenter.x -=offset/2;
    int tableViewsHeight = kTableViewsHeight;
    customFrame.size.width = 2*offset;
    customFrame.size.height = 40;
    customCenter.y -= 20 + tableViewsHeight/2;
    CGPoint customCenter1 = searchBar.center;
    customCenter1.x+=20;
    searchBar.frame = customFrame;
    searchBar.center = customCenter;
    
    
    //spin and shadow
    spin = [[NLSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50,self.view.frame.size.height/2 -20, 100, 100) type:NLSpinnerTypeDefault startValue:0];
    customFrame.size.height = 40+kTableViewsHeight;
    customCenter.y += tableViewsHeight/2;
    UIView* back = [[UIView alloc] initWithFrame:customFrame];
    back.center = customCenter;
    back.backgroundColor = [UIColor blackColor];
    back.alpha = 0.5;
    back.tag = 1212;
    [self.view addSubview:back];
    [self.view addSubview:spin];
    [spin startSpin];
    
    
    //[self initArrays];
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
  
  NSSortDescriptor *sortDescriptor = /*[[NSSortDescriptor alloc]
                                      initWithKey:@"title"
                                      ascending:YES
                                      comparator:^(NSString* s1, NSString* s2){
                                       
                                        return NSOrderedSame;
    //return [s1 compare:s2 options:NSCaseInsensitiveSearch | NSNumericSearch |
            //NSWidthInsensitiveSearch | NSForcedOrderingSearch];
                                      }];*/
  [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
  [request setSortDescriptors:@[sortDescriptor]];
  [NSFetchedResultsController deleteCacheWithName:@"Root"];
  [request setFetchBatchSize:0];
  NSFetchedResultsController *theFetchedResultsController =
  [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                      managedObjectContext:managedObjectContext sectionNameKeyPath:@"firstLetter"
                                                 cacheName:@"Root"];
  fetchResultsController = theFetchedResultsController;
  fetchResultsController.delegate = self;
  [fetchResultsController performFetch:nil];
  filteredObjects = nil;
  NSLog(@"%@",[[NSLocale preferredLanguages] objectAtIndex:0]);
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
    /*case 5:
      return @"е";
      break;*/
    case 5:
      return @"е";
      break;
    case 6:
      return @"ж";
      break;
    case 7:
      return @"з";
      break;
    case 8:
      return @"и";
      break;
    case 9:
      return @"й";
      break;
    case 10:
      return @"к";
      break;
    case 11:
      return @"л";
      break;
    case 12:
      return @"м";
      break;
    case 13:
      return @"н";
      break;
    case 14:
      return @"о";
      break;
    case 15:
      return @"п";
      break;
    case 16:
      return @"р";
      break;
    case 17:
      return @"с";
      break;
    case 18:
      return @"т";
      break;
    case 19:
      return @"у";
      break;
    case 20:
      return @"ф";
      break;
    case 21:
      return @"х";
      break;
    case 22:
      return @"ц";
      break;
    case 23:
      return @"ч";
      break;
    case 24:
      return @"ш";
      break;
    case 25:
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
    case 26:
      return @"э";
      break;
    case 27:
      return @"ю";
      break;
    case 28:
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
    NLCD_Word* currentWord = [[[filteredObjects objectAtIndex:indexPath.row] wordsArray] objectAtIndex:0];
    
    cell.textLabel.text = [currentWord description];
    return cell;
  }
  
  NSIndexPath* ind;
  
  if(tableView == tableViewLeft) ind = [NSIndexPath indexPathForRow:(indexPath.row*2) inSection:indexPath.section];
  if(tableView == tableViewRight) ind = [NSIndexPath indexPathForRow:(indexPath.row*2 + 1) inSection:indexPath.section];
    NLCD_Word *info = [[fetchResultsController objectAtIndexPath:ind] wordsArray][0];
  cell.textLabel.text = info.description;
  
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
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  
}


-(NSString*)makeAccentOnWord:(NSString*)string withAccent:(NSInteger)accent
{
  NSString* result = [NSString stringWithFormat:@"%@\u0301%@",[string substringToIndex:accent],[string substringFromIndex:accent]];
  return result;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSIndexPath* normalIndexPath;
  if (tableView == tableViewLeft) {
    normalIndexPath = [NSIndexPath indexPathForRow:indexPath.row*2 inSection:indexPath.section];
  }
  if (tableView == tableViewRight) {
    normalIndexPath = [NSIndexPath indexPathForRow:indexPath.row*2+1 inSection:indexPath.section];
  }
  NLDictionaryViewDetail* temp = [[NLDictionaryViewDetail alloc] initWithBlock:[fetchResultsController objectAtIndexPath:normalIndexPath]];
  [self.navigationController pushViewController:temp animated:YES];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft)||(toInterfaceOrientation==UIInterfaceOrientationLandscapeRight);
}


@end

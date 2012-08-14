/* HistoryViewController.m
 *
 * Copyright (C) 2012  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or   
 *  (at your option) any later version.                                 
 *                                                                      
 *  This program is distributed in the hope that it will be useful,     
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of      
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       
 *  GNU General Public License for more details.                
 *                                                                      
 *  You should have received a copy of the GNU General Public License   
 *  along with this program; if not, write to the Free Software         
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */              

#import "HistoryViewController.h"

@implementation HistoryViewController

@synthesize tableView;
@synthesize tableController;

@synthesize allButton;
@synthesize missedButton;
@synthesize editButton;

typedef enum _HistoryView {
    History_All,
    History_Missed,
    History_MAX
} HistoryView;


#pragma mark - Lifecycle Functions

- (id)init {
    return [super initWithNibName:@"HistoryViewController" bundle:[NSBundle mainBundle]];
}

- (void)dealloc {
    [tableController release];
    [tableView release];
    
    [allButton release];
    [missedButton release];
    [editButton release];
    [super dealloc];
}


#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if(compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:@"History" 
                                                                content:@"HistoryViewController" 
                                                               stateBar:nil 
                                                        stateBarEnabled:false 
                                                                 tabBar:@"UIMainBar" 
                                                          tabBarEnabled:true 
                                                             fullscreen:false
                                                          landscapeMode:[LinphoneManager runningOnIpad]
                                                           portraitMode:true];
    }
    return compositeDescription;
}


#pragma mark - ViewController Functions

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([tableController isEditing])
        [tableController setEditing:FALSE animated:FALSE];
    [editButton setOff];
    [self changeView: History_All];
	[self.tableView reloadData];
    
    // Reset missed call
    linphone_core_reset_missed_calls_count([LinphoneManager getLc]);
    // Fake event
    [[NSNotificationCenter defaultCenter] postNotificationName:kLinphoneCallUpdate object:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeView: History_All];
    
    // Set selected+over background: IB lack !
    [editButton setImage:[UIImage imageNamed:@"history_ok_over.png"] 
                          forState:(UIControlStateHighlighted | UIControlStateSelected)];
    
    // Set selected+over background: IB lack !
    [allButton setImage:[UIImage imageNamed:@"history_all_selected.png"] 
                    forState:(UIControlStateHighlighted | UIControlStateSelected)];
    
    // Set selected+over background: IB lack !
    [missedButton setImage:[UIImage imageNamed:@"history_missed_selected.png"] 
               forState:(UIControlStateHighlighted | UIControlStateSelected)];
}


#pragma mark -

- (void)changeView: (HistoryView) view {
    if(view == History_All) {
        allButton.selected = TRUE;
        [tableController setMissedFilter:FALSE];
    } else {
        allButton.selected = FALSE;
    }
    
    if(view == History_Missed) {
        missedButton.selected = TRUE;
        [tableController setMissedFilter:TRUE];
    } else {
        missedButton.selected = FALSE;
    }
}


#pragma mark - Action Functions

- (IBAction)onAllClick:(id) event {
    [self changeView: History_All];
}

- (IBAction)onMissedClick:(id) event {
    [self changeView: History_Missed];
}

- (IBAction)onEditClick:(id) event {
    [tableController setEditing:![tableController isEditing] animated:TRUE];
}


@end

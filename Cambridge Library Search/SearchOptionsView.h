//
//  SearchOptionsView.h
//  Cambridge Library Search
//
//  Created by James Snee on 28/09/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchOptionsView : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>{
	IBOutlet UISwitch *db_cambridge;
	IBOutlet UISwitch *db_depfacaedb;
	IBOutlet UISwitch *db_depfacfmdb;
	IBOutlet UISwitch *db_depfacozdb;
	IBOutlet UISwitch *db_otherdb;
	IBOutlet UISwitch *db_manuscrpdb;
	
	IBOutlet UIPickerView *searchTypePicker;
}

@end

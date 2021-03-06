//
//  CDVPickerViewController.h
//  Picker
//
//

#import <UIKit/UIKit.h>

@class CDVPicker;

@interface CDVPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) CDVPicker* plugin;
@property (strong, nonatomic) NSArray* choices;
@property (strong, nonatomic) NSString* titleProperty;
@property (strong, nonatomic) UIView* modalView;
@property (nonatomic) CGRect viewFrame;

-(void)showPicker;

-(void)hidePicker;

-(void)selectRow:(int)row inComponent:(NSInteger)component animated:(BOOL)animated;

-(void)refreshChoices;

@end

//
//  CDVPicker.h
//  Picker
//
//

#import <Cordova/CDV.h>
#import "CDVPickerViewController.h"

@interface CDVPicker : CDVPlugin {
    NSString* _callbackId;
}

@property (strong, nonatomic) CDVPickerViewController* pickerController;
@property (nonatomic, assign) BOOL enableBackButton;
@property (nonatomic, assign) BOOL enableForwardButton;
@property (readwrite, assign) BOOL hasPendingOperation;

-(void) show:(CDVInvokedUrlCommand*)command;
-(void) hide:(CDVInvokedUrlCommand*)command;
-(void) onPickerClose:(NSNumber*)row inComponent:(NSNumber*)component;
-(void) onPickerDone:(NSArray*)result;
-(void) onPickerSelectionChange:(NSNumber*)row inComponent:(NSNumber*)component;
-(void) onGoToNext;
-(void) onGoToPrevious;
-(void) pushOptionChanges:(NSArray*)options withSelectedRows:(NSArray*)rows;

@end

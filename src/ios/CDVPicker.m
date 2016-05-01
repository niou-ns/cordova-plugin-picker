//
//  CDVPicker.m
//  Picker
//
//

#import "CDVPicker.h"
#import "CDVPickerViewController.h"

@implementation CDVPicker

- (void)pluginInitialize
{
    self.pickerController = [[CDVPickerViewController alloc] initWithNibName:nil bundle:nil];
    self.pickerController.plugin = self;
    [self.viewController.view insertSubview:self.pickerController.view atIndex:0];
    self.enableBackButton = NO;
    self.enableForwardButton= NO;
}

// shows the picker
-(void) show:(CDVInvokedUrlCommand*)command {
    _callbackId = command.callbackId;
    NSArray* options = [command.arguments objectAtIndex:0];
    NSArray* selectedIndexes;
    if (command.arguments.count > 1)
        selectedIndexes = [command.arguments objectAtIndex:1];
    if (command.arguments.count > 2)
        self.enableBackButton = false;
    if (command.arguments.count > 3)
        self.enableForwardButton = false;
    
    __weak CDVPicker* weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf pushOptionChanges:options withSelectedRows:selectedIndexes];
        [weakSelf.pickerController showPicker];
        CDVPluginResult* pluginResult = [weakSelf buildResult:@"show" keepCallback:YES];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    });
}

-(void) hide:(CDVInvokedUrlCommand*)command {
    _callbackId = command.callbackId;
    [self.pickerController hidePicker];
}

-(void) onPickerClose:(NSNumber*)row inComponent:(NSNumber*)component {
    if (_callbackId != nil) {
        [self.commandDelegate runInBackground:^{
            CDVPluginResult* pluginResult = [self buildResult:@"close" keepCallback:NO withRow:row inComponent:component haveResult:NULL];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
            _callbackId = nil;
        }];
    }
}

-(void) onPickerDone:(NSArray*)result {
    if (_callbackId != nil) {
        [self.commandDelegate runInBackground:^{
            CDVPluginResult* pluginResult = [self buildResult:@"close" keepCallback:NO withRow:nil inComponent:nil haveResult:result];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
            _callbackId = nil;
        }];
    }
}

-(void) onGoToNext {
    if (_callbackId != nil) {
        [self.commandDelegate runInBackground:^{
            CDVPluginResult* pluginResult = [self buildResult:@"next" keepCallback:NO];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
            _callbackId = nil;
        }];
    }
}

-(void) onGoToPrevious {
    if (_callbackId != nil) {
        [self.commandDelegate runInBackground:^{
            CDVPluginResult* pluginResult = [self buildResult:@"back" keepCallback:NO];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
            _callbackId = nil;
        }];
    }
}

-(void) pushOptionChanges:(NSArray*)options withSelectedRows:(NSArray*)rows {
    if (self.pickerController.choices && ![options isEqualToArray:self.pickerController.choices]) {
        self.pickerController.choices = options;
        [self.pickerController refreshChoices];
    } else if (!self.pickerController.choices) {
        self.pickerController.choices = options;
    }
    for (NSUInteger i = 0; i < rows.count; ++i) {
        int row = [[rows objectAtIndex:i] intValue];
        [self.pickerController selectRow:row inComponent:i animated:YES];
    }
    
}

-(void) onPickerSelectionChange:(NSNumber*)row inComponent:(NSNumber*)component {
    if (_callbackId != nil) {
        [self.commandDelegate runInBackground:^{
            CDVPluginResult* pluginResult = [self buildResult:@"select" keepCallback:YES withRow:row inComponent:component haveResult:nil];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
        }];
    }
}

-(CDVPluginResult*)buildResult:(NSString*)event keepCallback:(BOOL)keep {
    return [self buildResult:event keepCallback:keep withRow:nil inComponent:nil haveResult:nil];
}

-(CDVPluginResult*)buildResult:(NSString*)event keepCallback:(BOOL)keep withRow:(NSNumber*)row inComponent:(NSNumber*)component haveResult:(NSArray*)res {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:event forKey:@"event"];
    if (row != nil)
        [result setObject:row forKey:@"row"];
    if (component != nil)
        [result setObject:component forKey:@"component"];
    if (res != nil) {
        [result setObject:res forKey:@"result"];
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [pluginResult setKeepCallbackAsBool:keep];
    return pluginResult;
}

@end

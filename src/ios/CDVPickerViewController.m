//
//  CDVPickerViewController.m
//  Picker
//
//
#import <UIKit/UIKit.h>
#import "CDVPicker.h"
#import "CDVPickerViewController.h"


@interface CDVPickerViewController ()
{
    NSInteger selectedRow;
    NSInteger selectedComponent;
    BOOL animateSelection;
}

@property (nonatomic, strong) UITextField *pickerViewTextField;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;
@property (nonatomic, strong) UIBarButtonItem *backButton;

@end

NSArray *_pickerData;

@implementation CDVPickerViewController

@synthesize pickerViewTextField = _pickerViewTextField;
@synthesize choices = _choices;
@synthesize pickerView = _pickerView;
@synthesize titleProperty = _titleProperty;
@synthesize forwardButton = _forwardButton;
@synthesize backButton = _backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedRow = 0;
        selectedComponent = 0;
        animateSelection = YES;
        self.titleProperty = @"text";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"Loading view");
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField];

    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    if (self.choices.count > selectedRow)
        [self.pickerView selectRow:selectedRow inComponent:selectedComponent animated:animateSelection];

    self.pickerViewTextField.inputView = self.pickerView;

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelTouched:)];
    closeButton.style = UIBarButtonSystemItemDone;
    [toolBar setItems:[NSArray arrayWithObjects: [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], closeButton, nil]];
    self.pickerViewTextField.inputAccessoryView = toolBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showPicker {
    self.backButton.enabled = self.plugin.enableBackButton;
    self.forwardButton.enabled = self.plugin.enableForwardButton;
    if ([self.pickerViewTextField isFirstResponder]) {
        NSLog(@"Picker is already showing");
        [self refreshChoices];
    } else {
        NSLog(@"Showing PickerView");
        [self.pickerViewTextField becomeFirstResponder];
    }
}

-(void)hidePicker {
    [self.pickerViewTextField resignFirstResponder];

    NSUInteger numComponents = self.pickerView.numberOfComponents;
    NSMutableArray *result = [NSMutableArray array];

    for(NSUInteger i = 0; i < numComponents; ++i) {
        NSUInteger currentRow = [self.pickerView selectedRowInComponent:i];
        NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
        [row setObject:[NSString stringWithFormat:@"%lu",(unsigned long)currentRow] forKey:@"row"];
        [row setObject:[NSString stringWithFormat:@"%lu",(unsigned long)i] forKey:@"component"];
        [row setObject:[[self.choices objectAtIndex:i]objectAtIndex:currentRow] forKey:@"value"];
        [result addObject:row];
    }

//    [self.plugin onPickerClose: [NSNumber numberWithLong:selectedRow] inComponent: [NSNumber numberWithLong:selectedComponent]];
    [self.plugin onPickerDone:result];
}

-(void)refreshChoices {
    self.backButton.enabled = false;
    self.forwardButton.enabled = false;
    if (self.pickerView != nil)
        [self.pickerView reloadAllComponents];
}

- (void)cancelTouched:(UIBarButtonItem *)sender
{
    [self hidePicker];
}

- (void) goToNext:(UIBarButtonItem *)sender
{
    [self.pickerViewTextField resignFirstResponder];
    [self.plugin onGoToNext];
}

- (void) goToPrevious:(UIBarButtonItem *)sender
{
    [self.pickerViewTextField resignFirstResponder];
    [self.plugin onGoToPrevious];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.choices count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self.choices objectAtIndex:component] count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.choices[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow = row;
    selectedComponent = component;
    // perform some action
    if ([self.pickerViewTextField isFirstResponder]) {
        NSLog(@"Selected row %ld",(long)row);
        [self.plugin onPickerSelectionChange:[NSNumber numberWithLong:selectedRow] inComponent: [NSNumber numberWithLong:selectedComponent]];
    }
}

-(void)selectRow:(int)row inComponent:(NSInteger)component animated:(BOOL)animated {
    selectedRow = row;
    selectedComponent = component;
    animateSelection = animated;
   [self.pickerView selectRow:row inComponent:component animated:animated];
}

@end

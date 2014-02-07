//
//  MainViewController.m
//  YUTableViewDemo
//
//  Created by Yücel Uzun on 01/02/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import "MainViewController.h"
#import "BasicViewController.h"
#import "ComplexViewController.h"

@interface MainViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UISwitch       * showAllItemsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch       * scrollToTopSwitch;
@property (weak, nonatomic) IBOutlet UITextField    * animationDurationTextField;
@property (weak, nonatomic) IBOutlet UIButton       * insertRowAnimationButton;
@property (weak, nonatomic) IBOutlet UIButton       * deleteRowAnimationButton;
@property (weak, nonatomic) IBOutlet UISwitch       * userInteractionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch       * selectRandomSwitch;

@property (weak, nonatomic) IBOutlet UIButton       * basicButton;
@property (weak, nonatomic) IBOutlet UIButton       * complexButton;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setButtons];
    _animationDurationTextField.inputAccessoryView = [self inputAccessoryView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark initialize

- (void) setButtons
{
    _insertRowAnimationButton.layer.cornerRadius        = 4.0f;
    _insertRowAnimationButton.layer.masksToBounds       = YES;

    _deleteRowAnimationButton.layer.cornerRadius        = 4.0f;
    _deleteRowAnimationButton.layer.masksToBounds       = YES;
    
    _basicButton.layer.cornerRadius                     = 4.0f;
    _basicButton.layer.masksToBounds                    = YES;
    
    _complexButton.layer.cornerRadius                   = 4.0f;
    _complexButton.layer.masksToBounds                  = YES;
}

- (UIView *) inputAccessoryView
{
    UIToolbar * accView             = [[UIToolbar alloc] init];
    UIBarButtonItem * doneButton    = [[UIBarButtonItem alloc] initWithTitle: @"Done"
                                                                       style: UIBarButtonItemStyleDone
                                                                      target: self
                                                                      action: @selector(doneClicked)];
    
    [doneButton setTitleTextAttributes: @{UITextAttributeTextColor: [UIColor whiteColor]} forState: UIControlStateNormal];
    UIBarButtonItem * space         = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                    target: nil
                                                                                    action:nil];
    [accView setItems: [NSArray arrayWithObjects: space, doneButton, nil]];
    [accView sizeToFit];
    accView.barStyle                = UIBarStyleBlackTranslucent;
    return accView;
}

#pragma mark - Actions

- (void) doneClicked
{
    [self.view endEditing:YES];
}

- (IBAction)insertRowButtonTouched:(id)sender
{
    [self.view endEditing:YES];
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle: @"Select Insert Row Animation"
                                                              delegate: self
                                                     cancelButtonTitle: @"Cancel"
                                                destructiveButtonTitle: nil
                                                     otherButtonTitles: @"Fade", @"Right", @"Left", @"Top", @"Bottom", @"None", @"Middle", @"Automatic", nil];
    actionSheet.tag             = 1;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}
- (IBAction)deleteRowButtonTouched:(id)sender
{
    [self.view endEditing:YES];
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle: @"Select Delete Row Animation"
                                                              delegate: self
                                                     cancelButtonTitle: @"Cancel"
                                                destructiveButtonTitle: nil
                                                     otherButtonTitles: @"Fade", @"Right", @"Left", @"Top", @"Bottom", @"None", @"Middle", @"Automatic", nil];
    actionSheet.tag             = 2;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * text = [actionSheet buttonTitleAtIndex: buttonIndex];
    if (![text isEqualToString:@"Cancel"])
    {
        if (actionSheet.tag == 1)
            [_insertRowAnimationButton setTitle: text forState: UIControlStateNormal];
        else
            [_deleteRowAnimationButton setTitle: text forState: UIControlStateNormal];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.view endEditing: YES];
    NSNumber * showAll, * scrollToTop, * insert, * delete, * userInt, * random;
    
    showAll     = [NSNumber numberWithBool: _showAllItemsSwitch.on];
    scrollToTop = [NSNumber numberWithBool: _scrollToTopSwitch.on];
    insert      = [self getAnimationTypeAsNumber: _insertRowAnimationButton.currentTitle];
    delete      = [self getAnimationTypeAsNumber: _deleteRowAnimationButton.currentTitle];
    userInt     = [NSNumber numberWithBool: _userInteractionSwitch.on];
    random      = [NSNumber numberWithBool: _selectRandomSwitch.on];
    
    NSMutableDictionary * tableProperties = [NSMutableDictionary dictionaryWithDictionary:@{@"showAll"           : showAll,
                                                                                            @"scrollToTop"       : scrollToTop,
                                                                                            @"insertAnimation"   : insert,
                                                                                            @"deleteAnimation"   : delete,
                                                                                            @"userInt"           : userInt,
                                                                                            @"random"            : random}];
    if (![_animationDurationTextField.text isEqualToString: @""])
    {
        NSNumberFormatter * formatter       = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
        NSNumber * duration                 = [formatter numberFromString: _animationDurationTextField.text];
        if (duration != nil)
            [tableProperties setObject: duration forKey: @"animationDuration"];
    }
    
    if ([segue.identifier isEqualToString:@"BasicSegue"])
    {
        BasicViewController * bvc = segue.destinationViewController;
        bvc.tableProperties       = tableProperties;
    }
    else if ([segue.identifier isEqualToString:@"ComplexSegue"])
    {
        ComplexViewController * cvc = segue.destinationViewController;
        cvc.tableProperties         = tableProperties;
    }
}

#pragma mark - Util

- (NSNumber *) getAnimationTypeAsNumber: (NSString *) type
{
    if ([type isEqualToString: @"Fade"])
        return [NSNumber numberWithInteger: UITableViewRowAnimationFade];
    if ([type isEqualToString: @"Right"])
        return [NSNumber numberWithInteger: UITableViewRowAnimationRight];
    if ([type isEqualToString: @"Left"])
        return [NSNumber numberWithInteger: UITableViewRowAnimationLeft];
    if ([type isEqualToString: @"Top"])
        return [NSNumber numberWithInteger: UITableViewRowAnimationTop];
    if ([type isEqualToString: @"Bottom"])
        return [NSNumber numberWithInteger: UITableViewRowAnimationBottom];
    if ([type isEqualToString: @"None"])
        return [NSNumber numberWithInteger: UITableViewRowAnimationNone];
    if ([type isEqualToString: @"Middle"])
        return [NSNumber numberWithInteger: UITableViewRowAnimationMiddle];
    if ([type isEqualToString: @"Automatic"])
        return [NSNumber numberWithInteger: UITableViewRowAnimationNone];
    return 0;
}

@end

//
//  ViewController.h
//  UartSample
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
@property (weak, nonatomic) IBOutlet UITextView *uartRecvText;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *MSDButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *LSDButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *baudButtons;
@property (weak, nonatomic) IBOutlet UILabel *sendByte;

- (IBAction)find:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)clearRx:(id)sender;
- (IBAction)changedSendByte:(id)sender;
- (IBAction)changedBaud:(id)sender;

@end

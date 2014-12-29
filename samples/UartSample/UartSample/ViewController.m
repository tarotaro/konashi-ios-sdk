//
//  ViewController.m
//  UartSample
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "ViewController.h"
#import "Konashi.h"

@interface ViewController ()

@end

@implementation ViewController

uint8_t send_byte;


- (void)pushLog:(NSString*)record
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSString *date_string = [dateFormatter stringFromDate:date];
    @synchronized (self) {
        self.uartRecvText.text = [NSString stringWithFormat:@"%@%@ %@\n", self.uartRecvText.text, date_string, record];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [Konashi initialize];
    
    [Konashi addObserver:self selector:@selector(connected) name:KonashiEventConnectedNotification];
    [Konashi addObserver:self selector:@selector(ready) name:KonashiEventReadyToUseNotification];
    [Konashi addObserver:self selector:@selector(disconnected) name:KonashiEventDisconnectedNotification];
    
    self.uartRecvText.text = @"";
    
    // UART系のイベントハンドラ
    [Konashi shared].uartRxCompleteHandler = ^(NSData *data) {
        NSLog(@"uart RX complete:%@", [data description]);
        [self pushLog:[NSString stringWithFormat:@"recv %@", [data description]]];
    };

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setSendData:(uint8_t)data
{
    @synchronized (self) {
        send_byte = data;
        self.sendByte.text = [NSString stringWithFormat:@"0x%02X", send_byte];
        self.LSDButtons.selectedSegmentIndex = send_byte % 16;
        self.MSDButtons.selectedSegmentIndex = send_byte / 16;
    }
}

static const uint32_t BAUDS_REAL[] = {
    9600, 19200, 38400, 57600, 76800, 115200
};

- (void)changedBaud:(id)sender
{
    uint32_t baud = BAUDS_REAL[self.baudButtons.selectedSegmentIndex];
    [Konashi uartMode:KonashiUartModeDisable];
    [Konashi uartBaudrate:(baud / 240)];
    [Konashi uartMode:KonashiUartModeEnable];
    [self pushLog:[NSString stringWithFormat:@"Konashi uartBaudrate %d", baud]];
}

- (void)clearRx:(id)sender
{
    self.uartRecvText.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) connected
{
    NSLog(@"CONNECTED");
}

- (void) disconnected
{
    NSLog(@"DISCONNECTED");
    [self pushLog:@"Konashi disconnected"];
}

- (IBAction)changedSendByte:(id)sender
{
    [self setSendData:(self.LSDButtons.selectedSegmentIndex + self.MSDButtons.selectedSegmentIndex * 16)];
}

- (void) ready
{
    NSLog(@"READY");
    
    self.statusMessage.hidden = FALSE;

    [self pushLog:@"Konashi ready"];
    [self changedBaud:0];
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (IBAction)send:(id)sender {
    @synchronized (self) {
        if([Konashi isConnected]) {
            [Konashi uartWriteData:[NSData dataWithBytes:&send_byte length:sizeof(send_byte)]];
            [self pushLog:[NSString stringWithFormat:@"sent <%02X>", send_byte]];
        }
    }
}
@end

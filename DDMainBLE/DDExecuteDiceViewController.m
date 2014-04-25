//
//  DDExecuteDiceViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/24/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDExecuteDiceViewController.h"
#import "Server.h"

@interface DDExecuteDiceViewController ()

@end

@implementation DDExecuteDiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.connectingBLEProgress setProgress:0];
    [self.initializeServerStateLabel setAlpha:0.5F];
    [self.connectingServerProgress setAlpha:0.5F];
    [self.connectingServerProgress setProgress:0];
    [self.initializeImageSetLabel setAlpha:0.5F];
    [self.loadingImagesProgress setAlpha:0.5F];
    [self.loadingImagesProgress setProgress:0];
    [self.nowExecutingLabel setHidden:YES];
    [self.executingIndicator setHidden:YES];
    
    self.count = 0;
    
    // First initialize a Timer and set it in a run loop
    // Fire every second and keep deviceTimeStamp updated in case need to set server state
    NSDate *fireDate = [NSDate dateWithTimeIntervalSince1970:1.0];
    self.timer = [[NSTimer alloc] initWithFireDate:fireDate
                                              interval:1
                                                target:self
                                              selector:@selector(timerFired:)
                                              userInfo:nil
                                               repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    // Second get (or set?) server state and start NSTimer
    [self getServerState];
    
    // Third load images and select first image to transmit based on server state value
    [self prepareAndLoadImages];
    
    // Finally, initiate BLE connection then begin execution
    [self initializeBLE];
    
    [self.executingIndicator stopAnimating];
    [self.executingIndicator setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DD Program Initialization

- (void)setServerState
{
    
}

- (void)getServerState
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:[Server getState]
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* dataState = [json objectForKey:@"state"];
    NSArray* timeStamp = [json objectForKey:@"time"];
    NSLog(@"Data State nsarray: %@", dataState);
    
    NSString *dataString = [NSString stringWithFormat:@"%@", dataState];
    NSLog(@"DataString: %@", dataString);
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.state = [formatter numberFromString:dataString];
    NSLog(@"Data State: %@", self.state);
    
    self.serverTimeStamp = [NSString stringWithFormat:@"%@", timeStamp];
    NSLog(@"TimeStamp: %@", self.serverTimeStamp);
    
    if (self.state && self.serverTimeStamp) {
        [self.initializeServerStateLabel setAlpha:1];
        [self.initializeServerStateLabel setTextColor:[UIColor greenColor]];
        [self.connectingServerProgress setProgress:100 animated:YES];
    }
}

- (void)prepareAndLoadImages
{
    // Default to the digit images, but implement a selection from root controller
    [self.image1 setImage:[UIImage imageNamed:@"one.png"]];
    [self.image2 setImage:[UIImage imageNamed:@"two.png"]];
    [self.image3 setImage:[UIImage imageNamed:@"three.png"]];
    [self.image4 setImage:[UIImage imageNamed:@"four.png"]];
    [self.image5 setImage:[UIImage imageNamed:@"five.png"]];
    [self.image6 setImage:[UIImage imageNamed:@"six.png"]];
    [self.loadingImagesProgress setProgress:30 animated:YES];
    
    // Convert images into gray scale
    self.imageGray1 = [self imageToGreyImage:self.image1.image];
    self.imageGray2 = [self imageToGreyImage:self.image2.image];
    self.imageGray3 = [self imageToGreyImage:self.image3.image];
    self.imageGray4 = [self imageToGreyImage:self.image4.image];
    self.imageGray5 = [self imageToGreyImage:self.image5.image];
    self.imageGray6 = [self imageToGreyImage:self.image6.image];
    [self.loadingImagesProgress setProgress:60 animated:YES];
    
    // Convert images to byte arrays
    self.byteArrayImage1 = [self imageToByteArray:self.imageGray1];
    self.byteArrayImage2 = [self imageToByteArray:self.imageGray2];
    self.byteArrayImage3 = [self imageToByteArray:self.imageGray3];
    self.byteArrayImage4 = [self imageToByteArray:self.imageGray4];
    self.byteArrayImage5 = [self imageToByteArray:self.imageGray5];
    self.byteArrayImage6 = [self imageToByteArray:self.imageGray6];
    [self.loadingImagesProgress setProgress:100 animated:YES];
    
    [self.initializeImageSetLabel setAlpha:1];
    [self.initializeImageSetLabel setTextColor:[UIColor greenColor]];
    
    NSLog(@"End Image Initialization");
}

- (void)initializeBLE
{
    // Scaning 4 seconds for peripherals
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:2
                                                         completion:^(NSArray *peripherals)
     {
         if (peripherals.count) {
             [self.initializeBLELabel setAlpha:1];
             [self.initializeBLELabel setTextColor:[UIColor greenColor]];
             [self.connectingBLEProgress setProgress:100 animated:YES];
            
             [self executeDiceProgram];
         }
     }];
}


#pragma mark - DD Program Execution Logic

- (BOOL)executeDiceProgram
{
    [self.nowExecutingLabel setHidden:NO];
    [self.nowExecutingLabel setTintColor:[UIColor greenColor]];
    [self.executingIndicator setHidden:NO];
    [self.executingIndicator startAnimating];
    
    return NO;
}

- (void)pretendSleep
{
    
}

- (uintmax_t *)setSelectedImageByteArray
{
    // Select image byte array
    switch (self.state.intValue) {
        case 1:
            self.displayDataValueToWrite = self.byteArrayImage1;
            break;
        case 2:
            self.displayDataValueToWrite = self.byteArrayImage2;
            break;
        case 3:
            self.displayDataValueToWrite = self.byteArrayImage3;
            break;
        case 4:
            self.displayDataValueToWrite = self.byteArrayImage4;
            break;
        case 5:
            self.displayDataValueToWrite = self.byteArrayImage5;
            break;
        case 6:
            self.displayDataValueToWrite = self.byteArrayImage6;
            break;
            
        default:
            self.displayDataValueToWrite = self.byteArrayImage1;
            break;
    }
    NSLog(@"ByteArrayImage to write is now %@", @"UPDATE TO REAL VALUE");
    return nil;
}

#pragma mark - CBCentralManagerDelegate

// Method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    self.connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    if (peripheral.state == CBPeripheralStateConnected) {
        [self.connectingBLEProgress setProgress:20 animated:YES];
    }
    NSLog(@"%@", self.connected);
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0) {
        NSLog(@"Found the DD Service: %@", localName);
        self.count += 1;
        [self.centralManager stopScan];
        self.peripheral = peripheral;
        peripheral.delegate = self;
        self.connectingBLEProgress.progress += 20;
        // Connect to peripheral and read/write data
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
    
    if (self.connectingBLEProgress.progress > 100) {
        self.initializeBLELabel.textColor = [UIColor greenColor];
        NSLog(@"Found %i Services", self.count);
    }
}

#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

// Invoked when a peripheral’s services have changed.
- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices
{
    NSLog(@"Peripheral Did Invalidate Services invoked.");
    
}

#pragma mark - CBCharacteristic helpers


#pragma mark - Helpers

-(void)timerFired:(NSTimer *) theTimer
{
    self.deviceTimeStamp = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[theTimer fireDate] timeIntervalSince1970]]];
    //NSLog(@"timerFired @ %@", self.deviceTimeStamp);
}

- (UIImage *)imageToGreyImage:(UIImage *)image {
    // Create image rectangle with current image width/height
    CGFloat actualWidth = image.size.width;
    CGFloat actualHeight = image.size.height;
    
    CGRect imageRect = CGRectMake(0, 0, actualWidth, actualHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate(nil, actualWidth, actualHeight, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    CGImageRef grayImage = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    context = CGBitmapContextCreate(nil, actualWidth, actualHeight, 8, 0, nil, kCGImageAlphaOnly);
    CGContextDrawImage(context, imageRect, [image CGImage]);
    CGImageRef mask = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *grayScaleImage = [UIImage imageWithCGImage:CGImageCreateWithMask(grayImage, mask) scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(grayImage);
    CGImageRelease(mask);
    
    // Return the new grayscale image
    return grayScaleImage;
}

- (uintmax_t *) imageToByteArray:(UIImage *) image
{
    NSData *data = UIImagePNGRepresentation(image);
    NSUInteger len = data.length;
    uintmax_t *bytes = (uintmax_t *)[data bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:len * 3];
    [result appendString:@"["];
    for (NSUInteger i = 0; i < len; i++) {
        if (i) {
            [result appendString:@","];
        }
        [result appendFormat:@"%ju", bytes[i]];
    }
    [result appendString:@"]"];
    NSLog(@"%@", result);
    return bytes;
}

#pragma mark - Navigation

-(IBAction)stop:(id)sender
{
    // Disconnect from peripheral?
    [self.timer invalidate];
    [self.delegate ddExecuteDiceVCDidStop:self];
}

@end

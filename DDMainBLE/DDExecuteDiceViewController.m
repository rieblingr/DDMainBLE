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
@synthesize imageArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSLog(@"TESTING: %u", DISPLAY_IS_BUSY);
    
    [self.connectingBLEProgress setProgress:0];
    [self.initializeServerStateLabel setAlpha:0.5F];
    [self.connectingServerProgress setAlpha:0.5F];
    [self.connectingServerProgress setProgress:0];
    [self.initializeImageSetLabel setAlpha:0.5F];
    [self.loadingImagesProgress setAlpha:0.5F];
    [self.loadingImagesProgress setProgress:0];
    [self.nowExecutingLabel setHidden:YES];
    [self.executingIndicator setHidden:YES];
    
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
    [self prepareAndLoadImages: YES testData:YES];
    //[self setSelectedImageByteArray];
    
    //Set write type
    self.writeType = CBCharacteristicWriteWithoutResponse;
    
    // Finally, initiate BLE connection then begin execution
    [self initializeBLE];
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
        self.initializeServerStateLabel.text = [self.initializeServerStateLabel.text stringByAppendingString:[NSString stringWithFormat:@"   %@\n", self.state]];
        [self.connectingServerProgress setProgress:100 animated:YES];
    }
}

- (void)prepareAndLoadImages:(BOOL)defaultSelected testData:(BOOL)test
{
    // Default to the digit images, but implement a selection from root controller
    if (defaultSelected) {
        [self.image1 setImage:[UIImage imageNamed:@"one.png"]];
        [self.image2 setImage:[UIImage imageNamed:@"two.png"]];
        [self.image3 setImage:[UIImage imageNamed:@"three.png"]];
        [self.image4 setImage:[UIImage imageNamed:@"four.png"]];
        [self.image5 setImage:[UIImage imageNamed:@"five.png"]];
        [self.image6 setImage:[UIImage imageNamed:@"six.png"]];
        [self.loadingImagesProgress setProgress:30 animated:YES];
    }
    
    if (test) {
        [self.image1 setImage:[UIImage imageNamed:@"test"]];
        [self.image2 setImage:[UIImage imageNamed:@"test"]];
        [self.image3 setImage:[UIImage imageNamed:@"test"]];
        [self.image4 setImage:[UIImage imageNamed:@"test"]];
        [self.image5 setImage:[UIImage imageNamed:@"test"]];
        [self.image6 setImage:[UIImage imageNamed:@"test"]];
        [self.loadingImagesProgress setProgress:30 animated:YES];
    }
    
    self.imageGray1 = [self convertToGreyscale:self.image1.image];
    self.imageGray2 = [self convertToGreyscale:self.image2.image];
    self.imageGray3 = [self convertToGreyscale:self.image3.image];
    self.imageGray4 = [self convertToGreyscale:self.image4.image];
    self.imageGray5 = [self convertToGreyscale:self.image5.image];
    self.imageGray6 = [self convertToGreyscale:self.image6.image];
    [self.loadingImagesProgress setProgress:60 animated:YES];
    
    // NSData values for Images
    self.image1DataBytes = UIImagePNGRepresentation(self.imageGray1);
    self.image2DataBytes = UIImagePNGRepresentation(self.imageGray2);
    self.image3DataBytes = UIImagePNGRepresentation(self.imageGray3);
    self.image4DataBytes = UIImagePNGRepresentation(self.imageGray4);
    self.image5DataBytes = UIImagePNGRepresentation(self.imageGray5);
    self.image6DataBytes = UIImagePNGRepresentation(self.imageGray6);
    
    [self.loadingImagesProgress setProgress:100 animated:YES];
    
    [self.initializeImageSetLabel setAlpha:1];
    [self.initializeImageSetLabel setTextColor:[UIColor greenColor]];
    
    NSLog(@"End Image Initialization");
}

- (void)initializeBLE
{
    //set is initial
    self.isInitial = YES;
    
    self.ddServices = @[[CBUUID UUIDWithString:DD_DISPLAY_SERVICE_UUID],[ CBUUID UUIDWithString:DD_GYRO_SERVICE_UUID]];
    self.displayBusyCharArray = @[[CBUUID UUIDWithString:DD_DISPLAY_BUSY_CHARACTERISTIC_UUID]];
    self.displayDataCharsArray = @[[CBUUID UUIDWithString:DD_DISPLAY_DATA_CHARACTERISTIC_UUID]];
    self.displayTargetCharsArray = @[[CBUUID UUIDWithString:DD_DISPLAY_TARGET_CHARACTERISTIC_UUID]];
    self.gyroDataCharsArray = @[[CBUUID UUIDWithString:DD_GYRO_DATA_CHARACTERISTIC_UUID]];
    
    
    CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.centralManager = centralManager;
    
    [self.centralManager scanForPeripheralsWithServices:self.ddServices options:nil];
}

# pragma mark - CBCentralManagerDelegate

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

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0) {
        NSLog(@"Found the DD Service: %@", localName);
        [self.centralManager stopScan];
        self.peripheral = peripheral;
        peripheral.delegate = self;
        // Connect to peripheral and read/write data
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}


#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_SERVICE_UUID]]) {
            self.displayService = service;
            [peripheral discoverCharacteristics:self.displayBusyCharArray forService:service];
        }
        if ([service.UUID isEqual:[CBUUID UUIDWithString:DD_GYRO_SERVICE_UUID]]) {
            self.gyroService = service;
            
        }
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_SERVICE_UUID]])  {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_BUSY_CHARACTERISTIC_UUID]]) {
                
                if(self.isInitial) {
                    self.isInitial = NO;
                    [self.peripheral readValueForCharacteristic:aChar];
                    NSLog(@"Reading a Display Busy characteristic");
                } else {
                    // write to busy
                    int16_t busyDataToWrite = 0x1;
                    NSData *busyData = [NSData dataWithBytes:&busyDataToWrite length:sizeof(busyDataToWrite)];
                    [self.peripheral writeValue:busyData forCharacteristic:aChar type:self.writeType];
                    [self executionComplete];
                }
                
            }
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_DATA_CHARACTERISTIC_UUID]]) {
                [self beginDDExecution:aChar];
            }
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_TARGET_CHARACTERISTIC_UUID]]) {
                
                int16_t targetDataToWrite = 0x1;
                NSData *targetData = [NSData dataWithBytes:&targetDataToWrite length:sizeof(targetDataToWrite)];
                
                [self.peripheral writeValue:targetData forCharacteristic:aChar type:self.writeType];
                
                // Discover Display Busy again
                [self.peripheral discoverCharacteristics:self.displayBusyCharArray forService:self.displayService];
            }
        }
    }
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:DD_GYRO_SERVICE_UUID]])  {
    }
    
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_BUSY_CHARACTERISTIC_UUID]]) {
        NSLog(@"Executing Callback Data Busy Read");
        uint8_t *busyData = (uint8_t *) [characteristic.value bytes];
        NSLog(@"Display Busy: %s", busyData);
        
        if (*busyData == DISPLAY_IS_BUSY) {
            NSLog(@"Display is Busy, Do Nothing");
        } else {
            NSLog(@"Display is Not Busy, writing to Display");
            [peripheral discoverCharacteristics:self.displayDataCharsArray forService:self.displayService];
        }
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices
{
    NSLog(@"Peripheral Did Invalidate Services invoked.");
    
}

#pragma mark - DD Program Execution Logic

- (void)beginDDExecution:(CBCharacteristic *)characteristic
{
    [self.executingIndicator setHidesWhenStopped:YES];
    [self.nowExecutingLabel setHidden:NO];
    [self.initializeBLELabel setTintColor:[UIColor greenColor]];
    [self.nowExecutingLabel setTintColor:[UIColor greenColor]];
    [self.executingIndicator setHidden:NO];
    [self.executingIndicator startAnimating];
    
    DDAppDelegate *myAppDel = (DDAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.imageArray = myAppDel.imageArray;
    
    // Write to Data Display
    [self.peripheral writeValue:self.imageArray forCharacteristic:characteristic type:self.writeType];
    
    // Discover Target Characteristic
    [self.peripheral discoverCharacteristics:self.displayTargetCharsArray forService:self.displayService];
}

- (void)checkDisplayBusy:(CBService *)service
{
    NSLog(@"Checking Display Busy Char");
    
}

- (void)writeToDisplayData:(CBService *)service
{
    NSLog(@"Finding Display Data Write Characteristics");
    
}

- (void)writeToDisplayTarget:(CBService *)service
{
    NSLog(@"Finding Display Target Write Characteristics");
    
}

- (void)writeToDisplayBusy:(CBService *)service
{
    NSLog(@"Finding Display Busy Write Characteristics");
    
}

- (void)executionComplete
{
    [self.executingIndicator stopAnimating];
    [self.nowExecutingLabel setText:@"COMPLETE!"];
    [self.nowExecutingLabel setTintColor:[UIColor greenColor]];
}

- (void)setSelectedImageByteArray
{
    // Select image byte array
    switch (self.state.intValue) {
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
            
        default:
            
            break;
    }
    
    
    // self.displayDataValueToWrite = @[data];
    
}

#pragma mark - Helpers
- (BOOL)checkGyroDataRotation:(uint8_t)gyroData
{
    // Check if gyro data turned and we need to set the server state
    return NO;
}

-(void)timerFired:(NSTimer *) theTimer
{
    self.deviceTimeStamp = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[theTimer fireDate] timeIntervalSince1970]]];
    //NSLog(@"timerFired @ %@", self.deviceTimeStamp);
}

- (UIImage *) convertToGreyscale:(UIImage *)i {
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen | kBlue | kRed;
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultUIImage;
}

- (NSData *) imageToArrayOfNSData:(UIImage *)image
{
    //    NSArray *dataArray;
    NSData *bytes = [[NSData alloc] initWithContentsOfFile:@"one.jpg"];
    NSLog(@"Bytes:%@", bytes);
    return bytes;
}


#pragma mark - Alerts

- (void)alertUserWithUIWarning:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error: %@", (error) ? error : @"Something was wrong with an image"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [self.timer invalidate];
        [self.delegate ddExecuteDiceVCDidStop:self];
    }
}

- (void) receiveImageArray:(NSArray *)array
{
    NSLog(@"Received Created Image: %@", array);
    imageArray = [array mutableCopy];
}

- (void) receiveImageSetArrays:(NSArray *)sets
{
    
}

#pragma mark - Navigation

-(IBAction)stop:(id)sender
{
    // Disconnect from peripheral?
    [self.timer invalidate];
    [self.delegate ddExecuteDiceVCDidStop:self];
}

@end

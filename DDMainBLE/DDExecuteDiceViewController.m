
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
    
    self.count = 0;
    
    self.displayBusyValueRead = [NSNumber numberWithInt:0];
    self.gyroDataValueRead = [NSNumber numberWithInt:0];
    
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
    [self setSelectedImageByteArray];
    
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
        self.initializeServerStateLabel.text = [self.initializeServerStateLabel.text stringByAppendingString:[NSString stringWithFormat:@"   %@\n", self.state]];
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
    self.lgCentralManager = [LGCentralManager sharedInstance];
    
    self.ddServices = @[[CBUUID UUIDWithString:DD_DISPLAY_SERVICE_UUID],[ CBUUID UUIDWithString:DD_GYRO_SERVICE_UUID]];
    self.displayBusyCharArray = @[[CBUUID UUIDWithString:DD_DISPLAY_BUSY_CHARACTERISTIC_UUID]];
    self.displayDataCharsArray = @[[CBUUID UUIDWithString:DD_DISPLAY_DATA_CHARACTERISTIC_UUID]];
    self.displayTargetCharsArray = @[[CBUUID UUIDWithString:DD_DISPLAY_TARGET_CHARACTERISTIC_UUID]];
    self.gyroDataCharsArray = @[[CBUUID UUIDWithString:DD_GYRO_DATA_CHARACTERISTIC_UUID]];
    
    [self startDDProgram];
}

#pragma mark - DD Program Execution Logic

- (void)startDDProgram
{
    
    [self.lgCentralManager scanForPeripheralsByInterval:4 services:self.ddServices options:nil completion:^(NSArray *peripherals) {
        
        [self.initializeBLELabel setTintColor:[UIColor greenColor]];
        [self.connectingBLEProgress setProgress:100 animated:YES];
        [self findAndConnectToDDPeripheral:peripherals[0]];
    }];
}

- (void)findAndConnectToDDPeripheral:(LGPeripheral *)peripheral
{
    NSLog(@"Connecting to: %@", peripheral);
    self.lgPeripheral = peripheral;
    [peripheral connectWithCompletion:^(NSError *error) {
        if (error) {
            NSLog(@"Error connecting: %@", (error));
            [self alertUserWithUIWarning:error];
        }
        NSLog(@"Finished connecting to: %@", peripheral);
        NSLog(@"Now Searching for Display Services...");
        
        [self beginDDExecution: peripheral];
    }];
}

- (void)beginDDExecution:(LGPeripheral *)peripheral
{
    [self.nowExecutingLabel setHidden:NO];
    [self.nowExecutingLabel setTintColor:[UIColor greenColor]];
    [self.executingIndicator setHidden:NO];
    [self.executingIndicator startAnimating];
    
    NSLog(@"Beginning Execution of DD Program");
    [self.lgPeripheral discoverServices:self.ddServices completion:^(NSArray *services, NSError *error) {
        if (error) {
            NSLog(@"Error discovering Display Services: %@", (error));
        }
        for (LGService *service in services) {
            if ([service.UUIDString isEqualToString:DD_DISPLAY_SERVICE_UUID]) {
                NSLog(@"Display Service Found, %@", service.UUIDString);
                [self checkDisplayBusy:service];
            }
        }
        for (LGService *service in services) {
            if ([service.UUIDString isEqualToString:DD_GYRO_SERVICE_UUID]) {
                NSLog(@"Gyro Service Found, %@", service.UUIDString);
                
                
            }
        }
    }];
    
    NSLog(@"Reached END");
}

- (void)checkDisplayBusy:(LGService *)service
{
    NSLog(@"Checking Display Busy Char");
    [service discoverCharacteristicsWithUUIDs:self.displayBusyCharArray completion:^(NSArray *characteristics, NSError *error) {
        if (error) {
            NSLog(@"Error discovering Display Characts: %@", (error) ? error : @"No Error");
        }
        NSLog(@"Display Busy Char Found, %@", characteristics);
        __block int i = 0;
        for (LGCharacteristic *charact in characteristics) {
            if ([charact.UUIDString isEqualToString:DD_DISPLAY_BUSY_CHARACTERISTIC_UUID]) {
                [charact readValueWithBlock:^(NSData *data, NSError *error) {
                    if (error) {
                        NSLog(@"Error reading Display Busy: %@", (error) ? error : @"No Error");
                    }
                    uint8_t *busyData = (uint8_t *) [data bytes];
                    NSLog(@"Display Busy: %s", busyData);
                    NSLog(@"DISPLAY IS BUSY CONST: %d", DISPLAY_IS_BUSY);
                    
                    NSLog(@"TESTING IMAGE TRANSMISSION");
                    NSLog(@"Reading Data in hex %@", [data description]);
                    [self.image6 setImage:[UIImage imageWithData:data]];
                    
                    if (*busyData == DISPLAY_IS_BUSY) {
                        NSLog(@"Display is Busy, Do Nothing");
                        //disconnect?
                    } else {
                        NSLog(@"Display is Not Busy, writing to Display");
                        [self writeToDisplayData:service];
                    }
                }];
            }
        }
    }];
}

- (void)writeToDisplayData:(LGService *)service
{
    NSLog(@"Finding Display Data Write Characteristics");
    [service discoverCharacteristicsWithUUIDs:self.displayDataCharsArray completion:^(NSArray *characteristics, NSError *error) {
        if (error) {
            NSLog(@"Error finding Display Write Characts: %@", (error) ? error : @"No Error");
        }
        NSLog(@"Found Display Data Characts: %@", characteristics);
        for (LGCharacteristic *charact in characteristics) {
            NSLog(@"Char: %@", charact);
            NSLog(@"Char UUID: %@", charact.UUIDString);
            if ([charact.UUIDString isEqualToString:DD_DISPLAY_DATA_CHARACTERISTIC_UUID]) {
                // Initialize data to write
                NSData *writeValue = UIImagePNGRepresentation(self.image1.image);
                [self.image2 setImage:[UIImage imageWithData:writeValue]];
                NSLog(@"Writing value to Display Data in hex %@", [writeValue description]);
                [charact writeValue:writeValue completion:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error writing Display Data: %@", (error) ? error : @"No Error");
                    }
                    [self writeToDisplayTarget:service];
                }];
            }
        }
    }];
}

- (void)writeToDisplayTarget:(LGService *)service
{
    NSLog(@"Finding Display Target Write Characteristics");
    [service discoverCharacteristicsWithUUIDs:self.displayTargetCharsArray completion:^(NSArray *characteristics, NSError *error) {
        if (error) {
            NSLog(@"Error finding Display Write Characts: %@", (error) ? error : @"No Error");
        }
        NSLog(@"Found Display Target Charact: %@", characteristics);
        for (LGCharacteristic *charact in characteristics) {
            NSLog(@"Char: %@", charact);
            NSLog(@"Char UUID: %@", charact.UUIDString);
            if ([charact.UUIDString isEqualToString:DD_DISPLAY_TARGET_CHARACTERISTIC_UUID]) {
                // Initialize target data to write
                uint8_t test = 0x02;
                NSData *targetValue = [NSData dataWithBytes:&test length:sizeof(test)];
                NSLog(@"Writing value to Display Target %@", targetValue);
                [charact writeValue:targetValue completion:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error writing to Target Display: %@", (error) ? error : @"No Error");
                    }
                    [self writeToDisplayBusy:service];
                }];
            }
        }
    }];
    
}

- (void)writeToDisplayBusy:(LGService *)service
{
    NSLog(@"Finding Display Busy Write Characteristics");
    [service discoverCharacteristicsWithUUIDs:self.displayBusyCharArray completion:^(NSArray *characteristics, NSError *error) {
        if (error) {
            NSLog(@"Error finding Display Busy Characts: %@", (error) ? error : @"No Error");
        }
        NSLog(@"Found Display Busy Characts: %@", characteristics);
        for (LGCharacteristic *charact in characteristics) {
            NSLog(@"Char: %@", charact);
            NSLog(@"Char UUID: %@", charact.UUIDString);
            if ([charact.UUIDString isEqualToString:DD_DISPLAY_BUSY_CHARACTERISTIC_UUID]) {
                // Initialize data to write
                NSLog(@"Setting Display to Busy = 1");
                
                /* Cant actually execute this because Mock module doesn't handle
                 [charact writeByte:0x01 completion:^(NSError *error) {
                 if (error) {
                 NSLog(@"Error reading Display Busy: %@", (error) ? error : @"No Error");
                 }
                 }];
                 */
            }
        }
    }];
}

- (void)setSelectedImageByteArray
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
    NSLog(@"ByteArrayImage to write is now %s", self.displayDataValueToWrite);
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

- (NSData *) imageToArrayOfNSData:(UIImage *)image
{
    //    NSArray *dataArray;
    NSData *bytes = [[NSData alloc] initWithContentsOfFile:@"one.jpg"];
    NSLog(@"Bytes:%@", bytes);
    return bytes;
}

- (uint8_t *) imageToByteArray:(UIImage *) image
{
    NSData *data = UIImagePNGRepresentation(image);
    NSLog(@"Image: %@", image);
    NSUInteger len = data.length;
    uint8_t *bytes = (uint8_t *)[data bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:len * 3];
    [result appendString:@"["];
    for (NSUInteger i = 0; i < len; i++) {
        if (i) {
            [result appendString:@","];
        }
        [result appendFormat:@"%hhu", bytes[i]];
    }
    [result appendString:@"]"];
    NSLog(@"%@", result);
    return bytes;
}

#pragma mark - Alerts

- (void)alertUserWithUIWarning:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error: %@", error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [self.timer invalidate];
        [self.delegate ddExecuteDiceVCDidStop:self];
    }
}

#pragma mark - Navigation

-(IBAction)stop:(id)sender
{
    // Disconnect from peripheral?
    [self.timer invalidate];
    [self.delegate ddExecuteDiceVCDidStop:self];
}

@end

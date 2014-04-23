//
//  DDBLEViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/22/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDBLEViewController.h"

@interface DDBLEViewController ()

@end

@implementation DDBLEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    
    // Set status textview
    [self.connectionStatus setText:@"Status: Not Connected"];
    [self.connectionStatus setTextColor:[UIColor darkGrayColor]];
    [self.connectionStatus setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:16]];
    
    [self.connectBLEBtn.layer setBorderWidth:1.0f];
    [self.connectBLEBtn.layer setBorderColor:[[UIColor cyanColor] CGColor]];
    [self.connectBLEBtn.layer setCornerRadius:15];
    
    [self.deviceInfo setText:@""];
    [self.deviceInfo setTextColor:[UIColor blueColor]];
    [self.deviceInfo setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.deviceInfo setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:25]];
    [self.deviceInfo setUserInteractionEnabled:NO];
    
    // Initialization of CentralManager
    //self.lgCentralManager = [LGCentralManager sharedInstance];
    
    CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.centralManager = centralManager;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - LG Connection Methods

- (IBAction)connectPressed:(UIButton *)sender
{
    NSArray *ddServices = @[[CBUUID UUIDWithString:DD_DISPLAY_SERVICE_UUID],[ CBUUID UUIDWithString:DD_GYRO_SERVICE_UUID]];
    
    [self.centralManager scanForPeripheralsWithServices:ddServices options:nil];
    
    //    // Scaning 4 seconds for peripherals
    //    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:4
    //                                                         completion:^(NSArray *peripherals)
    //     {
    //         // If we found any peripherals sending to test
    //         if (peripherals.count) {
    //             [self testPeripheral:peripherals[0]];
    //         }
    //     }];
    
}

- (void)testPeripheral:(LGPeripheral *)peripheral
{
    // First of all connecting to peripheral
    [peripheral connectWithCompletion:^(NSError *error) {
        // Discovering services of peripheral
        [peripheral discoverServicesWithCompletion:^(NSArray *services, NSError *error) {
            for (LGService *service in services) {
                // Finding out our service
                if ([service.UUIDString isEqualToString:DD_DISPLAY_SERVICE_UUID])
                {
                    // Discovering characteristics of our service
                    NSLog(@"Found Service: %@",service.UUIDString);
                    [service discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
                        // We need to count down completed operations for disconnecting
                        __block int i = 0;
                        for (LGCharacteristic *charact in characteristics) {
                            // cef9 is a writabble characteristic, lets test writting
                            NSLog(@"Found Characteristic: %@",charact.UUIDString);
                            if ([charact.UUIDString isEqualToString:DD_DISPLAY_DATA_CHARACTERISTIC_UUID]) {
                                [charact writeByte:0xFF completion:^(NSError *error) {
                                    if (++i == 3) {
                                        // finnally disconnecting
                                        [peripheral disconnectWithCompletion:nil];
                                    }
                                }];
                            } else {
                                // Other characteristics are readonly, testing read
                                [charact readValueWithBlock:^(NSData *data, NSError *error) {
                                    if (++i == 3) {
                                        // finnally disconnecting
                                        [peripheral disconnectWithCompletion:nil];
                                    }
                                }];
                            }
                        }
                    }];
                }
            }
        }];
    }];
}


#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    self.connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", self.connected);
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0) {
        NSLog(@"Found the DD Service: %@", localName);
        self.deviceInfo.text = [self.deviceInfo.text stringByAppendingString: [NSString stringWithFormat:@"Found: %@\n", localName]];
        [self.centralManager stopScan];
        self.cbPeripheral = peripheral;
        peripheral.delegate = self;
        // Connect to peripheral and read/write data
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
    
}

// method called whenever the device state changes.
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

#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral: didInvalidateServices
{
    NSLog(@"Peripheral Did Invalidate Services invoked.");
    
    // display the peripheral connection status
    
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    int16_t dataToWrite = 10;
    NSData *data = [NSData dataWithBytes:&dataToWrite length:sizeof(dataToWrite)];
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_SERVICE_UUID]])  {  // 1
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_BUSY_CHARACTERISTIC_UUID]]) { // 3
                [self.cbPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a Display Busy characteristic");
            }
            
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_DATA_CHARACTERISTIC_UUID]]) { // 2
                [self.cbPeripheral writeValue:[NSData dataWithBytes:&data length:sizeof(data)] forCharacteristic: aChar type:CBCharacteristicWriteWithResponse];                NSLog(@"Found Display Data characteristic and wrote value %i", dataToWrite);
            }
        }
    }
    // Retrieve Device Gyro Data services
    if ([service.UUID isEqual:[CBUUID UUIDWithString:DD_GYRO_SERVICE_UUID]])  { // 4
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DD_GYRO_DATA_CHARACTERISTIC_UUID]]) {
                [self.cbPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a Gyro Data characteristic");
            }
        }
    }
    
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = [characteristic value];      // 1
    const uint8_t *reportData = [data bytes];
    
    // Retrieve the characteristic value for Gyro data received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_BUSY_CHARACTERISTIC_UUID]]) {  // 3
        NSLog(@"Read Display Busy characteristic: %s", reportData);
        
    }
    
    // Updated value for display data written
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_DATA_CHARACTERISTIC_UUID]]) { // 1
        // CALL HELPER METHOD
        NSLog(@"Updated a Display Data characteristic: %s", reportData);
    }
    // Read the characteristic value Display Busy
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_TARGET_CHARACTERISTIC_UUID]]) {  // 2
        NSLog(@"Read a Display Target characteristic: %s", reportData);
        // Call helper
        
    }
    // Retrieve the characteristic value for Gyro data received
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DD_GYRO_DATA_CHARACTERISTIC_UUID]]) {  // 3
        NSLog(@"Read Gyro Data characteristic: %s", reportData);
        
    }
    
    // Add your constructed device information to your UITextView
    self.deviceInfo.text = [NSString stringWithFormat:@"%@\n%@\n%@\n", self.displayTarget, self.displayDataFound, self.dynamidiceDeviceData];  // 4
}


#pragma mark - CBCharacteristic helpers

// Helper method to get the Display data
- (void) getDisplayData:(LGPeripheral *)peripheral error:(NSError *)error
{
    [LGUtils readDataFromCharactUUID:DD_DISPLAY_DATA_CHARACTERISTIC_UUID
                         serviceUUID:DD_DISPLAY_SERVICE_UUID
                          peripheral:peripheral
                          completion:^(NSData *data, NSError *error){
                              NSLog(@"Data : %s Error : %@", (char *)[data bytes], error);
                              self.displayData = data;
                          }];
    
}

// Helper method to write the Display data
- (void) writeDisplayData:(LGPeripheral *)peripheral dataInBytes:(int32_t)dataToWrite error:(NSError *)error
{
    [LGUtils writeData:[NSData dataWithBytes:&dataToWrite length:sizeof(dataToWrite)]
           charactUUID:DD_DISPLAY_DATA_CHARACTERISTIC_UUID
           serviceUUID:DD_DISPLAY_SERVICE_UUID
            peripheral:peripheral completion:^(NSError *error) {
                NSLog(@"Error : %@", error);
            }];
}

#pragma - Navigation

- (IBAction)cancel:(id)sender
{
    [self.delegate ddBLEViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    [self.delegate ddBLEViewControllerDidSave:self];
}

#pragma - UIModifications


@end

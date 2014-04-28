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
    
    // ErrorFound set to false
    self.errorFound = NO;
    self.connectSuccessBtn.enabled = NO;
    [self.connectSuccessBtn setTintColor:[UIColor redColor]];
    
    // Set status textview
    [self.connectionStatus setText:@"Status: Not Connected"];
    [self.connectionStatus setTextColor:[UIColor darkGrayColor]];
    [self.connectionStatus setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:25]];
    [self.deviceName setTextColor:[UIColor darkGrayColor]];
    [self.deviceName setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:25]];
    
    [self.connectBLEBtn.layer setBorderWidth:1.0f];
    [self.connectBLEBtn.layer setBorderColor:[[UIColor cyanColor] CGColor]];
    [self.connectBLEBtn.layer setCornerRadius:15];
    
    [self.deviceInfo setText:@"DEVICE INFO\n"];
    [self.deviceInfo setTextColor:[UIColor blueColor]];
    [self.deviceInfo setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.deviceInfo setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:22]];
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


#pragma mark - Connection

- (IBAction)connectPressed:(UIButton *)sender
{
    NSArray *ddServices = @[[CBUUID UUIDWithString:DD_DISPLAY_SERVICE_UUID],[ CBUUID UUIDWithString:DD_GYRO_SERVICE_UUID]];
    
    [self.centralManager scanForPeripheralsWithServices:ddServices options:nil];
    
}

#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    self.connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    if (peripheral.state == CBPeripheralStateConnected) {
        [self.connectionStatus setText:@"Status: Connection Established"];
    }
    
    NSLog(@"%@", self.connected);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0) {
        NSLog(@"Found the DD Service: %@", localName);
        self.deviceName.text = [self.deviceName.text stringByAppendingString: [NSString stringWithFormat:@" %@", localName]];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Idiot" message:@"Are you sure you have Bluetooth turned on?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
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
        
        NSLog(@"Discovered service: %@", [service.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_SERVICE_UUID]] ? @"Display Service" : [service.UUID isEqual:[CBUUID UUIDWithString:DD_GYRO_SERVICE_UUID]] ? @"Gyro Service" : service.UUID);

            [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices
{
    NSLog(@"Peripheral Did Invalidate Services invoked.");
    [self.connectionStatus setText:@"Status: Connection Lost"];
    
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    int16_t displayDataToWrite = 0x2;
    NSData *displayData = [NSData dataWithBytes:&displayDataToWrite length:sizeof(displayDataToWrite)];
    
    int16_t targetDataToWrite = 0x1;
    NSData *targetData = [NSData dataWithBytes:&targetDataToWrite length:sizeof(targetDataToWrite)];
    
    // Retrieve Display Data services
    if ([service.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_SERVICE_UUID]])  {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_BUSY_CHARACTERISTIC_UUID]]) {
                [self.cbPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a Display Busy characteristic");
            }
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_TARGET_CHARACTERISTIC_UUID]]) {
                [self.cbPeripheral writeValue:targetData forCharacteristic: aChar type:CBCharacteristicWriteWithoutResponse];                NSLog(@"Found Display Target characteristic and wrote value %i", targetDataToWrite);
                
                self.displayTargetFound = [NSString stringWithFormat:@"Display Target: %i", targetDataToWrite];
                self.deviceInfo.text = [self.deviceInfo.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",self.displayTargetFound]];
            }
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_DATA_CHARACTERISTIC_UUID]]) {
                [self.cbPeripheral writeValue:displayData forCharacteristic: aChar type:CBCharacteristicWriteWithoutResponse];                NSLog(@"Found Display Data characteristic and wrote value %i", displayDataToWrite);
                self.displayDataFound = [NSString stringWithFormat:@"Display Data: %i", displayDataToWrite];
                self.deviceInfo.text = [self.deviceInfo.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",self.displayDataFound]];
            }
        }
    }
    
    // Retrieve Device Gyro Data services
    if ([service.UUID isEqual:[CBUUID UUIDWithString:DD_GYRO_SERVICE_UUID]])  {
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
    // Retrieve the characteristic value for Display Busy
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_BUSY_CHARACTERISTIC_UUID]]) {
        NSLog(@"Reading Display Busy characteristic");
        [self helpGetDisplayBusy:characteristic];
    }
    
    // Retrieve the characteristic value for Gyro data received
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DD_GYRO_DATA_CHARACTERISTIC_UUID]]) {  // 3
        NSLog(@"Reading Gyro Data characteristic");
        [self helpGetGyroData:characteristic];
    }
    
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_DATA_CHARACTERISTIC_UUID]]) {
        NSLog(@"Reading Display Data characteristic that has been written to");
    }
    
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DD_DISPLAY_TARGET_CHARACTERISTIC_UUID]]) {
        NSLog(@"Reading Display Target characteristic that has been written to");
    }
    
    NSLog(@"%@", self.displayBusyFound);
    NSLog(@"%hhd", self.errorFound);
    if (self.errorFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BLE Error" message:@"There was an error checking BLE connection, try again please!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        [self.connectSuccessBtn setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
        self.connectSuccessBtn.enabled = YES;
    }
}

// Invoked when you write data to a characteristic’s value.
- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didWriteValue characterstic: %@", characteristic.UUID);
    if (error) {
        NSLog(@"error didwritevalue: %@", error);
        NSLog(@"Value was not written, reset to last value");
        self.errorFound = YES;
    }
}

#pragma mark - CBCharacteristic helpers

- (void) helpGetGyroData:(CBCharacteristic *)characteristic
{
    NSData *sensorData = [characteristic value];
    uint8_t *gyroData = (uint8_t *)[sensorData bytes];
    NSLog(@"Sensor: %@", sensorData);
    if (gyroData) {
        self.gyroDataFound = [NSString stringWithFormat:@"Gryo Data: %s", gyroData];
        NSLog(@"GyroData Value: %s", gyroData);
        //        if (self.gyroDataFound.length < 12 ) {
        //            self.gyroDataFound = [self.gyroDataFound stringByAppendingString:@"0x0"];
        //        }
    }
    else {
        self.gyroDataFound = [NSString stringWithFormat:@"Gryo Data: N/A"];
    }
    self.deviceInfo.text = [self.deviceInfo.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",self.gyroDataFound]];
    return;
}

- (void) helpGetDisplayBusy:(CBCharacteristic *)characteristic
{
    // Get the Display Busy
    NSData *data = [characteristic value];
    uint8_t *busyData = (uint8_t *) [data bytes];
    
    if (busyData) {
        self.displayBusyFound = [NSString stringWithFormat:@"Display Busy: %s", busyData];
        NSLog(@"DisplayBusy Value: %s", busyData);
        self.deviceInfo.text = [self.deviceInfo.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",self.displayBusyFound]];
        //        if (self.displayBusyFound.length < 16 ) {
        //            self.displayBusyFound = [self.displayBusyFound stringByAppendingString:@"0x0"];
        //        }
    }
    else {
        self.displayBusyFound = [NSString stringWithFormat:@"Display Busy: N/A"];
    }
    return;
}

- (void) helpGetDeviceInfo:(CBCharacteristic *)characteristic
{
    NSLog(@"Unimplemented Method for Device Info Helper");
}

#pragma - Navigation

- (IBAction)cancel:(id)sender
{
    [self.delegate ddBLEViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    [self.delegate ddBLEViewControllerDidConnectSuccessful:self];
}

#pragma - UIModifications

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

@end

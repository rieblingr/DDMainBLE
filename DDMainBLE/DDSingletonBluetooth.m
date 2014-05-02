//
//  DDSingletonBluetooth.m
//  DDMainBLE
//
//  Created by Kenneth Siu on 4/28/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDSingletonBluetooth.h"

@implementation DDSingletonBluetooth

+(id)singleton {
    static DDSingletonBluetooth *singleton;
    static dispatch_once_t once;
    dispatch_once (&once, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

-(void) getGyroData {
    [self initBluetooth:NO];
}

- (void)startTransferWithArray:(NSMutableArray *)array withBitmask:(char)dispBitmask {
    self.table = array;
    self.dispBitMask = dispBitmask;
    [self initBluetooth:YES];
}

- (void) initBluetooth:(BOOL) isDisplay {
    self.isDisplay = isDisplay;

    if(self.centralManager == nil) {
        // Setup services
        self.ddServices = @[[CBUUID UUIDWithString:DISPLAY_DATA_SERVICE_UUID], [CBUUID UUIDWithString:DISPLAY_INFO_SERVICE_UUID],[ CBUUID UUIDWithString:GYRO_SERVICE_UUID]];
        
        //set write type
        self.writeType = CBCharacteristicWriteWithoutResponse;
        
        // Initialize Central Manager
        CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.centralManager = centralManager;
        
        [self.centralManager scanForPeripheralsWithServices:self.ddServices options:nil];
    } else {
        if(self.isDisplay) {
            [self sendTarget:NO];
        } else {
            [self requestGyroData];
        }
        
    }
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
        self.peripheral.delegate = self;
        // Connect to peripheral and read/write data
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect to DD Peripheral");
    [self.peripheral setDelegate:self];
    
    [self.peripheral discoverServices:nil];
}


#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"Services discovered");
    self.peripheral = peripheral;
    for (CBService *service in peripheral.services) {
        NSLog(@"Service: %@", service.UUID);
        
        // Display services
        if([service.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_INFO_SERVICE_UUID]]) {
            NSLog(@"Found Info Service");
            [self.peripheral discoverCharacteristics:nil forService:service];
        }
        
        // Gyroscope services
        if([service.UUID isEqual:[CBUUID UUIDWithString:GYRO_SERVICE_UUID]]) {
            NSLog(@"Found Gyroscope Service");
            [self.peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_INFO_SERVICE_UUID]]) {
        NSLog(@"Discovered info service");
        self.dispInfoService = service;
        //now go to send target function
        if(self.isDisplay) {
           [self sendTarget:YES];
        }
    }
    
    
    if([service.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_DATA_SERVICE_UUID]]) {
        NSLog(@"Discovered data service");
        self.dispDataService = service;
        
        //after calling that, now send data
        [self sendData];
    }
    
    // Gyroscope  service
    if([service.UUID isEqual:[CBUUID UUIDWithString:GYRO_SERVICE_UUID]]) {
        self.gyroService = service;
        if(self.isDisplay == NO) {
            for (CBCharacteristic *aChar in service.characteristics) {
                
                // Gyroscope X-axis char
                if([aChar.UUID isEqual:[CBUUID UUIDWithString:GYRO_X_CHARACTERISTIC_UUID]]) {
                    NSLog(@"Calling read function on X Axis char");
                    [self.peripheral readValueForCharacteristic:aChar];
                }
                
                // Gyroscope Y-axis Char
                if([aChar.UUID isEqual:[CBUUID UUIDWithString:GYRO_Y_CHARACTERISTIC_UUID]]) {
                    NSLog(@"Calling read function on Y Axis char");
                    [self.peripheral readValueForCharacteristic:aChar];
                }
                
                // Gyroscope Z-Axis Char
                if([aChar.UUID isEqual:[CBUUID UUIDWithString:GYRO_Z_CHARACTERISTIC_UUID]]) {
                    NSLog(@"Calling read function on Z Axis char");
                    [self.peripheral readValueForCharacteristic:aChar];
                }
            }
        }
    }
}

// Invoked when you retrieve a specified characteristic’s value, or when the peripheral device notifies your app that the characteristic’s value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Receiving callback for reading Gyro Characteristics");
    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:GYRO_X_CHARACTERISTIC_UUID]]) {
        NSLog(@"Found X Char, Reading X Axis Data");
        [self readAxisData:characteristic error:error withValue:0];
    }
    
    // Gyroscope Y-axis Service
    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:GYRO_Y_CHARACTERISTIC_UUID]]) {
        NSLog(@"Found Y Char, Reading Y Axis Data");
        [self readAxisData:characteristic error:error withValue:1];
    }
    
    // Gyroscope Z-Axis Service
    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:GYRO_Z_CHARACTERISTIC_UUID]]) {
        NSLog(@"Found Z Char, Reading Z Axis Data");
        [self readAxisData:characteristic error:error withValue:2];
    }
}

#pragma mark - Display Service Helper Methods

- (void) sendTarget:(BOOL)isInitial {
    
    //run through characteristics
    for (CBCharacteristic *aChar in self.dispInfoService.characteristics)
    {
        if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_INFO_TARGET_CHARACTERISTIC_UUID]]) {
            NSLog(@"Setting Bitmask");
            char tempInt = self.dispBitMask;
            NSData *tempData = [NSData dataWithBytes:&tempInt length:sizeof(tempInt)];
            [self.peripheral writeValue:tempData forCharacteristic:aChar type:self.writeType];
            
            if(isInitial) {
                for(CBService *dataService in self.peripheral.services) {
                    if ([dataService.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_DATA_SERVICE_UUID]]) {
                        NSLog(@"Found display service");
                        [self.peripheral discoverCharacteristics:nil forService:dataService];
                    }
                }
            } else {
                [self sendData];
            }
        }
    }
}

- (void) requestGyroData {
    
}

- (void) sendData {
    NSLog(@"Sending Data");
    
    self.data = [DDSingletonArray makeData:self.table];
    for(char i = 0; i < [self.data count]; i++) {
        NSData *tempData = [self.data objectAtIndex:i];
        unsigned char* readData = (unsigned char*) [tempData bytes];
        
        //make a new string based off of i
        NSString *currChar = [NSString stringWithFormat:@"%@%02x", DISPLAY_DATA_BASE_CHARACTERISTIC_UUID, i+1];
        
        NSLog(@"Using Char: %@", currChar);
        
        //send data
        for(CBCharacteristic *aChar in self.dispDataService.characteristics) {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:currChar]]) {
                char test[4];
                test[0] = readData[0];
                test[1] = readData[1];
                test[2] = readData[2];
                test[3] = readData[3];
                
                NSData *sendData = [NSData dataWithBytes:test length:sizeof(test)];
                
                NSLog(@"Writing index: %i", i);
                [self.peripheral writeValue:sendData forCharacteristic:aChar type:self.writeType];
            }
        }
        
    }
    
    //sleep to ensure this works (magic number 0.4)
    [NSThread sleepForTimeInterval:0.4f];
    
    //now that we wrote, write 1 to busy signal
    for(CBCharacteristic *aChar in self.dispInfoService.characteristics) {
        if([aChar.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_INFO_BUSY_CHARACTERISTIC_UUID]]) {
            
            char busy = 1;
            
            NSData *sendData = [NSData dataWithBytes:&busy length:sizeof(busy)];
            [self.peripheral writeValue:sendData forCharacteristic:aChar type:self.writeType];
        }
    }
    
    NSLog(@"DONE");
    [self.delegate finishedSending];
}

#pragma mark - Gyro Service Helper Methods

- (void) readAxisData:(CBCharacteristic*)characteristic error:(NSError*)error withValue:(int)axis {
    
    if (error) {
        NSLog(@"Error reading data: %@", error);
    }
    
    NSData *data = [characteristic value];
    
    unsigned char *readData = (unsigned char*) [data bytes];
    
    if(axis == 0) {
        NSLog(@"X Data: %@", data);
        [self.gyroDelegate receivedXValue:readData];
    } else if(axis == 1) {
        NSLog(@"Y Data: %@", data);
        [self.gyroDelegate receivedYValue:readData];
    } else {
        NSLog(@"Z Data: %@", data);
        [self.gyroDelegate receivedZValue:readData];
    }
}


- (void) disconnect {
    if(self.centralManager != nil) {
        [self.centralManager cancelPeripheralConnection:self.peripheral];
        self.centralManager = nil;
    }
}

@end

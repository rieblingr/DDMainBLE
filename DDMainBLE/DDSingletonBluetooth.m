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

- (void)startTransferWithArray:(NSMutableArray *)array withBitmask:(char)dispBitmask {
    self.table = array;
    self.dispBitMask = dispBitmask;
    [self initBluetooth];
}


- (void) initBluetooth {
    
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
        [self sendTarget:NO];
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
        if([service.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_INFO_SERVICE_UUID]]) {
            NSLog(@"Found Info Service");
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
        [self sendTarget:YES];
    }
    
    
    if([service.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_DATA_SERVICE_UUID]]) {
        NSLog(@"Discovered data service");
        self.dispDataService = service;
        
        //after calling that, now send data
        [self sendData];
    }
    
}

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

- (void) disconnect {
    if(self.centralManager != nil) {
        [self.centralManager cancelPeripheralConnection:self.peripheral];
        self.centralManager = nil;
    }
}


@end

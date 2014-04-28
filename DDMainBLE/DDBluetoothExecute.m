//
//  DDBluetoothExecute.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDBluetoothExecute.h"

@implementation DDBluetoothExecute

-(id) init {
    self = [super init];
    
    if(self) {
        NSLog(@"Created Bluetooth Object");
    }
    
    return self;
}

- (void) startTransferWithArray:(NSMutableArray*)array withBitmask:(int)dispBitmask {
    NSLog(@"HELLO");
    self.data = array;
    self.dispBitMask = dispBitmask;
    [self initBluetooth];
}

- (void) initBluetooth {
    // Setup services
    self.ddServices = @[[CBUUID UUIDWithString:DISPLAY_SERVICE_UUID],[ CBUUID UUIDWithString:GYRO_SERVICE_UUID]];
    
    //set write type
    self.writeType = CBCharacteristicWriteWithoutResponse;
    
    // Initialize Central Manager
    CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.centralManager = centralManager;
    
    [self.centralManager scanForPeripheralsWithServices:self.ddServices options:nil];
}

# pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"HITS HERE");
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
    NSLog(@"HITS HERE 2");
    
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
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_SERVICE_UUID]]) {
            self.displayService = service;
            [self.peripheral discoverCharacteristics:nil forService:service];
        }
        if ([service.UUID isEqual:[CBUUID UUIDWithString:GYRO_SERVICE_UUID]]) {
            self.gyroService = service;
            
        }
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    self.displayService = service;
    
    for (CBCharacteristic *aChar in service.characteristics)
    {
        if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_TARGET_CHARACTERISTIC_UUID]]) {
            NSLog(@"Setting Bitmask");
            int tempInt = self.dispBitMask;
            NSData *tempData = [NSData dataWithBytes:&tempInt length:sizeof(tempInt)];
            [self.peripheral writeValue:tempData forCharacteristic:aChar type:self.writeType];
            
            //after calling that, now send data
            [self sendData];
        }
        
    }
    
}

- (void) sendData {
    NSLog(@"Sending Data");
    
    for(int i = 0; i < [self.data count]; i++) {
        NSData *tempData = [self.data objectAtIndex:i];
        
        //send index
        for(CBCharacteristic *aChar in self.displayService.characteristics) {
            
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_INDEX_CHARACTERISTIC_UUID]]) {
                
                NSData *tempIndexData = [NSData dataWithBytes:&i length:sizeof(i)];
                [self.peripheral writeValue:tempIndexData forCharacteristic:aChar type:self.writeType];
            }
        }
        
        //send data
        for(CBCharacteristic *aChar in self.displayService.characteristics) {
            
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_DATA_CHARACTERISTIC_UUID]]) {
                [self.peripheral writeValue:tempData forCharacteristic:aChar type:self.writeType];
            }
        }
        
    }
    
    [self.delegate finishedTransfer];
}


@end

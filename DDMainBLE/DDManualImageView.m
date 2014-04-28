//
//  DDManualImageView.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDManualImageView.h"

@implementation DDManualImageView

- (id)initWithFrame:(CGRect)frame withArray:(NSMutableArray *)buttons
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //button size is size of screen divided by the pixels of image
        self.BUTTON_SIZE = (CGFloat) ([[UIScreen mainScreen] bounds].size.width / IMAGE_WIDTH);
        
        //set draw to true (start state is in drawing state)
        
        //initialize array
        self.table = buttons;
        
        //now add all the buttons in subview
        for(int i = 0; i < IMAGE_HEIGHT; i++) {
            NSMutableArray *array = [buttons objectAtIndex:i];
            for(int j = 0; j < IMAGE_WIDTH; j++) {
                DDButtonCreateImage *button = [array objectAtIndex:j];
                [self addSubview:button];
            }
        }
        
        
        //make the buttons on the bottom
        self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        //get the height of the last button
        NSMutableArray *arr = [self.table objectAtIndex:[self.table count] - 1];
        UIButton *button = [arr objectAtIndex:0];
        
        CGFloat height = [button frame].origin.y + [button frame].size.height;
        
        //done button
        [self.sendButton setFrame:CGRectMake(([self frame].size.width / 2) - (CONTROL_WIDTH / 2), height + CONTROL_HEIGHT_OFFSET * 3, CONTROL_WIDTH, CONTROL_HEIGHT)];
        [self.sendButton setTitle:@"Done" forState:UIControlStateNormal];
        [self addSubview:self.sendButton];
        
        //now set the targets to here
        [self.sendButton addTarget:self action:@selector(sendImage) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (IBAction)sendImage {
    self.data = [DDSingletonArray makeData:self.table];
    
    [self startTransferWithArray:self.data withBitmask:0];
}

//bluetooth delegate function
- (void) finishedTransfer {
    NSLog(@"FINISH");
}


//all the bluetooth things
- (void) startTransferWithArray:(NSMutableArray*)array withBitmask:(int)dispBitmask {
    NSLog(@"HELLO");
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
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_SERVICE_UUID]]) {
            NSLog(@"Found display service");
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
    NSLog(@"Received characteristics");
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
    
    self.data = [DDSingletonArray makeData:self.table];
    for(char i = 0; i < [self.data count]; i++) {
        NSData *tempData = [self.data objectAtIndex:i];
        unsigned char* readData = (unsigned char*) [tempData bytes];
        
        //send index
        if(i != 0) {
            for(CBCharacteristic *aChar in self.displayService.characteristics) {
                
                if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_INDEX_CHARACTERISTIC_UUID]]) {
                    
                    NSData *tempIndexData = [NSData dataWithBytes:&i length:sizeof(i)];
                    
                    [self.peripheral writeValue:tempIndexData forCharacteristic:aChar type:self.writeType];
                }
            }
        }

        [NSThread sleepForTimeInterval:0.4f];

        //send data
        for(CBCharacteristic *aChar in self.displayService.characteristics) {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DISPLAY_DATA_CHARACTERISTIC_UUID]]) {
                char test[4];
                test[0] = readData[0];
                test[1] = readData[1];
                test[2] = readData[2];
                test[3] = readData[3];
                
                NSData *sendData = [NSData dataWithBytes:test length:sizeof(test)];
                
                [self.peripheral writeValue:sendData forCharacteristic:aChar type:self.writeType];
                
                if(i == 0) {
                    [NSThread sleepForTimeInterval:0.4f];
                }
            }
        }
        
    }
    
    [self.centralManager cancelPeripheralConnection:self.peripheral];
    NSLog(@"DONE");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

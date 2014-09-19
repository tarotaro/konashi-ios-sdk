#import "KonashiUtils.h"
#import <CoreBluetooth/CoreBluetooth.h>

NSString *NSStringFromCBCentralManagerState(CBCentralManagerState state){
    NSString *ret;
    switch (state) {
    case CBCentralManagerStateUnknown:
        ret = @"Unknown";
        break;
    case CBCentralManagerStateResetting:
        ret = @"Resetting";
        break;
    case CBCentralManagerStateUnsupported:
        ret = @"Unsupported";
        break;
    case CBCentralManagerStateUnauthorized:
        ret = @"Unauthorized";
        break;
    case CBCentralManagerStatePoweredOff:
        ret = @"PoweredOff";
        break;
    case CBCentralManagerStatePoweredOn:
        ret = @"PoweredOn";
        break;
    default:
        NSLog( @"unexpected state: %lu", (unsigned long) state );
        ret = @"*UNEXPECTED STATE*";
    }
    return ret;
}

NSString *NSStringFromSingleCBCharacteristicProperty(CBCharacteristicProperties state) {
    NSString *ret;
    switch (state) {
    case CBCharacteristicPropertyBroadcast:
        ret = @"Broadcast";
        break;
    case CBCharacteristicPropertyRead:
        ret = @"Read";
        break;
    case CBCharacteristicPropertyWriteWithoutResponse:
        ret = @"WriteWithoutResponse";
        break;
    case CBCharacteristicPropertyWrite:
        ret = @"Write";
        break;
    case CBCharacteristicPropertyNotify:
        ret = @"Notify";
        break;
    case CBCharacteristicPropertyIndicate:
        ret = @"Indicate";
        break;
    case CBCharacteristicPropertyAuthenticatedSignedWrites:
        ret = @"AuthenticatedSignedWrites";
        break;
    case CBCharacteristicPropertyExtendedProperties:
        ret = @"ExtendedProperties";
        break;
    case CBCharacteristicPropertyNotifyEncryptionRequired:
        ret = @"NotifyEncryptionRequired";
        break;
    case CBCharacteristicPropertyIndicateEncryptionRequired:
        ret = @"IndicateEncryptionRequired";
        break;
    default:
        NSLog( @"unexpected property: %lu", (unsigned long) state );
        ret = @"*UNEXPECTED PROPERTY*";
    }
    return ret;
}

NSString *NSStringFromCFUUIDRef(CFUUIDRef uuid)
{
	if (!uuid) return @"NULL";
	CFStringRef s = CFUUIDCreateString(NULL, uuid);
	return (__bridge NSString *)s;
}

NSString *NSStringFromCBCharacteristicProperty(CBCharacteristicProperties state) {
    NSMutableString *ret                      = nil;
    CBCharacteristicProperties properties[10] = {
        CBCharacteristicPropertyBroadcast,
        CBCharacteristicPropertyRead,
        CBCharacteristicPropertyWriteWithoutResponse,
        CBCharacteristicPropertyWrite,
        CBCharacteristicPropertyNotify,
        CBCharacteristicPropertyIndicate,
        CBCharacteristicPropertyAuthenticatedSignedWrites,
        CBCharacteristicPropertyExtendedProperties,
        CBCharacteristicPropertyNotifyEncryptionRequired,
        CBCharacteristicPropertyIndicateEncryptionRequired
    };
    for (int i=0; i<10; i++) {
        CBCharacteristicProperties property = properties[ i ];
        if (state & property) {
            if ( !ret ) {
                ret = [[NSMutableString alloc] init];
                [ret setString: NSStringFromSingleCBCharacteristicProperty(property)];
            }
            else {
                [ret appendFormat: @"|%@", NSStringFromSingleCBCharacteristicProperty(property)];
            }
        }
    }
    return ret;
}

UInt16 kns_swapUInt16(UInt16 s)
{
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

BOOL kns_compareCFUUIDRef(CFUUIDRef uuid1, CFUUIDRef uuid2)
{
	CFUUIDBytes b1 = CFUUIDGetUUIDBytes(uuid1);
	CFUUIDBytes b2 = CFUUIDGetUUIDBytes(uuid2);
	if (memcmp(&b1, &b2, 16) == 0) {
		return YES;
	}
	else return NO;
}

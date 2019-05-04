#import <React/RCTBridgeModule.h>
#import <HealthKit/HealthKit.h>

@interface RCTSwimDataManager : NSObject <RCTBridgeModule>

@property (nonatomic) HKHealthStore *healthStore;
@property BOOL isSync;

@end


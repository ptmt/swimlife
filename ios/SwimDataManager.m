#import "SwimDataManager.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTConvert.h>

@implementation RCTSwimDataManager

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

//RCT_EXPORT_METHOD(addEvent:(NSString *)name details:(NSDictionary *)details)
//{
//  NSString *location = [RCTConvert NSString:details[@"location"]];
//  NSDate *time = [RCTConvert NSDate:details[@"time"]];
//}

RCT_EXPORT_METHOD(sync:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  self.healthStore = [[HKHealthStore alloc] init];
  
  if ([HKHealthStore isHealthDataAvailable]) {
    NSSet *writeDataTypes = [NSSet setWithArray:@[[HKSampleType workoutType]]]; //HKSampleType
    NSSet *readDataTypes = [NSSet setWithArray:@[[HKObjectType workoutType]]];
  
    [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
      if (!success) {
        reject(@"Sync failure", nil, nil);
        return;
      } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          resolve(@(true));
        });
      }
    }];
  } else {
    reject(@"HealthKit data is not available", nil, nil);
  }
}

-(void)readSamples
{
  
}

@end

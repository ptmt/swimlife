#import "SwimDataManager.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTConvert.h>


@interface NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;

@end

@implementation NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(NSDictionary* (^)(id obj, NSUInteger idx))block {
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [result addObject:block(obj, idx)];
  }];
  return result;
}

@end


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
          NSPredicate *predicate = [HKQuery predicateForWorkoutsWithWorkoutActivityType:HKWorkoutActivityTypeSwimming];
          
          // 2. Order the workouts by date
          NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:HKSampleSortIdentifierStartDate ascending:false];
          
          // 3. Create the query
          HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:[HKWorkoutType workoutType]
                                                                       predicate:predicate
                                                                           limit:HKObjectQueryNoLimit
                                                                 sortDescriptors:@[sortDescriptor]
                                                                  resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error)
                                        {
                                          
                                          if(!error && results){
                                            NSLog(@"Retrieved the following workouts %lu", (unsigned long)results.count);
                                            NSLog(@"workout %@", results.firstObject);
                                            resolve([results mapObjectsUsingBlock:^(id obj, NSUInteger idx) {
                                              HKWorkout *workout = (HKWorkout *)obj;
                                              
                                              return @{
                                                       @"index": @(idx),
                                                       @"duration": @(workout.duration),
                                                       @"startDate": @(workout.startDate.timeIntervalSince1970),
                                                       @"endDate": @(workout.endDate.timeIntervalSince1970)
                                                       };
                                            }]);
                                          } else {
                                            reject(@"Error retrieving workouts %@", nil, nil);
                                          }
                                        }];
          
          // Execute the query
          [self.healthStore executeQuery:sampleQuery];
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


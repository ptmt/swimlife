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

RCT_EXPORT_METHOD(sync:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  self.healthStore = [[HKHealthStore alloc] init];
  
  if ([HKHealthStore isHealthDataAvailable]) {
    NSSet *writeDataTypes = [NSSet setWithArray:@[[HKSampleType workoutType]]]; //HKSampleType
    NSSet *readDataTypes = [NSSet setWithArray:@[
                                                 [HKObjectType workoutType],
                                                 [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                                                 [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceSwimming]]];
  
    [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
      if (!success) {
        reject(@"Sync failure", nil, nil);
        return;
      } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          NSPredicate *predicate = [HKQuery predicateForWorkoutsWithWorkoutActivityType:HKWorkoutActivityTypeSwimming];
          
          NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:HKSampleSortIdentifierStartDate ascending:false];
          
          HKSampleQuery *sampleQuery = [[HKSampleQuery alloc]
                                        initWithSampleType:[HKWorkoutType workoutType]
                                        predicate:predicate
                                        limit:HKObjectQueryNoLimit
                                        sortDescriptors:@[sortDescriptor]
                                        resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error)
                                        {
                                          
                                          if(!error && results){
                                            NSLog(@"Retrieved %lu workouts", (unsigned long)results.count);
                                            resolve([results mapObjectsUsingBlock:^(id obj, NSUInteger idx) {
                                              HKWorkout *workout = (HKWorkout *)obj;
                                              HKQuantity *lapLength = workout.metadata[HKMetadataKeyLapLength];
                                              
                                              NSArray *events = @[];
                                              
                                              events = [workout.workoutEvents  mapObjectsUsingBlock:^(id obj, NSUInteger idx) {
                                                HKWorkoutEvent *event = (HKWorkoutEvent *)obj;
                                               
                                                
                                                NSDate *startDate, *endDate;
                                                if (@available(iOS 11.0, *)) {
                                                  startDate = event.dateInterval.startDate;
                                                } else {
                                                  startDate = event.date;
                                                }
                                                
                                                if (@available(iOS 11.0, *)) {
                                                  endDate = event.dateInterval.endDate;
                                                } else {
                                                  endDate = nil;
                                                }
                                                
                                                return @{
                                                         @"type": @(event.type),
                                                         @"startDate": @(startDate.timeIntervalSince1970),
                                                         @"endDate": @(endDate.timeIntervalSince1970),
                                                         @"metadata": event.metadata};
                                              }];
                                              
                                              NSLog(@"Got %li events", events.count);
                                              
                                              return @{
                                                       @"uuid": workout.UUID.UUIDString,
                                                       @"duration": @(workout.duration),
                                                       @"startDate": @(workout.startDate.timeIntervalSince1970),
                                                       @"endDate": @(workout.endDate.timeIntervalSince1970),
                                                       @"lapLength": @([lapLength doubleValueForUnit:[HKUnit meterUnit]]),
                                                       @"events":events.count > 0 ? events : @[]
                                                    };
                                                     
                                            }]);
                                          } else {
                                            reject(@"Error retrieving workouts %@", nil, nil);
                                          }
                                        }];
          
          [self.healthStore executeQuery:sampleQuery];
        });
      }
    }];
  } else {
    reject(@"HealthKit data is not available", nil, nil);
  }
}

RCT_EXPORT_METHOD(readSamplesForWorkout:(NSString*)uuidString
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  
//  HKQuantityType* heartRate = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
//
//
//  NSLog(@"workoutUUID %@", uuidString);
//  HKSampleQuery *heartRateQuery = [[HKSampleQuery alloc]
//                                initWithSampleType:heartRate
//                                predicate:[HKQuery predicateForObjectWithUUID:workoutUUID]
//                                limit:HKObjectQueryNoLimit
//                                sortDescriptors:@[]
//                                resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error)
//                                {
//                                  NSLog(@"hr results %lu %@", (unsigned long)results.count, error);
//                                }];
  [self findWorkout:uuidString completion:^(HKWorkout *workout) {
    HKQuantityType* sample = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceSwimming];
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc]
                                  initWithSampleType:sample
                                  predicate:[HKQuery predicateForObjectsFromWorkout:workout]
                                  limit:HKObjectQueryNoLimit
                                  sortDescriptors:@[]
                                  resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error)
                                  {
                                    
                                    NSLog(@"swim results %lu %@", (unsigned long)results.count, error.localizedDescription);
                                    resolve([results mapObjectsUsingBlock:^(id obj, NSUInteger idx) {
                                      HKSample *sample = (HKSample *)obj;
                                      
                                      return @{
                                               @"uuid": sample.UUID.UUIDString
                                               
                                               };
                                    }]);
                                  }];
    
    [self.healthStore executeQuery:sampleQuery];
  }];
}

-(void)findWorkout:(NSString *)uuidString completion:(void (^)(HKWorkout * workout))completion {
  NSUUID *workoutUUID = [[NSUUID alloc] initWithUUIDString:uuidString];
  HKSampleQuery *query = [[HKSampleQuery alloc]
                                   initWithSampleType:[HKWorkoutType workoutType]
                                   predicate:[HKQuery predicateForObjectWithUUID:workoutUUID]
                                   limit:HKObjectQueryNoLimit
                                   sortDescriptors:@[]
                                   resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error)
                                   {
                                     NSLog(@"hr results %lu %@", (unsigned long)results.count, error);
                                     if (error || results.count == 0) {
                                       completion(nil);
                                     } else {
                                       completion(results.firstObject);
                                     }
                                   }];
  
  [self.healthStore executeQuery:query];
}

@end


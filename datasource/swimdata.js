// @flow
import { NativeModules } from "react-native";

const { SwimDataManager } = NativeModules;

export async function sync() {
  const workouts = await SwimDataManager.sync();
  // return workouts.map(async workout => {
  //   //const samples = await SwimDataManager.readSamplesForWorkout(workout.uuid);
  //   console.log(workout);
  //   return {
  //     ...workout
  //     // samples
  //   };
  // });
  return workouts;
}

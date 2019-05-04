// @flow
import { NativeModules } from "react-native";

const { SwimDataManager } = NativeModules;

export async function sync() {
  console.log("SwimDataManager", SwimDataManager);
  const result = await SwimDataManager.sync();
  console.log("synced", result);
  // return new Promise(resolve => {
  //   AppleHealthKit.initHealthKit(options, (err, results) => {
  //     if (err) {
  //       console.log("error initializing Healthkit: ", err);
  //       return;
  //     }
  //
  //     console.log(results);
  //   });
  // });
}

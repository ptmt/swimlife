// @flow
import { NativeModules } from "react-native";

const { SwimDataManager } = NativeModules;

export async function sync() {
  const result = await SwimDataManager.sync();
  return result;
}

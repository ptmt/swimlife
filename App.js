import React from "react";
import { createStackNavigator, createAppContainer } from "react-navigation";

import MainScreen from "./MainScreen";
import SwimDetails from "./SwimDetailsScreen";

const AppNavigator = createStackNavigator({
  Home: {
    screen: MainScreen
  },
  SwimDetails: {
    screen: SwimDetails
  }
});

/* 

* describe something here
* and here

*/
export default createAppContainer(AppNavigator);

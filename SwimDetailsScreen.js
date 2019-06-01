// @flow
import React from "react";

import {
  Text,
  View,
  ScrollView,
  StyleSheet,
  TouchableOpacity
} from "react-native";
import { human, iOSColors } from "react-native-typography";

import LinearGradient from "react-native-linear-gradient";
import moment from "moment";

/*
HKSwimmingStrokeStyleBackstroke
The user swam the backstroke.

HKSwimmingStrokeStyleBreaststroke
The user swam the breaststroke.

HKSwimmingStrokeStyleButterfly
The user swam the butterfly stroke.

HKSwimmingStrokeStyleFreestyle
The user swam the freestyle stroke.

HKSwimmingStrokeStyleMixed
The user swam a mixture of strokes.

HKSwimmingStrokeStyleUnknown
The user’s stroke could not be determined.
 */

export default function SwimDetailsScreen({ navigation }) {
  const workout = navigation.getParam("workout");
  return (
    <ScrollView>
      <Text>Swim details</Text>
      {workout.events.map(e => (
        <Text key={e.endDate} style={styles.event}>
          {JSON.stringify(e)}
        </Text>
      ))}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  event: {
    margin: 10
  }
});

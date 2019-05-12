// @flow
import React from "react";

import {
  Text,
  View,
  StyleSheet,
  TouchableOpacity,
  ImageBackground
} from "react-native";
import { human, iOSColors } from "react-native-typography";

import LinearGradient from "react-native-linear-gradient";
import moment from "moment";

type Workout = {
  index: Number,
  startDate: Number,
  endDate: Number,
  duration: Number
};

function WorkoutLabel({ text }) {
  return (
    <Text
      numberOfLines={1}
      style={{
        ...human.caption1WhiteObject,
        backgroundColor: "darkblue",
        borderRadius: 2,
        paddingHorizontal: 4,
        flex: 0,
        margin: 3
      }}
    >
      {text}
      {/*<Text style={{ ...human.caption1WhiteObject }}>{text}</Text>*/}
    </Text>
  );
}

export default function WorkoutWidget({ workout }: { workout: Workout }) {
  return (
    <TouchableOpacity style={styles.recentlyPlayedSong}>
      <LinearGradient
        colors={["#36D1DC", "#5B86E5"]}
        style={styles.recentlyPlayedSongCover}
      >
        <Text style={styles.widgetHeader}>
          {moment(workout.startDate * 1000)
            .calendar()
            .toUpperCase()}{" "}
          ‧ {Math.round(moment.duration(workout.duration * 1000).asMinutes())}{" "}
          min
        </Text>

        <Text>{workout.lapLength}</Text>
        {/*<Text style={styles.widgetStat}>*/}
        {/*  Highlights: <Text style={{ fontSize: 18 }}>16x100</Text>free 28hr,{" "}*/}
        {/*  <Text style={{ fontSize: 18 }}>50</Text>*/}
        {/*  HRV*/}
        {/*</Text>*/}
        {/*<View style={{ flex: 1, flexWrap: "wrap", flexDirection: "row" }}>*/}
        {/*  <WorkoutLabel text={"Personal Record"} />*/}
        {/*  <WorkoutLabel text={"SwimLab"} />*/}
        {/*</View>*/}
      </LinearGradient>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  recentlyPlayedSong: {
    marginRight: 8
  },
  recentlyPlayedSongCover: {
    height: 160,
    width: 160,
    borderRadius: 6
  },
  album: {
    ...human.footnoteObject,
    marginTop: 5
  },
  author: {
    ...human.footnoteObject,
    color: iOSColors.gray
  },
  touchableRoundedImage: {
    flex: 1,
    height: undefined,
    width: undefined,
    flexDirection: "column",
    justifyContent: "space-between",
    alignItems: "flex-start"
  },
  widgetHeader: {
    fontSize: 14,
    fontWeight: "600",
    textAlign: "center",
    margin: 12,
    color: "white",
    backgroundColor: "transparent"
  },
  widgetStat: {
    ...human.bodyObject,

    marginLeft: 12
  }
});

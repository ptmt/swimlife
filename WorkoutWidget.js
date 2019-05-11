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

const recents = [
  {
    album: "Time Of Mirrors",
    author: "Chaotic Hook",
    cover: require("./assets/angel-jimenez-168185_2x.png")
  },
  {
    album: "Last Chances",
    author: "Seizing Mistake",
    cover: require("./assets/paul-morris-144777_2x.png")
  },
  {
    album: "No Tales",
    author: "Misconduct",
    cover: require("./assets/sasha-freemind-186664_2x.png")
  }
];

type Workout = {
  index: Number,
  startDate: Number,
  endDate: Number,
  duration: Number
};

export default function WorkoutWidget({ workout }: { workout: Workout }) {
  console.log(workout);
  return (
    <TouchableOpacity style={styles.recentlyPlayedSong}>
      <LinearGradient
        colors={["#B2FEFA", "#0ED2F7"]}
        style={styles.recentlyPlayedSongCover}
      >
        <Text style={styles.buttonText}>
          {moment(workout.startDate * 1000)
            .calendar()
            .toUpperCase()}
        </Text>
        <Text style={styles.buttonText}>
          {Math.round(moment.duration(workout.duration * 1000).asMinutes())} min
        </Text>
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
  linearGradient: {
    flex: 1,
    paddingLeft: 15,
    paddingRight: 15,
    borderRadius: 5
  },
  buttonText: {
    fontSize: 16,
    fontWeight: "600",
    textAlign: "center",
    margin: 6,
    backgroundColor: "transparent"
  }
});

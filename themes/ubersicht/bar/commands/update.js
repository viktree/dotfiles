var cp = require("child_process"),
  Promise = require("node-promise").Promise,
  all = require("node-promise").all,
  strftime = require("strftime"),
  batteryLevel = require("battery-level"),
  spotify = require("spotify-node-applescript");

const getActiveWindow = () => {
  var awPromise = new Promise();
  var script =
    "osascript -e 'tell application \"System Events\"' -e 'set frontApp to name of first application process whose frontmost is true' -e 'end tell'";
  cp.exec(script, (err, stdout) => {
    var program = stdout.replace("\n", "");
    if (program === "Electron") {
      awPromise.resolve("VSCode");
      return;
    }
    if (program === "firefox") {
      awPromise.resolve("Firefox");
      return;
    }
    awPromise.resolve(program);
  });
  return awPromise;
};

const spotifyPlaying = () =>
  spotify.getState((err, s) => {
    const state = {
      track: "",
      playing: false,
      source: "spotify"
    };
    try {
      state.playing = s.state == "playing";
      spotify.getTrack((err, track) => {
        state.track = track.artist + " - " + track.name;
      });
    } catch (err) {}
    return new Promise().resolve(state);
  });

all([batteryLevel(), spotifyPlaying(), getActiveWindow()]).then(data => {
  running = {
    browser: "",
    time: strftime("%l:%M"),
    date: strftime("%a %d %b"),
    battery: data[0] * 100,
    spotify: data[1],
    active: data[2]
  };
  console.log(JSON.stringify(running));
});

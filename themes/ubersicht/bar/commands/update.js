var cp = require('child_process'),
	Promise = require('node-promise').Promise,
	all = require('node-promise').all,
	strftime = require('strftime'),
	batteryLevel = require('battery-level'),
	spotify = require('spotify-node-applescript');

const getActiveWindow = () => {
	var awPromise = new Promise();
	var script =
		"osascript -e 'tell application \"System Events\"' -e 'set frontApp to name of first application process whose frontmost is true' -e 'end tell'";
	cp.exec(script, (err, stdout) => {
		var program = stdout.replace('\n', '');
		if (program === 'Electron') {
			awPromise.resolve('VSCode');
			return;
		}
		if (program === 'firefox') {
			awPromise.resolve('Firefox');
			return;
		}
		awPromise.resolve(program);
	});
	return awPromise;
};

var spotifyPlaying = function() {
	var promise = new Promise();
	var state = {
		track: '',
		playing: false,
		source: 'spotify',
	};

	spotify.getState(function(err, s) {
		if (!err && !!s) {
			state.playing = s.state == 'playing';
			if (state.playing) {
				spotify.getTrack(function(err, track) {
					if (!err && !!track && state.playing) {
						state.track = track.artist + ' - ' + track.name;
					}
					promise.resolve(state);
				});
			} else {
				promise.resolve(state);
			}
		} else {
			promise.resolve(state);
		}
	});

	return promise;
};

var playing = {
	browser: '',
	date: strftime('%a %d %b'),
	time: strftime('%l:%M'),
	active: getActiveWindow(),
};

var promises = [
	// Update battery level
	batteryLevel(),
	spotifyPlaying(),
	getActiveWindow(),
];

var p = all(promises);
p.then(function(data) {
	playing.battery = data[0] * 100;
	playing.spotify = data[1];
	playing.active = data[2];
	console.log(JSON.stringify(playing));
});

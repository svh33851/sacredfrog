
//const apiBaseUrl = 'http://198.58.103.58:5001';
const apiBaseUrl = 'https://prayer.bookofsaintpepe.com'; 

// Submit a prayer
document.getElementById('submitButton').addEventListener('click', () => {
	const prayerText = document.getElementById('prayerInput').value;
	const agreedToTerms = document.getElementById('termsCheckbox').checked;

	if (!prayerText) {
		alert('Please enter a prayer!');
		return;
	}

	if (!agreedToTerms) {
		alert('You must agree to the sacred terms!');
		return;
	}

	const data = {
		text: prayerText,
		agreed_to_terms: agreedToTerms
	};

	fetch(`${apiBaseUrl}/submit-prayer`, {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
		},
		body: JSON.stringify(data),
	})
	.then(response => response.json())
	.then(data => {
		alert(data.message || 'Prayer submitted successfully!');
		document.getElementById('prayerInput').value = '';
		document.getElementById('termsCheckbox').checked = false;
	})
	.catch(error => {
		console.error('Error:', error);
		alert('Failed to submit the prayer.');
	});
});

// Fetch recent prayers
document.getElementById('fetchButton').addEventListener('click', () => {
	const limit = prompt('How many prayers would you like to fetch?', '5') || '5';

	fetch(`${apiBaseUrl}/get-prayers?limit=${limit}`)
	.then(response => response.json())
	.then(data => {
		const prayersContainer = document.getElementById('prayersContainer');
		prayersContainer.innerHTML = '';
		data.forEach(prayer => {
			const listItem = document.createElement('li');
			listItem.textContent = `${prayer.text}`;
			prayersContainer.appendChild(listItem);
		});
	})
	.catch(error => {
		console.error('Error:', error);
		alert('Failed to fetch prayers.');
	});
});



function updateBreakpoint() {
	const display = document.getElementById('breakpointDisplay');
	const width = window.innerWidth;
	let size = '';

	if (width < 568) {
		size = 'pure-u-xs-* (xs)';
	} else if (width >= 568 && width < 768) {
		size = 'pure-u-sm-* (sm)';
	} else if (width >= 768 && width < 1024) {
		size = 'pure-u-md-* (md)';
	} else if (width >= 1024 && width < 1280) {
		size = 'pure-u-lg-* (lg)';
	} else if (width >= 1280 && width < 1920) {
		size = 'pure-u-xl-* (xl)';
	} else if (width >= 1920 && width < 2560) {
		size = 'pure-u-xxxl-* (xxxl)';
	} else {
		size = 'pure-u-x4k-* (x4k)';
	}

	display.textContent = `Width: ${width}px | Breakpoint: ${size}`;
}

// Update on page load
window.onload = updateBreakpoint;
// Update on window resize
window.onresize = updateBreakpoint;


// POPUS


// Popups
function openPopup(id) {
	document.getElementById('overlay').style.display = 'block';
	document.getElementById(id).style.display = 'block';
}

function closePopup() {
	document.getElementById('overlay').style.display = 'none';
	document.querySelectorAll('.popup').forEach(popup => popup.style.display = 'none');
}

// PLAYER

// Floating button and music player toggle
const floatingButton = document.getElementById('floating-button');
const musicPlayer = document.getElementById('music-player');
const minimizeButton = document.getElementById('minimize-button');

floatingButton.addEventListener('click', () => {
	musicPlayer.style.display = 'flex';
	floatingButton.style.display = 'none';
});

minimizeButton.addEventListener('click', () => {
	musicPlayer.style.display = 'none';
	floatingButton.style.display = 'block';
});

// New music player
const audio = new Audio();
const songListElem = document.getElementById('song-list');
const nowPlayingElem = document.getElementById('now-playing');
const currentTimeElem = document.getElementById('current-time');
const durationElem = document.getElementById('duration');
const seekbar = document.getElementById('seekbar');
const playPauseButton = document.getElementById('play-pause');
const prevButton = document.getElementById('prev');
const nextButton = document.getElementById('next');
const shuffleButton = document.getElementById('shuffle');
const volumeControl = document.getElementById('volume');

let songs = [];
let currentIndex = 0;
let isPlaying = false;
let isShuffling = false;

// Fetch songs from "songs/" folder
fetchSongs();

// Volume control
volumeControl.addEventListener('input', () => {
	audio.volume = volumeControl.value;
});

// Play/Pause functionality
playPauseButton.addEventListener('click', () => {
	if (isPlaying) {
		audio.pause();
		playPauseButton.textContent = '▶';
	} else {
		audio.play();
		playPauseButton.textContent = '❚❚';
	}
	isPlaying = !isPlaying;
});

// Previous song functionality
prevButton.addEventListener('click', () => {
	currentIndex = (currentIndex - 1 + songs.length) % songs.length;
	loadSong();
});

// Next song functionality
nextButton.addEventListener('click', () => {
	currentIndex = (currentIndex + 1) % songs.length;
	loadSong();
});

// Shuffle functionality
shuffleButton.addEventListener('click', () => {
	isShuffling = !isShuffling;
	shuffleButton.style.backgroundColor = isShuffling ? '#28a745' : '#007bff';
	if (isShuffling) {
		shuffleSongs();
	} else {
		songs = [...songs];
	}
	loadSong();
});

// Seekbar functionality
audio.addEventListener('timeupdate', () => {
	const currentTime = audio.currentTime;
	const duration = audio.duration;
	if (duration) {
		currentTimeElem.textContent = formatTime(currentTime);
		durationElem.textContent = formatTime(duration);
		seekbar.value = (currentTime / duration) * 100;
	}
});

// Seekbar input functionality
seekbar.addEventListener('input', () => {
	const seekValue = seekbar.value / 100;
	audio.currentTime = audio.duration * seekValue;
});

// Load song
function loadSong() {
	audio.src = songs[currentIndex].url;
	nowPlayingElem.textContent = `Now Playing: ${songs[currentIndex].name}`;
	if (isPlaying) {
		audio.play();
	} else {
		playPauseButton.textContent = '▶';
	}
	highlightCurrentSong();
}

// Format time in minutes:seconds
function formatTime(seconds) {
	const mins = Math.floor(seconds / 60);
	const secs = Math.floor(seconds % 60);
	return `${mins}:${secs < 10 ? '0' : ''}${secs}`;
}

// Shuffle the playlist
function shuffleSongs() {
	for (let i = songs.length - 1; i > 0; i--) {
		const j = Math.floor(Math.random() * (i + 1));
		[songs[i], songs[j]] = [songs[j], songs[i]];
	}
}

// Highlight the current song in the playlist
function highlightCurrentSong() {
	const songItems = document.querySelectorAll('#song-list li');
	songItems.forEach((item, index) => {
		if (index === currentIndex) {
			item.classList.add('active');
		} else {
			item.classList.remove('active');
		}
	});
}

// Fetch songs from "songs/" folder
function fetchSongs() {
	// Example of songs list. This should be dynamically generated or populated.
	songs = [
		{ name: 'Dies Irae St. Pepe the Frog', url: 'songs/dies-irae-pepe.mp3' },
		{ name: 'Miserere', url: 'songs/miserere.mp3' },
		{ name: 'Media Vita', url: 'songs/media-vita.mp3' },
		{ name: 'Beata Viscera', url: 'songs/beata-viscera.mp3' }
	];

	// Populate the playlist
	songs.forEach((song, index) => {
		const li = document.createElement('li');
		li.textContent = song.name;
		li.addEventListener('click', () => {
			currentIndex = index;
			loadSong();
		});
		songListElem.appendChild(li);
	});

	// When a song ends, load the next one
	audio.addEventListener('ended', () => {
		if (isShuffling) {
			currentIndex = Math.floor(Math.random() * songs.length);
		} else {
			currentIndex = (currentIndex + 1) % songs.length;
		}
		loadSong();
	});

	loadSong();
}

// COPY CA BUTTON
function copyText(button) {
	const contractAddress = "Et63bkNtgp7nyvBMBxjKGBCjxet9Hrvm7qXpjnYSbKGh";
	navigator.clipboard.writeText(contractAddress)
		.then(() => {
			button.textContent = "Copied!";
			
			const confirmationDiv = document.getElementById("confirmation");
			confirmationDiv.textContent = `Make sure the Contract Address (CA) you copied is exactly "${contractAddress}" and that you are using the Solana Network.`;
			confirmationDiv.style.display = "block";

			setTimeout(() => {
				button.textContent = "Copy Contract Address";
				confirmationDiv.style.display = "none";
			}, 50000);
		})
		.catch(err => console.error("Failed to copy:", err));
}

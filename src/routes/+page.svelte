<script lang="ts">
	import { onMount } from 'svelte';

	let currentTime = `${new Date().toLocaleTimeString()}`;

	let currentAudioPoint = 0.0;
	let audioDataMean = 0.0;
	let audioDataPointSum = 0.0;
	let numberOfAudioPoints = 0;

	let audioElement: HTMLAudioElement;
	let audioContext: AudioContext | null = null;
	let sourceNode: MediaElementAudioSourceNode | null = null;
	let analyserNode: AnalyserNode | null = null;
	let animationFrameId: number | null = null;

	onMount(() => {
		audioContext = new AudioContext();

		// Update the current time every second
		setInterval(() => {
			currentTime = `${new Date().toLocaleTimeString()}`;
		}, 1000);
	});

	// Update the audio data string with new values
	const updateAudioData = (num: number) => {
		numberOfAudioPoints += 1;
		audioDataPointSum += num;
		audioDataMean = audioDataPointSum / numberOfAudioPoints;

		currentAudioPoint = num;
	};

	// Function to process audio data
	const processAudioData = (data: Float32Array) => {
		const avgAmplitude =
			data.reduce((sum, value) => sum + Math.abs(value), 0) / data.length;
		updateAudioData(avgAmplitude);
	};

	// Start analyzing audio
	const startAnalyzing = () => {
		if (analyserNode) {
			const data = new Float32Array(analyserNode.fftSize);

			const analyze = () => {
				analyserNode.getFloatTimeDomainData(data);
				processAudioData(data);

				animationFrameId = requestAnimationFrame(analyze);
			};

			animationFrameId = requestAnimationFrame(analyze);
		}
	};

	// Stop analyzing audio
	const stopAnalyzing = () => {
		if (animationFrameId) {
			cancelAnimationFrame(animationFrameId);
			animationFrameId = null;
		}
	};

	// Handle play event
	const handlePlay = () => {
		if (!sourceNode && audioContext) {
			// Initialize source and analyser nodes if not already done
			sourceNode = audioContext.createMediaElementSource(audioElement);
			analyserNode = audioContext.createAnalyser();
			analyserNode.fftSize = 2048;

			// Connect source -> analyser -> destination
			sourceNode.connect(analyserNode);
			analyserNode.connect(audioContext.destination);
		}

		// Start/resume analyzing
		startAnalyzing();

		// Resume the audio context
		audioContext?.resume().catch((error) => {
			console.error('AudioContext failed to resume:', error);
		});
	};

	// Handle pause or end event
	const handleStop = () => {
		stopAnalyzing();
	};

	// Compute the color dynamically from grey to red with an upper limit of 0.1
	const audioMeanColor = () => {
		const normalizedMean = Math.max(0, Math.min(audioDataMean / 0.1, 1));
		const hue = 0; // Red color
		const saturation = normalizedMean * 100; // From 0% (grey) to 100% (red)
		const lightness = 50; // Keep a balanced lightness
		return `hsl(${hue}, ${saturation}%, ${lightness}%)`;
	};

	// Compute the text size dynamically from 16px to 48px based on the mean
	const audioMeanSize = () => {
		const normalizedMean = Math.max(0, Math.min(audioDataMean / 0.1, 1));
		const minSize = 16; // Minimum text size in px
		const maxSize = 48; // Maximum text size in px
		return `${minSize + normalizedMean * (maxSize - minSize)}px`;
	};
</script>


<h1>Welcome to Urpagin.net</h1>
<h1>It is currently: {currentTime}</h1>
<h2>Welcome to my terrible-looking, seemingly HTML-only website!</h2>

<h2>Some Buttons</h2>
<img src="/images/valheim_thisle_night.webp" alt="Buttons Icon" style="width:384px; height:256px; margin-right:10px;">
<br /><br />
<a href="https://github.urpagin.net" target="_blank" class="button">GitHub</a>
<br /><br />
<a href="https://blog.urpagin.net" target="_blank" class="button">Blog</a>



<br /><br />

<hr>

<br /><br />

<h2>A Nice Little Song</h2>

<audio
	bind:this={audioElement}
	controls
	preload="none"
	on:play={handlePlay}
	on:pause={handleStop}
	on:ended={handleStop}
>
	<source src="/music/fly_me_to_the_moon.ogg" type="audio/flac" />
	Your browser does not support the audio element.
</audio>
<p><em>You may adjust the volume to see a direct consequence on the metrics.</em></p>

<p>Current Audio Data Point:</p>
<p style="color: coral;">{currentAudioPoint}</p>
<p>Current Mean of All Audio Data Points:</p>
<p style="color: {audioMeanColor()}; font-size: {audioMeanSize()};">
	{audioDataMean.toFixed(4)}
</p>



<h3>🎵 Song Credits</h3>
<p><strong>Title:</strong> Fly Me to the Moon</p>
<p><strong>Performed by:</strong> CLAIRE; Yoko Takahashi</p>
<p><strong>Release Date:</strong> October 25, 1995</p>
<p><strong>Anime:</strong> Neon Genesis Evangelion</p>
<p>

	<strong>Source (original FLAC quality):</strong>
	<a href="https://archive.org/details/evangelion-fmttm" target="_blank">https://archive.org/details/evangelion-fmttm</a>
</p>
<p>
	This song is best known as the <strong>ending theme</strong> for the anime
	<em>Neon Genesis Evangelion</em>
</p>

<br /><br />

<p style="font-size: xx-small;"><a href="https://youtu.be/Dp2SJN4UiE4" target="_blank">but also</a></p>

<br /><br />

<hr>

<br /><br /><br />

<h2>Website Information:</h2>
<p><strong>Stack:</strong> SvelteKit, bun</p>
<p><strong>Hosting:</strong> Using Docker on a Debian VPS</p>
<p><strong>Source:</strong> <a href="https://github.com/Urpagin/urpagin-dot-net" target="_blank">Available on GitHub</a></p>


<style>
	.button {
		display: inline-block;
		background-color: #007bff;
		color: white;
		padding: 10px 20px;
		font-size: 16px;
		border: none;
		border-radius: 5px;
		text-align: center;
		text-decoration: none;
		cursor: pointer;
	}

	.button:hover {
		background-color: #0056b3;
	}

	:global(body) {
		background-color: cadetblue;
		font-family: Arial, sans-serif;
		line-height: 1.6;
		margin: 20px;
	}

	h1,
	h2,
	h3 {
		color: #333;
	}

	audio {
		margin-top: 10px;
	}

	a {
		text-decoration: none;
	}

	p {
		margin: 5px 0;
	}
</style>

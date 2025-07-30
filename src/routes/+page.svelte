<script lang="ts">
	import { onMount } from 'svelte';

	let currentTime = generateTime();

	let computeDataPoints = false;

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
		// backgroundColor = generateBackgroundColor();
		// document.body.style.backgroundColor = backgroundColor;

		setInterval(() => {
			currentTime = generateTime();
		}, 1000);
	});

	let backgroundColor = '';

	function generateTime() {
		const now = new Date();
		const hours = now.getHours();
		const minutes = now.getMinutes();
		const seconds = now.getSeconds();

		const parityH = hours % 2 === 0 ? 'even' : 'odd';
		const parityM = minutes % 2 === 0 ? 'even' : 'odd';
		const parityS = seconds % 2 === 0 ? 'even' : 'odd';
		// This string is at max (4*3 + 2) = 14
		const parityAll = `${parityH}:${parityM}:${parityS}`.padEnd(15, ' ');
		const two = (n: number) => n.toString().padStart(2, '0');
		return `${two(hours)}:${two(minutes)}:${two(seconds)} ( ${parityAll})`;
	}

	function generateBackgroundColor() {
		const baseHue = 182;
		const hue = baseHue + (Math.random() * 10 - 5); // ±5 degrees
		const saturation = 25;
		const lightness = 45 + Math.random() * 10; // 45%–55%
		return `hsl(${hue.toFixed(1)}, ${saturation}%, ${lightness.toFixed(1)}%)`;
	}

	// Update the audio data string with new values
	const updateAudioData = (num: number) => {
		numberOfAudioPoints += 1;
		audioDataPointSum += num;
		audioDataMean = audioDataPointSum / numberOfAudioPoints;

		currentAudioPoint = num;
	};

	// Function to process audio data
	const processAudioData = (data: Float32Array) => {
		const avgAmplitude = data.reduce((sum, value) => sum + Math.abs(value), 0) / data.length;
		updateAudioData(avgAmplitude);
	};

	// Start analyzing audio
	const startAnalyzing = () => {
		if (!computeDataPoints || !analyserNode) return;

		const data = new Float32Array(analyserNode.fftSize);

		const analyze = () => {
			if (!computeDataPoints) return; // Stop if toggle was disabled

			analyserNode.getFloatTimeDomainData(data);
			processAudioData(data);

			animationFrameId = requestAnimationFrame(analyze);
		};

		animationFrameId = requestAnimationFrame(analyze);
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
		// Lazy-create AudioContext on first play
		if (!audioContext) {
			audioContext = new AudioContext();
		}

		// Create source and analyser nodes once
		if (!sourceNode) {
			sourceNode = audioContext.createMediaElementSource(audioElement);
			analyserNode = audioContext.createAnalyser();
			analyserNode.fftSize = 2048;
			sourceNode.connect(analyserNode);
			analyserNode.connect(audioContext.destination);
		}

		// Begin audio analysis if enabled
		if (computeDataPoints) {
			startAnalyzing();
		}

		// Resume AudioContext
		audioContext.resume().catch((error) => {
			console.error('AudioContext failed to resume:', error);
		});
	};

	// Handle pause or end event
	const handleStop = () => {
		stopAnalyzing();
	};

	$: if (computeDataPoints && audioElement?.paused === false) {
		startAnalyzing();
	} else {
		stopAnalyzing();
	}

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

	function handleUrpaginClick() {
		// Change background and spin the page
		document.body.style.backgroundColor = 'cadetblue';
		document.body.style.transition = 'transform 1s ease-in-out';
		document.body.style.transform = 'rotate(360deg)';
		setTimeout(() => {
			document.body.style.transform = '';
		}, 1000);

		// Create the image
		const img = document.createElement('img');
		img.src = '/images/stare.webp';
		img.decoding = 'async';
		img.loading = 'eager';

		// Position it
		Object.assign(img.style, {
			position: 'fixed',
			bottom: '20px',
			right: '20px',
			width: '100px',
			zIndex: '9999',
			// Divine halo via layered glow
			boxShadow: [
				'0 0 20px rgba(255, 255, 200, 0.8)',
				'0 0 40px rgba(255, 255, 150, 0.6)',
				'0 0 80px rgba(255, 255, 100, 0.4)',
				'0 0 120px rgba(255, 255, 50, 0.3)'
			].join(', ')
		});

		document.body.appendChild(img);
	}
</script>

<h1>
	Welcome to <span
		role="button"
		tabindex="0"
		on:click={handleUrpaginClick}
		on:keypress={handleUrpaginClick}
		style="cursor: pointer;">Urpagin.net</span
	>
</h1>
<h1 style="white-space: pre; font-family: monospace;">It is currently: {currentTime}</h1>
<h2>Welcome to my terrible-looking, seemingly HTML-only website!</h2>

<h2>A Picture</h2>
<img
	src="/images/valheim_thisle_night.webp"
	alt="Buttons Icon"
	style="width:50%; height:auto; margin-right:10px;"
	loading="lazy"
/>

<br /><br />
<h2>Some Buttons</h2>
<a href="https://github.urpagin.net" target="_blank" class="button">GitHub</a>
<a href="https://git.urpagin.net/Urpagin" target="_blank" class="button">GitHub Mirror</a>
<a href="https://blog.urpagin.net" target="_blank" class="button">Blog</a>

<br /><br />

<hr />

<br /><br />

<h2>A Nice Little Song</h2>

<audio
	bind:this={audioElement}
	controls
	preload="metadata"
	crossorigin="anonymous"
	on:play={handlePlay}
	on:pause={handleStop}
	on:ended={handleStop}
>
	<source
		src="https://files.urpagin.net/pub/urpagin-dot-net/music/fly_me_to_the_moon.ogg"
		type="audio/ogg"
	/>
	Your browser does not support the audio element.
</audio>
<p><em>You may adjust the volume to see a direct consequence on the metrics.</em></p>

<label style="display: block; margin-top: 1rem;">
	<input type="checkbox" bind:checked={computeDataPoints} />
	Compute Data Points (toggled off for older hardware)
</label>

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
	<a href="https://archive.org/details/evangelion-fmttm" target="_blank"
		>https://archive.org/details/evangelion-fmttm</a
	>
</p>
<p>
	This song gained additional recognition as the
	<strong>ending theme for the anime Neon Genesis Evangelion</strong>.<br /> However, its cultural impact
	extends beyond that, having been covered by numerous artists (e.g., Frank Sinatra) and featured in
	various contexts since its original release.
</p>

<br /><br />

<p style="font-size: xx-small;">
	And these: <a href="https://files.urpagin.net/pub/urpagin-dot-net/music/" target="_blank"
		>(better listing)</a
	>
</p>

<p style="font-size: xx-small;">
	<a href="https://youtu.be/Dp2SJN4UiE4" target="_blank">I</a><br />
	<a href="https://www.youtube.com/@mai_dq" target="_blank">II</a><br />
	<a
		href="https://files.urpagin.net/pub/urpagin-dot-net/music/clair_de_lune_claude_debussy_suite_bergamasque.ogg"
		target="_blank">III</a
	><br />
	<a href="https://youtu.be/J6qIzKxmW8Y" target="_blank">IV</a>
</p>

<br /><br />

<hr />

<br /><br /><br />

<h2>Website Information:</h2>
<p><strong>Stack:</strong> SvelteKit, bun</p>
<p><strong>Hosting:</strong> Using Docker on a Debian VPS</p>
<p>
	<strong>Source:</strong>
	<a href="https://github.com/Urpagin/urpagin-dot-net" target="_blank">Available on GitHub</a>
</p>

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
		font-family: Arial, sans-serif;
		line-height: 1.6;
		margin: 20px;
		background-color: var(--boot-bg, cadetblue);
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

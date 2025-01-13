<script>
	import { onMount } from 'svelte';

	let currentTime = `${new Date().toLocaleTimeString()}`;

	// Update the footer every second
	onMount(() => {
		setInterval(() => {
			currentTime = `${new Date().toLocaleTimeString()}`;
		}, 1000);
	});
</script>

<!-- Main heading -->
<h1>Welcome to Urpagin.net</h1>

<h1>It is currently: {currentTime}</h1>

<!-- Subheading -->
<h2>Welcome to my terrible-looking, seemingly HTML-only website!</h2>

<!-- Buttons section -->
<h2>Some Buttttttttons</h2>

<a href="https://github.urpagin.net" target="_blank" class="button">My GitHub</a>
<br /><br />
<a href="https://blog.urpagin.net" target="_blank" class="button">My Blog</a>

<!-- Audio section -->
<h2>A Nice Little Song</h2>
<audio controls preload="none">
	<source src="/music/fly_me_to_the_moon.ogg" type="audio/flac" />
	Your browser does not support the audio element.
</audio>

<!-- Credits section -->
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
	This song is best known as the <strong>ending theme</strong> for the anime
	<em>Neon Genesis Evangelion</em>
</p>

<!-- Footer link -->
<br /><br /><br /><br />
<a href="https://github.com/Urpagin/urpagin-dot-net" target="_blank">Website Source Code</a>

<!-- Styling -->
<style>
	/* Button styling */
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

	/* Layout and text improvements */
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

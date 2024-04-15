<script>
    import {onMount} from 'svelte';

    let canvas, ctx;
    let particles = [];

    onMount(() => {
        ctx = canvas.getContext('2d');
        adjustCanvasResolution();
        setupParticles();
        window.requestAnimationFrame(draw);
    });

    function adjustCanvasResolution() {
        const ratio = window.devicePixelRatio || 1;
        canvas.width = window.innerWidth * ratio;
        canvas.height = window.innerHeight * ratio;
        canvas.style.width = window.innerWidth + 'px';
        canvas.style.height = window.innerHeight + 'px';
        ctx.scale(ratio, ratio); // Normalize coordinate system to use css pixels.
    }

    function setupParticles() {
        const shapes = ['arc', 'rect', 'triangle'];
        for (let i = 0; i < 100; i++) {
            const shape = shapes[Math.floor(Math.random() * shapes.length)];
            particles.push({
                x: Math.random() * window.innerWidth,
                y: Math.random() * window.innerHeight,
                size: Math.random() * 5 + 1,
                vx: Math.random() - 0.5,
                vy: Math.random() - 0.5,
                shape
            });
        }
    }

    function drawShape(p) {
        ctx.fillStyle = '#fff';
        ctx.beginPath();
        switch (p.shape) {
            case 'arc':
                ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
                break;
            case 'rect':
                ctx.rect(p.x, p.y, p.size * 2, p.size * 2);
                break;
            case 'triangle':
                ctx.moveTo(p.x, p.y);
                ctx.lineTo(p.x + p.size, p.y + p.size * 2);
                ctx.lineTo(p.x - p.size, p.y + p.size * 2);
                ctx.closePath();
                break;
        }
        ctx.fill();
    }

    function draw() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        particles.forEach(p => {
            drawShape(p);
            p.x += p.vx;
            p.y += p.vy;

            // Reflect particles off the edge
            if (p.x < 0 || p.x > canvas.width) p.vx *= -1;
            if (p.y < 0 || p.y > canvas.height) p.vy *= -1;
        });
        window.requestAnimationFrame(draw);
    }
</script>

<canvas bind:this={canvas}></canvas>
<h1>Welcome</h1>
<p><a href="https://kit.svelte.dev">kit.svelte.dev</a></p>

<svelte:head>
    <title>Welcome to My Site</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
</svelte:head>

<style>

    canvas {
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background: #333;
    }

    h1 {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        color: white;
        font-size: 4em;
        z-index: 1;
        font-family: 'Roboto', sans-serif;
        font-weight: 700;
    }

    p, a {
        color: white;
        text-align: center;
        display: block;
        position: absolute;
        width: 100%;
        bottom: 20px;
        font-size: 1.2em;
        font-family: 'Roboto', sans-serif;
    }
</style>

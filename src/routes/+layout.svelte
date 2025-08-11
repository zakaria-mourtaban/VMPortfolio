<script>
	import '@xterm/xterm/css/xterm.css';
</script>

<main>
	<slot />
</main>

<style>
	:global(body) {
		margin: 0;
		padding: 0;
		font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
		background: #1e1e1e;
		color: #fff;
	}
	
	main {
		height: 100vh;
		overflow: hidden;
	}
</style>
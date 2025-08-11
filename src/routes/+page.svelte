<script>
	import WebVM from '$lib/WebVM.svelte';
	import * as configObj from '/config_terminal.js';
</script>

<svelte:head>
	<title>Portfolio VM - Linux Terminal</title>
	<meta name="description" content="Interactive Linux environment to showcase portfolio applications" />
</svelte:head>

<WebVM {configObj} cacheId="portfolio_vm" />
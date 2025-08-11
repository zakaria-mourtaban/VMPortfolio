<script>
	import { onMount } from 'svelte';
	import '@xterm/xterm/css/xterm.css'

	export let configObj = null;
	export let cacheId = "vm_portfolio";

	var term = null;
	var cx = null;
	var fitAddon = null;
	var cxReadFunc = null;
	var blockCache = null;

	function writeData(buf, vt) {
		if(vt != 1) return;
		term.write(new Uint8Array(buf));
	}

	function readData(str) {
		if(cxReadFunc == null) return;
		for(var i=0;i<str.length;i++)
			cxReadFunc(str.charCodeAt(i));
	}

	function printMessage(msg) {
		for(var i=0;i<msg.length;i++)
			term.write(msg[i] + "\n");
	}

	function computeXTermFontSize() {
		return parseInt(getComputedStyle(document.body).fontSize);
	}

	var curInnerWidth = 0;
	var curInnerHeight = 0;
	
	function handleResize() {
		if(curInnerWidth == window.innerWidth && curInnerHeight == window.innerHeight)
			return;
		curInnerWidth = window.innerWidth;
		curInnerHeight = window.innerHeight;
		term.options.fontSize = computeXTermFontSize();
		fitAddon.fit();
	}

	async function initTerminal() {
		const { Terminal } = await import('@xterm/xterm');
		const { FitAddon } = await import('@xterm/addon-fit');
		const { WebLinksAddon } = await import('@xterm/addon-web-links');
		
		term = new Terminal({
			cursorBlink: true, 
			convertEol: true, 
			fontFamily: "monospace", 
			fontWeight: 400, 
			fontWeightBold: 700, 
			fontSize: computeXTermFontSize()
		});
		
		fitAddon = new FitAddon();
		term.loadAddon(fitAddon);
		
		var linkAddon = new WebLinksAddon();
		term.loadAddon(linkAddon);
		
		const consoleDiv = document.getElementById("console");
		term.open(consoleDiv);
		term.scrollToTop();
		fitAddon.fit();
		
		window.addEventListener("resize", handleResize);
		term.focus();
		term.onData(readData);
		
		curInnerWidth = window.innerWidth;
		curInnerHeight = window.innerHeight;
		
		if(configObj.printIntro) {
			printMessage([
				"Welcome to VM Portfolio!",
				"This is a Linux environment running in your browser.",
				"You have root access to explore and test programs.",
				""
			]);
		}
		
		try {
			await initCheerpX();
		} catch(e) {
			printMessage(["Failed to initialize VM:", e.toString()]);
			return;
		}
	}

	async function initCheerpX() {
		const CheerpX = await import('@leaningtech/cheerpx');
		
		var blockDevice = await CheerpX.CloudDevice.create(configObj.diskImageUrl);
		blockCache = await CheerpX.IDBDevice.create(cacheId);
		var overlayDevice = await CheerpX.OverlayDevice.create(blockDevice, blockCache);
		var dataDevice = await CheerpX.DataDevice.create();
		
		var mountPoints = [
			{type:"ext2", dev:overlayDevice, path:"/"},
			{type:"dir", dev:dataDevice, path:"/data"},
			{type:"devs", path:"/dev"},
			{type:"devpts", path:"/dev/pts"},
			{type:"proc", path:"/proc"}
		];
		
		try {
			cx = await CheerpX.Linux.create({mounts: mountPoints});
		} catch(e) {
			printMessage(["Failed to create Linux environment:", e.toString()]);
			return;
		}
		
		term.scrollToBottom();
		cxReadFunc = cx.setCustomConsole(writeData, term.cols, term.rows);
		
		// Run the command in a loop
		while (true) {
			await cx.run(configObj.cmd, configObj.args, configObj.opts);
		}
	}
	
	onMount(initTerminal);

	async function handleReset() {
		if(blockCache == null) return;
		await blockCache.reset();
		location.reload();
	}
</script>

<div class="vm-container">
	<div class="vm-header">
		<h2>Linux Terminal - Portfolio VM</h2>
		<button on:click={handleReset} class="reset-btn">Reset VM</button>
	</div>
	<div id="console" class="terminal"></div>
</div>

<style>
	.vm-container {
		display: flex;
		flex-direction: column;
		height: 100vh;
		background: #1e1e1e;
		color: #fff;
	}
	
	.vm-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		padding: 1rem;
		background: #2d2d2d;
		border-bottom: 1px solid #444;
	}
	
	.vm-header h2 {
		margin: 0;
		font-size: 1.2rem;
	}
	
	.reset-btn {
		background: #dc3545;
		color: white;
		border: none;
		padding: 0.5rem 1rem;
		border-radius: 4px;
		cursor: pointer;
		font-size: 0.9rem;
	}
	
	.reset-btn:hover {
		background: #c82333;
	}
	
	.terminal {
		flex: 1;
		padding: 1rem;
		overflow: hidden;
	}
</style>
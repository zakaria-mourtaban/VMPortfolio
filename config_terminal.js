// WebVM Configuration for Portfolio - Root Access Enabled
export const diskImageUrl = "wss://disks.webvm.io/debian_large_20230522_5044875331.ext2";
export const diskImageType = "cloud";
export const printIntro = true;
export const needsDisplay = false;
export const cmd = "/bin/bash";
export const args = ["--login"];
export const opts = {
	// Environment variables - Root user for portfolio demo
	env: ["HOME=/root", "TERM=xterm", "USER=root", "SHELL=/bin/bash", "EDITOR=vim", "LANG=en_US.UTF-8", "LC_ALL=C"],
	// Current working directory - Root home
	cwd: "/root",
	// Root user id
	uid: 0,
	// Root group id  
	gid: 0
};
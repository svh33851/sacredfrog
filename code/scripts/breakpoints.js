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
// Open Listen Live Window
function open_popup(url) { 
        window.open(url, 'pop_up','height=800,width=556,resizable,left=10,top=10,scrollbars=no,toolbar=no');
        return false; 
}

// temporary dev tool
function tryWidth(width) {
	window.open(window.location.pathname, "dev", "height=1000,width="+width)
}
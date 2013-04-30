$(document).ready(function() {
	// scroll background differently:
	$(window).scroll(function() {
		$('body').css('background-position',
			'0px ' + $(window).scrollTop() * 0.95 + 'px');
	});
		
	// define modal popup
	/*$('body').prepend('<div id="overlay" onclick="hidePopup()"><div>' +
	'<div id="popup"></div><a href="javascript:hidePopup()">schließen</a></div></div>');*/	
	updateLinks($('body'));
});

function updateLinks(parent) {	
	// animate anchor link jumps
	$('a[href^="#"]', parent).click(function(e) {
		e.preventDefault();
		scrollToHash($(this).attr('href').substring(1));
	});
	// open modal links in a popup
	/*$('a.modal', parent).click(function(e) {
		e.preventDefault();
		var url = $(this).attr('href');
		url += ((url.indexOf('?') == -1) ? '?' : '&') + 'mode=contentonly';
		$('#popup').empty().load(url);
		$('#overlay').fadeIn();
		$('#overlay > div').delay(400).fadeIn();
	});*/
}

function scrollToHash(hash){
	var target = $('*[name="' + hash + '"]');
	if (!target) return;
	var intendation = 0.5 * (target.width() - $(window).width());
    $('html, body').animate({
        scrollTop: (hash.length == 0) ? '0px' :
			target.offset().top + 'px',
		scrollLeft: (hash.length == 0) ? intendation + 'px' :
			intendation + target.offset().left + 'px'
     }, 1000, 'swing', function() {
		window.location.href = '#' + hash;
	});
}

function hidePopup() {
	$('#overlay').fadeOut(400, function() {
		$('#overlay > div').css('display', 'none');
	});
}
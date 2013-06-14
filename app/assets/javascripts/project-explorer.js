/* This file contains functionality regarding the project explorer component.
It should be included in any page containing the project explorer. */

var map, info;
var overlays = [];
google.maps.visualRefresh = true;
google.maps.event.addDomListener(window, 'load', function() {
	map = new google.maps.Map($('.xpl-map').get(0), {
		zoom: 13, maxZoom: 15, minZoom: 10,
		center: new google.maps.LatLng(49.009839,8.402624),
		disableDefaultUI: true,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	});
	map.setOptions({styles:[
		{	"featureType": "poi",
			"elementType": "labels",
			"stylers": [{"visibility": "off"}]
		},{	"featureType": "transit",
			"stylers": [{"visibility": "off"}]
		},{	"featureType": "road",
			"elementType": "labels.icon",
			"stylers": [{"visibility": "off"}]}
	]});
	
	// limit viewable area
	google.maps.event.addListener(map, 'center_changed', function() {
		var x = map.getCenter().lng(),
			y = map.getCenter().lat(),
			maxX = 8.6, maxY = 49.25,
			minX = 8.2, minY = 48.85;
		map.panTo(new google.maps.LatLng(
			(y < minY) ? minY : (y > maxY) ? maxY : y,
			(x < minX) ? minX : (x > maxX) ? maxX : x));
	});
	
	// add fader and map expansion
	var fader = $('<div class="xpl-map-fader">').click(function(e) {
		var canvas = $('.xpl-map');
		canvas.css('height', ((canvas.height() > 400) ? '250px' : '500px'));
		window.setTimeout('google.maps.event.trigger(map, "resize");', 500);
	}).attr('title', 'Karte aus-/einklappen');
	$('.xpl-map').append(fader);
	google.maps.event.addListener(map, 'bounds_changed', function() {
		$('.xpl-map > div:not(.xpl-map-fader)').css('z-index', 'auto');
	});
	
	// update project explorer to use ajax and the map view
	window.setTimeout(function(){loadProjects(collectFilterOptions(1), false);}, 1000)
	$('.xpl-filter input').click(function() {
		loadProjects(collectFilterOptions(1), true);
	});
});


/** Creates a get string from the project filter options. **/
function collectFilterOptions(page) {
	var url = 'projects';
	$('.xpl-filter input:checked').each(function() {
		url = addParam(url, $(this).attr('name') + '=' + $(this).attr('value'));
	});
	return addParam(url, 'page=' + page);
}

/** Loads project list and updates the map according to the filter specs given in the url. **/
function loadProjects(url, fadeOut) {
	$('.xpl-list').hide();
	$('.xpl-list').load(url + ' #content > *', function() {
		$('.xpl-list').fadeIn();
		removeMarkers();
		$('.xpl-list .xpl-teaser').each(function() {
			var desc = $('<div>').append($(this).clone());
			desc.find('.xpl-teaser > div').each(function() {
				$(this).html($(this).html().substr(0, 140) + ' ...');
			});
			addMarker($(this).find('h3').html(), desc.html(),
				$(this).data('lat'), $(this).data('lon'));
		});
		$('.xpl-list .xpl-browser a').click(function(e) {
			e.preventDefault();
			loadProjects($(this).attr('href'), true);
		});
	});
}

function addMarker(name, desc, lat, lon) {
	var marker = new google.maps.Marker({
		title: name, map: map,
		position: new google.maps.LatLng(lat,lon)
	});
	overlays.push(marker);	
	var infowindow = new google.maps.InfoWindow({content: desc, maxWidth: 300});
	google.maps.event.addListener(marker, 'click', function() {
		if (info) info.close();
		infowindow.open(map, marker);
		info = infowindow;
	});
	overlays.push(infowindow);
}

function removeMarkers() {
	while(overlays[0]) {
		var marker = overlays.pop();
		marker.setMap(null);
	}
}
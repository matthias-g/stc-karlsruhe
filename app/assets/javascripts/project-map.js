$(document).ready(function() {

    // google maps rendering hints
    var mapOptions = {styles:[
        {	"featureType": "poi",
            "elementType": "labels",
            "stylers": [{"visibility": "off"}]
        },{	"featureType": "transit",
            "stylers": [{"visibility": "off"}]
        },{	"featureType": "road",
            "elementType": "labels.icon",
            "stylers": [{"visibility": "off"}]}
    ]};

    // the google maps api v3 must be loaded prior to this
    google.maps.visualRefresh = true;
    $('.map-location').each(function() {
        createMap($(this));
    });


    function createMap(c) {
        var map = new google.maps.Map(c.get(0), {
            zoom: parseInt(c.data('map-zoom')), maxZoom: 15, minZoom: 9,
            center: new google.maps.LatLng(
                parseFloat(c.data('map-lat')), parseFloat(c.data('map-lon'))
            ),
            disableDefaultUI: true,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        //map.setOptions(mapOptions);

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

        var info;
        var overlays = [];

        addMarker('Projektort', '', parseFloat(c.data('lat')), parseFloat(c.data('lon')));

        if (c.hasClass('edit')) {
            google.maps.event.addListener(map, 'click', function(e) {
                removeMarkers();
                addMarker('Projektort', '', e.latLng.lat(), e.latLng.lng());
                c.siblings('#project_latitude').val(e.latLng.lat());
                c.siblings('#project_longitude').val(e.latLng.lng());
            });
            google.maps.event.addListener(map, 'center_changed', function(e) {
                c.siblings('#project_map_latitude').val(map.getCenter().lat());
                c.siblings('#project_map_longitude').val(map.getCenter().lng());
            });
            google.maps.event.addListener(map, 'zoom_changed', function() {
                c.siblings('#project_map_zoom').val(map.getZoom());
            });
        }

        function addMarker(name, desc, lat, lon) {
            var marker = new google.maps.Marker({
                title: name, map: map,
                position: new google.maps.LatLng(lat,lon)
            });
            overlays.push(marker);
            if (desc && (desc.length > 0)) {
                var infoWindow = new google.maps.InfoWindow(
                    {content: desc, maxWidth: 300});
                google.maps.event.addListener(marker, 'click', function() {
                    if (info) info.close();
                    infoWindow.open(map, marker);
                    info = infoWindow;
                });
                overlays.push(infoWindow);
            }
        }

        function removeMarkers() {
            while(overlays[0]) {
                var marker = overlays.pop();
                marker.setMap(null);
            }
        }
    }
});


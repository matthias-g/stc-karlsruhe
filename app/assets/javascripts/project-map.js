$(document).ready(function() {

    // google maps settings
    var mapOptions = {
        disableDefaultUI: true,
        zoomControl: true,
        scrollwheel: false,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        styles: [{
            "featureType": "poi",
            "elementType": "labels",
            "stylers": [{"visibility": "off"}]
        },{
            "featureType": "transit",
            "stylers": [{"visibility": "off"}]
        },{
            "featureType": "road",
            "elementType": "labels.icon",
            "stylers": [{"visibility": "off"}]
        }]
    };

    // the google maps api v3 must be loaded prior to this
    google.maps.visualRefresh = true;
    $('.map').each(function() {
        createMap($(this));
    });

    function createMap(c) {
        var info;
        var overlays = [];
        var markerData = c.children().detach();
        var map = new google.maps.Map(c.get(0), {
            zoom: parseInt(c.data('zoom')), maxZoom: 17, minZoom: 11,
            center: new google.maps.LatLng(
                parseFloat(c.data('lat')), parseFloat(c.data('lon'))
            )
        });
        map.setOptions(mapOptions);

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

        var bounds = new google.maps.LatLngBounds();
        markerData.each(function() {
            var m = $(this);
            var pos = new google.maps.LatLng(
                parseFloat(m.data('lat')), parseFloat(m.data('lon')));
            addMarker(m.data('name'), m.data('href'),
                m.text(), pos.lat(), pos.lng());
            bounds.extend(pos);
        });

        if (markerData.size() > 1)
            map.fitBounds(bounds);

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

        function addMarker(name, href, desc, lat, lon) {
            var marker = new google.maps.Marker({
                title: name, map: map,
                position: new google.maps.LatLng(lat,lon)
            });
            overlays.push(marker);
            desc = (desc && (desc.trim().length > 0))
                ? (desc.substr(0, 250) + '...') : desc;
            var infoWindow = new google.maps.InfoWindow({maxWidth: 300,
                content: '<a href="'+href+'"><h4>'+name+'</h4></a>' + desc});
             google.maps.event.addListener(marker, 'click', function() {
                if (info) info.close();
                infoWindow.open(map, marker);
                info = infoWindow;
            });
            overlays.push(infoWindow);
        }

        function removeMarkers() {
            while(overlays[0]) {
                var marker = overlays.pop();
                marker.setMap(null);
            }
        }
    }
});

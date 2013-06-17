var gmap;
var marker;
var infoWindow;

google.maps.event.addDomListener(window, 'load', function() {
    $('.prj-location-picker').each(function() {
        var longval = $('.prj-longitude').attr('value');
        var latval = $('.prj-latitude').attr('value');
        var curpoint = new google.maps.LatLng(
            isNaN(latval)? 49.012 : parseFloat(latval),
            isNaN(longval)? 8.4043 : parseFloat(longval));

        gmap = new google.maps.Map(this, {
            center: curpoint,
            zoom: 12, maxZoom: 15, minZoom: 10,
            disableDefaultUI: true,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        gmap.setOptions({styles:[
            {	"featureType": "poi",
                "elementType": "labels",
                "stylers": [{"visibility": "off"}]
            },{	"featureType": "transit",
                "stylers": [{"visibility": "off"}]
            },{	"featureType": "road",
                "elementType": "labels.icon",
                "stylers": [{"visibility": "off"}]}
        ]});

        marker = new google.maps.Marker({
            map: gmap,
            position: curpoint
        });

        infoWindow = new google.maps.InfoWindow;
        google.maps.event.addListener(gmap, 'click', function(event) {
            $('.prj-latitude').attr({value: event.latLng.lat().toFixed(6)});
            $('.prj-longitude').attr({value: event.latLng.lng().toFixed(6)});
            marker.setPosition(event.latLng);
            updateInfoWindow();
        });

        google.maps.event.addListener(marker, 'click', function() {
            updateInfoWindow();
            infoWindow.open(gmap, marker);
        });

        $('#prj-latitude').attr({value: 49.012});
        $('#prj-longitude').attr({value: 8.4043});
    });
});

function updateInfoWindow() {
    infoWindow.setContent("Longitude: "+ marker.getPosition().lng().toFixed(6)+"<br>"+"Latitude: "+ marker.getPosition().lat().toFixed(6));
}


class GoogleMap

  mapOptions =
    disableDefaultUI: true
    zoomControl: true
    scrollwheel: false
    mapTypeId: google.maps.MapTypeId.ROADMAP
    styles: [
      {
        'featureType': 'poi'
        'elementType': 'labels'
        'stylers': [ { 'visibility': 'off' } ]
      }
      {
        'featureType': 'transit'
        'stylers': [ { 'visibility': 'off' } ]
      }
      {
        'featureType': 'road'
        'elementType': 'labels.icon'
        'stylers': [ { 'visibility': 'off' } ]
      }
    ]
  # the google maps api v3 must be loaded prior to this

  constructor = (c) ->
    info = undefined
    @overlays = []
    markerData = c.children().detach()
    
    # create map
    @map = new (google.maps.Map)(c.get(0),
      zoom: parseInt(c.data('zoom'))
      maxZoom: 17
      minZoom: 11
      center: new (google.maps.LatLng)(parseFloat(c.data('lat')), parseFloat(c.data('lon'))))
    @map.setOptions @mapOptions
    
    # limit viewable area
    google.maps.event.addListener @map, 'center_changed', ->
      x = @map.getCenter().lng()
      y = @map.getCenter().lat()
      maxX = 8.6
      maxY = 49.25
      minX = 8.2
      minY = 48.85
      @map.panTo new (google.maps.LatLng)(
        if y < minY then minY else if y > maxY then maxY else y,
        if x < minX then minX else if x > maxX then maxX else x)

    # find and apply marker bounds area
    bounds = new (google.maps.LatLngBounds)
    markerData.each ->
      m = $(this)
      pos = new (google.maps.LatLng)(parseFloat(m.data('lat')), parseFloat(m.data('lon')))
      @addMarker m.data('name') or '', m.data('href') or '', m.text() or '', pos.lat(), pos.lng()
      bounds.extend pos
    if markerData.size() > 1
      @map.fitBounds bounds
      
    # enable marker edit function?
    s = c.siblings()
    if c.hasClass('edit')
      google.maps.event.addListener @map, 'click', (e) ->
        @removeMarkers()
        @addMarker 'Projektort', '', '', e.latLng.lat(), e.latLng.lng()
        s.find('#project_latitude').val e.latLng.lat()
        s.find('#project_longitude').val e.latLng.lng()
      google.maps.event.addListener @map, 'center_changed', (e) ->
        s.find('#project_map_latitude').val @map.getCenter().lat()
        s.find('#project_map_longitude').val @map.getCenter().lng()
      google.maps.event.addListener @map, 'zoom_changed', ->
        s.find('#project_map_zoom').val @map.getZoom()

    google.maps.visualRefresh = true
        
  addMarker = (name, href, desc, lat, lon) ->
    marker = new (google.maps.Marker)({title: name, map: @map, position: new (google.maps.LatLng)(lat, lon)})
    @overlays.push marker
    desc = if desc and desc.trim().length > 0 then desc.substr(0, 250) + '...' else desc
    infoWindow = new (google.maps.InfoWindow)(
      maxWidth: 300
      content: '<a href="' + href + '"><h4>' + name + '</h4></a>' + desc)
    google.maps.event.addListener marker, 'click', ->
      if info
        info.close()
      infoWindow.open @map, marker
      info = infoWindow
    @overlays.push infoWindow

  removeMarkers = ->
    while @overlays[0]
      marker = @overlays.pop()
      marker.setMap null
class @GoogleMap
  # the google maps api v3 must be loaded prior to this

  constructor: (@html) ->
    markerData = @html.children().detach()
    @activeWindow = undefined
    @markers = @windows = []
    @mapID = @html.data('map-id')

    @map = new (google.maps.Map)(@html.get(0),
      zoom: parseInt(@html.data('zoom'))
      maxZoom: 17
      minZoom: 11
      center: new (google.maps.LatLng)(parseFloat(@html.data('lat')), parseFloat(@html.data('lon'))))

    @map.setOptions(
      disableDefaultUI: true
      zoomControl: true
      scrollwheel: false
      mapTypeId: google.maps.MapTypeId.ROADMAP
      styles: [
        {featureType: 'poi', elementType: 'labels', stylers: [{'visibility': 'off'}]},
        {featureType: 'transit', stylers: [{'visibility': 'off'}]},
        {featureType: 'road', elementType: 'labels.icon', stylers: [{'visibility': 'off'}]}
      ]
    )

    @extractMarkers(markerData)
    @adaptBoundsToMarkers
    @limitViewableArea(8.2, 8.6, 48.85, 49.25)

    google.maps.visualRefresh = true

    
  setEditable: (title, editID) =>
    google.maps.event.addListener @map, 'click', (e) =>
      lat = e.latLng.lat()
      lon = e.latLng.lng()
      @removeMarkers()
      @addMarker title, '', '', lat, lon
      $('#' + editID + '_latitude').val lat
      $('#' + editID + '_longitude').val lon
    google.maps.event.addListener @map, 'center_changed', (e) =>
      center = @map.getCenter()
      $('#' + editID + '_map_latitude').val center.lat()
      $('#' + editID + '_map_longitude').val center.lng()
    google.maps.event.addListener @map, 'zoom_changed', =>
      $('#' + editID + '_map_zoom').val @map.getZoom()


  extractMarkers: (markerData) =>
    markerData.each (i, ele) =>
      m = $(ele)
      pos = new (google.maps.LatLng)(parseFloat(m.data('lat')), parseFloat(m.data('lon')))
      @addMarker(m.data('name') or '', m.data('href') or '', m.text() or '', pos.lat(), pos.lng())
      if m.data('editable')
        @setEditable(m.data('name'), @mapID)


  addMarker: (name, href, desc, lat, lon) =>
    marker = new (google.maps.Marker)
      title: name
      map: @map
      position: new (google.maps.LatLng)(lat, lon)
    @markers.push marker

    desc = if desc and desc.trim().length > 0 then desc.substr(0, 250) + '...' else desc
    window = new (google.maps.InfoWindow)
      maxWidth: 300
      content: '<a href="' + href + '"><h4>' + name + '</h4></a>' + desc
    @windows.push window

    google.maps.event.addListener marker, 'click', =>
      if @activeWindow
        @activeWindow.close()
      window.open @map, marker
      @activeWindow = window


  removeMarkers: =>
    m.setMap(null) for m in @markers
    w.setMap(null) for w in @windows
    @markers = @windows = []


  adaptBoundsToMarkers: =>
    if @markers.length == 0
      return
    bounds = new (google.maps.LatLngBounds)
    for marker of @markers
      bounds.extend marker.position
    @map.fitBounds bounds


  limitViewableArea: (minX, maxX, minY, maxY) =>
    google.maps.event.addListener @map, 'center_changed', =>
      x = @map.getCenter().lng()
      y = @map.getCenter().lat()
      @map.panTo new (google.maps.LatLng)(
        if y < minY then minY else if y > maxY then maxY else y,
        if x < minX then minX else if x > maxX then maxX else x)
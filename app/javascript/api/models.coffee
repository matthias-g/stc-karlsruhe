import { api } from '../api'

api.define 'user',
  username: ''
  firstName: ''
  lastName: ''
  phone: ''
  email: ''

api.define 'action',
  title: ''
  description: ''
  location: ''
  latitude: ''
  longitude: ''
  individualTasks: ''
  material: ''
  requirements: ''
  visible: false
  shortDescription: ''
  mapLatitude: ''
  mapLongitude: ''
  mapZoom: 17
  pictureSource: ''
  picture: {}
  info: {}
  tags: {jsonApi: 'hasMany', type: 'tags'}
  volunteers: {jsonApi: 'hasMany', type: 'volunteers'}
  events: {jsonApi: 'hasMany', type: 'events'}
  leaders: {jsonApi: 'hasMany', type: 'users'}
  actionGroup: {jsonApi: 'hasOne', type: 'action_groups'}
  parentAction: {jsonApi: 'hasOne', type: 'actions'}

api.define 'event',
  date: ''
  time: ''
  startTime: ''
  endTime: ''
  desiredTeamSize: 0
  teamSize: 0
  initiative: {jsonApi: 'hasOne', type: 'initiatives'}
  volunteers: {jsonApi: 'hasMany', type: 'users'}

api.define 'tag',
  title: ''
  icon: ''
  color: ''
  initiatives: {jsonApi: 'hasMany', type: 'actions'}
import { api } from '../api'

api.define 'user',
  username: ''
  firstName: ''
  lastName: ''
  phone: ''
  email: ''
  roles: {jsonApi: 'hasMany', type: 'role'}
  actionsAsVolunteer: {jsonApi: 'hasMany', type: 'action'}

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
  status: ''
  pictureSource: ''
  picture: {}
  info: {}
  tags: {jsonApi: 'hasMany', type: 'tags'}
  volunteers: {jsonApi: 'hasMany', type: 'volunteers'}
  events: {jsonApi: 'hasMany', type: 'events'}
  leaders: {jsonApi: 'hasMany', type: 'users'}
  actionGroup: {jsonApi: 'hasOne', type: 'action-group'}
  parentAction: {jsonApi: 'hasOne', type: 'actions'}

api.define 'action-group',
  title: '',
  actions: {jsonApi: 'hasMany', type: 'action'}

api.define 'project',
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
  status: ''
  pictureSource: ''
  picture: {}
  info: {}
  tags: {jsonApi: 'hasMany', type: 'tags'}
  volunteers: {jsonApi: 'hasMany', type: 'volunteers'}
  events: {jsonApi: 'hasMany', type: 'events'}
  leaders: {jsonApi: 'hasMany', type: 'users'}

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

api.define 'subscription',
  email: ''
  name: ''
  receiveEmailsAboutActionGroups: false
  receiveEmailsAboutOtherProjects: false
  receiveOtherEmailsFromOrga: false

api.define 'role',
  title: ''
  users: {jsonApi: 'hasMany', type: 'users'}

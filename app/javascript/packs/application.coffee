import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
import { store } from '../vuex'
import '../api/models'
import '../components'

Vue.use TurbolinksAdapter
Vue.config.productionTip = false

# create Vue root instance
onPageLoad =>
  new Vue(el: '#page', store)
  vuejsInitializedCallback()

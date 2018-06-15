
import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
import RelationshipList from '../components/RelationshipList.vue'

Vue.use TurbolinksAdapter

onPageLoad =>
  new Vue(el: '#page', components: {RelationshipList})

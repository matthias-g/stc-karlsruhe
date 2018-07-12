import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex/dist/vuex.esm'

Vue.use(Vuex)

store = new Vuex.Store
  state:
    filterWorkFriendly: false
    filterDates: []
    filterDatesOptions: []
    filterTags: []
    filterTagsOptions: []
  mutations:
    setFilterWorkFriendly: (state, value) ->
      state.filterWorkFriendly = value
    setFilterDates: (state, value) ->
      state.filterDates = value
    setFilterDatesOptions: (state, value) ->
      state.filterDatesOptions = value
      state.filterDates = value
    setFilterTags: (state, value) ->
      state.filterTags = value
    setFilterTagsOptions: (state, value) ->
      state.filterTagsOptions = value
      state.filterTags = []

export { store };
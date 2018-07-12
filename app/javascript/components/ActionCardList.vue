
<template>

  <div class="action-card-list card-deck">

    <div v-for="action in filteredActions" :key="action.id" class="action-card card" @click="open(action.info.url)">
      <img class="card-img-top" :src="action.picture.card.url" />
      <div class="card-body">

        <h4 class="card-title">
          <a :href="action.info.url">{{action.title}}</a>
        </h4>

        <span v-if="!action.visible" class="badge status_hidden">
          {{t('action.info.status.hidden')}}
        </span>
        <span v-if="action.info.status == 'finished'" class="badge status_finished">
          {{t('action.info.status.finished')}}
        </span>
        <span v-else-if="action.info.status == 'full'" class="badge status_full">
          {{t('action.info.status.full')}}
        </span>
        <span v-else :class="'badge status_' + action.info.status">
          {{ action.info.team_size + '/' + action.info.desired_team_size }}
        </span>
        <span v-if="action.info.subaction_count > 0" class="badge badge-secondary">
          {{p('action.info.subactions', action.info.subaction_count)}}
        </span>

        <p class="card-text">
          {{action.info.teaser}}
        </p>

      </div>
    </div>

  </div>

</template>


<script lang="coffee">
  import { store } from '../vuex'
  import { api } from '../api'
  import i18n_mixins from '../mixins/i18n'
  import Utils from '../utils'

  export default
    name: 'ActionCardList'
    mixins: [i18n_mixins]

    props:
      actionGroupId: Number

    data: ->
      actions: []

    computed:
      filterWorkFriendly: -> store.state.filterWorkFriendly
      filterDates: -> store.state.filterDates
      filterTags: -> store.state.filterTags

      filteredActions: ->
        @actions.filter (action) =>
          #return false unless action.action_group == @actionGroupId
          return false unless action.info.toplevel
          return false if @filterWorkFriendly and not action.info.work_friendly
          return false if @filterDates and not Utils.intersect(@filterDates, action.info.dates)
          return false if @filterTags and not Utils.subset(@filterTags, tag.id for tag in action.tags)
          true

    created: ->
      api.findAll('action', filter: {action_group: @actionGroupId}).then (response) =>
        @actions = response.data
        dates = Utils.removeDuplicates([].concat (action.info.dates for action in @actions)...)
        tags = Utils.removeDuplicatesById([].concat (action.tags for action in @actions)...)
        store.commit 'setFilterDatesOptions', dates
        store.commit 'setFilterTagsOptions', tags

    methods:
      open: (url) ->
        location.href = url

</script>


<style scoped>

</style>
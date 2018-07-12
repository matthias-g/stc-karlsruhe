
<template>

  <div class="action-card-list-filter">

    <template v-if="filterDatesOptions.length > 1">
      <h4>{{t('action_group.heading.filter_days')}}</h4>
      <div v-for="(date, i) in filterDatesOptions">
        <input type="checkbox" :id="'filterDates' + i" :value="date" v-model="filterDates">
        <label :for="'filterDates' + i">{{d(date)}}</label>
      </div>
    </template>

    <template v-if="filterTagsOptions.length > 1">
      <h4>{{t('action_group.heading.filter_tags')}}</h4>
      <div v-for="(tag, i) in filterTagsOptions">
        <input type="checkbox" :id="'filterTags' + i" :value="tag.id" v-model="filterTags">
        <label :for="'filterTags' + i">{{tag.title}}</label>
      </div>
    </template>

    <h4>{{t('action_group.heading.filter_other')}}</h4>
    <div>
      <input type="checkbox" id="filterWorkFriendly" v-model="filterWorkFriendly">
      <label for="filterWorkFriendly">{{t('action.form.filter.filter_work_friendly')}}</label>
    </div>

  </div>

</template>


<script lang="coffee">
  import { store } from '../vuex'
  import i18n_mixins from '../mixins/i18n'

  export default
    name: 'ActionCardListFilter'
    mixins: [i18n_mixins]

    computed:
      filterWorkFriendly:
        get: -> store.state.filterWorkFriendly
        set: (value) -> store.commit 'setFilterWorkFriendly', value
      filterDates:
        get: -> store.state.filterDates
        set: (value) -> store.commit 'setFilterDates', value
      filterTags:
        get: -> store.state.filterTags
        set: (value) -> store.commit 'setFilterTags', value
      filterDatesOptions: -> store.state.filterDatesOptions.sort()
      filterTagsOptions: -> store.state.filterTagsOptions.sort()

</script>


<style scoped>

</style>
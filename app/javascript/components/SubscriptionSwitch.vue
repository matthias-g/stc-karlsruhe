
<template>

  <div class="subscription-switch">
    <div class="checkbox">
      <label for="subscription-switch-input">
        <input type="checkbox" id="subscription-switch-input" @change="change"
               v-model="subscription.receiveEmailsAboutActionGroups" />
        {{t('activerecord.attributes.subscription.receive_emails_about_action_groups')}}
      </label>
    </div>
    <div class="checkbox">
      <label for="subscription-switch-input-2">
        <input type="checkbox" id="subscription-switch-input-2" @change="change"
               v-model="subscription.receiveEmailsAboutOtherProjects" />
        {{t('activerecord.attributes.subscription.receive_emails_about_other_projects')}}
      </label>
    </div>
    <div class="checkbox">
      <label for="subscription-switch-input-3">
        <input type="checkbox" id="subscription-switch-input-3" @change="change"
               v-model="subscription.receiveOtherEmailsFromOrga" />
        {{t('activerecord.attributes.subscription.receive_other_emails_from_orga')}}
      </label>
    </div>
  </div>

</template>


<script lang="coffee">
  import { api } from '../api'
  import Utils from '../utils'
  import i18n_mixins from '../mixins/i18n'

  export default
    name: 'SubscriptionSwitch'
    mixins: [i18n_mixins]

    props:
      subscriptionId: Number
      email: String
      name: String

    data: ->
      subscription:
        email: @email
        name: @name
        receiveEmailsAboutActionGroups: false
        receiveEmailsAboutOtherProjects: false
        receiveOtherEmailsFromOrga: false

    computed:
      subscription_needed: ->
        @subscription.receiveEmailsAboutActionGroups ||
        @subscription.receiveEmailsAboutOtherProjects ||
        @subscription.receiveOtherEmailsFromOrga

    created: ->
      if (@subscriptionId > 0)
        api.find('subscription', @subscriptionId).then (response) =>
          @subscription = response.data

    methods:

      change: ->
        if @subscription_needed && !@subscription.id?
          api.create('subscription', @subscription).then (response) =>
            @subscription = response.data
        if @subscription_needed && @subscription.id?
          api.update('subscription', @subscription).then (response) =>
            @subscription = response.data
        if !@subscription_needed && @subscription.id?
          api.destroy('subscription', @subscription.id).then =>
            delete @subscription.id

</script>


<style scoped>

</style>
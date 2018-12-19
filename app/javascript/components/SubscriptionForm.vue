
<template>

  <div class="subscription-form">
    <div class="form-group">
      <label for="subscription-form-name">{{t('activerecord.attributes.subscription.name')}}</label>
      <input type="text" class="form-control" id="subscription-form-name" v-model="subscription.name" />
    </div>
    <div class="form-group">
      <label for="subscription-form-email">{{t('activerecord.attributes.subscription.email')}}</label>
      <input type="email" class="form-control" id="subscription-form-email" v-model="subscription.email" />
    </div>
    <div class="checkbox">
      <label for="subscription-form-input">
        <input type="checkbox" id="subscription-form-input"
               v-model="subscription.receiveEmailsAboutActionGroups" />
        {{t('activerecord.attributes.subscription.receive_emails_about_action_groups')}}
      </label>
    </div>
    <div class="checkbox">
      <label for="subscription-form-input-2">
        <input type="checkbox" id="subscription-form-input-2"
               v-model="subscription.receiveEmailsAboutOtherProjects" />
        {{t('activerecord.attributes.subscription.receive_emails_about_other_projects')}}
      </label>
    </div>
    <div class="checkbox">
      <label for="subscription-form-input-3">
        <input type="checkbox" id="subscription-form-input-3"
               v-model="subscription.receiveOtherEmailsFromOrga" />
        {{t('activerecord.attributes.subscription.receive_other_emails_from_orga')}}
      </label>
    </div>
    <button class="btn btn-primary" v-on:click="create_subscription">{{t('subscription.creation.submit')}}</button>
  </div>

</template>


<script lang="coffee">
  import { api } from '../api'
  import Utils from '../utils'
  import i18n_mixins from '../mixins/i18n'

  export default
    name: 'SubscriptionForm'
    mixins: [i18n_mixins]

    props:
      subscriptionId: Number

    data: ->
      subscription:
        email: ''
        name: ''
        receiveEmailsAboutActionGroups: false
        receiveEmailsAboutOtherProjects: false
        receiveOtherEmailsFromOrga: false

    created: ->
      if (@subscriptionId > 0)
        api.find('subscription', @subscriptionId).then (response) =>
          @subscription = response.data

    methods:
      create_subscription: ->
        return if @subscription.email == ''
        api.create('subscription', @subscription).then((response) =>
          window.createFlashMessage 'Erfolgreich. Bitte überprüfe deine E-Mails!', 'Abonnement eingetragen'
        , (err) =>
          window.createFlashMessage 'Bitte überprüfe deine Daten', 'Fehler beim Eintragen', 'danger'
        )




</script>


<style scoped>

</style>
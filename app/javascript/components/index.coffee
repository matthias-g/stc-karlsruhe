import Vue from 'vue/dist/vue.esm'

import RelationshipList from '../components/RelationshipList.vue'
import ActionCardList from '../components/ActionCardList.vue'
import ActionCardListFilter from '../components/ActionCardListFilter.vue'
import SubscriptionSwitch from '../components/SubscriptionSwitch.vue'

# register components globally
Vue.component 'action-card-list', ActionCardList
Vue.component 'relationship-list', RelationshipList
Vue.component 'action-card-list-filter', ActionCardListFilter
Vue.component 'subscription-switch', SubscriptionSwitch
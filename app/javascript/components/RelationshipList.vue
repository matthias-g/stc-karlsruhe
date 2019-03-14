
<template>

  <div class="relationship-list">

    <div>
      <span class="item" v-for="(item, index) in items">
        <a :href="item_url(item)">{{item.name}}</a>
        <button type="button" class="btn btn-link p-0" :title="removeTitle" v-on:click="removeItem(index)">
          <span class="fas fa-times p-0"></span>
        </button><template v-if="index < items.length - 1">,</template>
      </span>
    </div>

    <select v-if="showSelect" ref="addSelect" v-model="selected" v-on:change="addItem(selected)"
            :name="selectName" :id="selectName" :title="selectTitle" class="col-select"
            data-size="5" data-live-search="true">
      <option v-for="opt in options" :value="opt.id" :data-tokens="opt.tokens">{{opt.name}}</option>
    </select>

  </div>

</template>


<script lang="coffee">
  import { api } from '../api'
  import Utils from '../utils'
  import i18n_mixins from '../mixins/i18n'

  export default
    name: 'RelationshipList'
    mixins: [i18n_mixins]

    props:
      name: String
      modelType: String
      modelId: Number
      relationship: String
      itemType: String
      enableAdd: Boolean

    computed:
      showSelect: -> @enableAdd && @options.length > 0
      removeTitle: -> Utils.ll(@model, 'remove', @relationship) if @model
      selectTitle: -> Utils.ll(@model, 'add', @relationship) if @model
      selectName: -> 'add-to-' + @name

    data: ->
      selected: -1
      model: null
      items: []
      options: []

    created: ->
      @fetchData()

    updated: ->
      $(@$refs.addSelect).selectpicker('render') if @showSelect

    methods:
      item_url: (item) ->
        "/#{@itemType}/#{item.id}"

      # get item data
      fetchData: ->
        api.find(@modelType, @modelId, include: @relationship).then (response) =>
          #console.log(response)
          @model = response.data
          @items = @convert_items(@model[@relationship])
        api.findAll(@itemType).then (response) =>
          @options = @convert_items(response.data)

      # conversion from resources to item objects
      convert_items: (items) ->
        items.map (item) -> {id: item.id, name: Utils.get_name_for(item), tokens: Utils.get_name_for(item)}

      # adds the item with the given id
      addItem: (id) ->
        return if (id < 0)
        item = Utils.find_in_object_array(id, @options)
        api.add(@modelType, @modelId, @relationship, item.id).then =>
          @items.push(item)
          @selected = -1;
          createFlashMessage Utils.ll(@model, 'added', @relationship, item.name)

      # removes the item with the given index in items
      removeItem: (index) ->
        item = @items[index]
        return unless confirm @t('general.message.confirmRemoveLong', subject: item.name)
        api.remove(@modelType, @modelId, @relationship, item.id).then =>
          @items.splice(index, 1)
          createFlashMessage Utils.ll(@model, 'removed', @relationship, item.name)

</script>


<style scoped>

  .item {
    white-space: nowrap;
    padding-right: 4px;
  }
  .item:after {
    content: ' ';
    white-space: normal;
  }

</style>
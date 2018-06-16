
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

    <select v-if="enableAdd" :name="selectName" :id="selectName" class="col-select" data-size="5" :title="selectTitle"
          data-live-search="true" ref="addSelect" v-model="selected" v-on:change="addItem(selected)">
      <option v-for="opt in options" :value="opt.id" :data-tokens="opt.tokens">{{opt.name}}</option>
    </select>

  </div>

</template>


<script lang="coffee">

  export default
    name: 'RelationshipList'

    props:
      name: String
      modelType: String
      modelId: Number
      relationship: String
      itemType: String
      enableAdd: Boolean

    computed:
      removeTitle: -> ll(@model, 'remove', @relationship)
      selectTitle: -> ll(@model, 'add', @relationship)
      selectName: -> 'add-to-' + @name

    data: ->
      selected: -1
      model: null
      items: []
      options: []

    created: ->
      @fetchData()

    updated: ->
      $(@$refs.addSelect).selectpicker('render') if @enableAdd

    methods:
      item_url: (item) ->
        "/#{@itemType}/#{item.id}"

      # get item data
      fetchData: ->
        # fetch model and items
        apiGet(@modelType, @modelId, include: @relationship).done (data) =>
          @model = data
          @items = @convert_items(data[@relationship])
        # fetch possible items
        apiGetAll(@itemType).done (data) =>
          @options = @convert_items(data)

      # conversion from resources to item objects
      convert_items: (items) ->
        items.map (item) -> {id: item.id, name: get_name_for(item), tokens: get_name_for(item)}

      # adds the item with the given id
      addItem: (id) ->
        return if (id < 0)
        item = find_in_object_array(id, @options)
        apiAdd(@modelType, @modelId, @relationship, @itemType, item.id).done =>
          @items.push(item)
          @selected = -1;
          createFlashMessage ll(@model, 'added', @relationship, item.name)

      # removes the item with the given index in items
      removeItem: (index) ->
        item = @items[index]
        return unless confirm I18n.t('general.message.confirmRemoveLong', subject: item.name)
        apiRemove(@modelType, @modelId, @relationship, @itemType, item.id).done =>
          @items.splice(index, 1)
          createFlashMessage ll(@model, 'removed', @relationship, item.name)

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
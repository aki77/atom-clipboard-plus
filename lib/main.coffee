{CompositeDisposable} = require 'atom'
ClipboardListView = null
ClipboardItems = require './clipboard-items'

module.exports =
  subscription: null
  clipboardListView: null

  config:
    limit:
      order: 1
      description: 'limit of the history count'
      type: 'integer'
      default: 50
      minimum: 2
      maximum: 500
    unique:
      order: 2
      description: 'remove duplicate'
      type: 'boolean'
      default: true
    minimumTextLength:
      order: 3
      type: 'integer'
      default: 3
      minimum: 1
      maximum: 10
    maximumTextLength:
      order: 4
      type: 'integer'
      default: 1000
      minimum: 10
      maximum: 5000
    maximumLinesNumber:
      order: 5
      type: 'integer'
      default: 5
      minimum: 0
      maximum: 20
      description: 'Max number of lines displayed per history.If zero (disabled), don\'t truncate candidate, show all.'

  activate: (state) ->
    @clipboardItems = new ClipboardItems(state.clipboardItemsState)

    @subscriptions = new CompositeDisposable
    @subscriptions.add(atom.commands.add('atom-text-editor',
      'clipboard-plus:toggle': => @toggle()
      'clipboard-plus:clear': => @clipboardItems.clear()
    ))
    @subscriptions.add(atom.config.onDidChange('clipboard-plus.useSimpleView', =>
      @destroyView()
    ))

  deactivate: ->
    @subscriptions?.dispose()
    @subscriptions = null
    @clipboardItems?.destroy()
    @clipboardItems = null
    @destroyView()

  serialize: ->
    clipboardItemsState: @clipboardItems.serialize()

  toggle: ->
    @getView().toggle()

  provide: ->
    view = @getView()
    {
      registerPasteAction: view.registerPasteAction.bind(view)
    }

  getView: ->
    ClipboardListView ?= require './clipboard-list-view'
    @clipboardListView ?= new ClipboardListView(@clipboardItems)

  destroyView: ->
    @clipboardListView?.destroy()
    @clipboardListView = null

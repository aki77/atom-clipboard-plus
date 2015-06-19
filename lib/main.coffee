ClipboardItems = require './clipboard-items'

module.exports =
  subscription: null
  clipboardListView: null

  config:
    limit:
      description: 'limit of the history count'
      type: 'integer'
      default: 50
      minimum: 2
      maximum: 500
    unique:
      description: 'remove duplicate'
      type: 'boolean'
      default: true
    minimumTextLength:
      type: 'integer'
      default: 3
      minimum: 1
      maximum: 10
    maximumTextLength:
      type: 'integer'
      default: 1000
      minimum: 10
      maximum: 5000

  activate: (state) ->
    @clipboardItems = new ClipboardItems(state.clipboardItemsState)
    @subscription = atom.commands.add 'atom-text-editor',
      'clipboard-plus:toggle': => @toggle()
      'clipboard-plus:clear': => @clipboardItems.clear()


  deactivate: ->
    @subscription?.dispose()
    @subscription = null
    @clipboardItems?.destroy()
    @clipboardItems = null
    @clipboardListView?.destroy()
    @clipboardListView = null

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
    unless @clipboardListView?
      ClipboardListView = require './clipboard-list-view'
      @clipboardListView = new ClipboardListView(@clipboardItems)
    @clipboardListView

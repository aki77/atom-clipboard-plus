{$$, SelectListView} = require 'atom-space-pen-views'

class SelectActionView extends SelectListView

  initialize: ({@callback, actions}) ->
    super
    @setItems(actions)

  destroy: ->
    @detach()

  getFilterKey: ->
    'name'

  viewForItem: ({name}) ->
    $$ ->
      @li name

  cancelled: ->
    @panel?.destroy()
    @panel = null
    @destroy()

  confirmed: (item) ->
    @callback(item)
    @cancel()

  attach: ->
    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel(item: this)
    @focusFilterEditor()


module.exports =
class SelectListActionView extends SelectListView
  actions = []

  initialize: () ->
    super
    @addClass('with-actions')

    atom.commands.add @element,
      'select-list:select-action': (event) =>
        @showActionView()
        event.stopPropagation()

  destroy: ->
    @detach()

  confirmed: (item) ->
    @actions[0].callback(item)

  cancelled: ->
    @panel?.destroy()
    @panel = null

  setActions: (actions) ->
    if typeof actions is 'function'
      actions = [{
        callback: actions
      }]

    @actions = actions

  showActionView: ->
    item = @getSelectedItem()
    @cancel()
    return unless item?

    new SelectActionView({@actions, callback: (action) ->
      action.callback(item)
    }).attach()

  attach: ->
    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel({@className, item: this})
    @focusFilterEditor()

  toggle: ->
    if @panel?
      @destroy()
    else
      @attach()

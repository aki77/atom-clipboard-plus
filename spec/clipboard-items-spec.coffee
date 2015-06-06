systemClipboard = require 'clipboard'
ClipboardItems = require '../lib/clipboard-items'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ClipboardItems", ->
  [clipboardItems, limit] = []

  beforeEach ->
    limit = 3
    atom.config.set('clipboard-plus.limit', limit)
    atom.config.set('clipboard-plus.unique', false)
    atom.config.set('clipboard-plus.minimumTextLength', 1)
    atom.config.set('clipboard-plus.maximumTextLength', 1000)
    clipboardItems = new ClipboardItems

  afterEach ->
    clipboardItems.destroy()

  describe 'write', ->
    it "atom clipboard", ->
      expect(clipboardItems.size()).toBe 0
      atom.clipboard.write('next')
      expect(clipboardItems.size()).toBe 1

    it "system clipboard", ->
      expect(clipboardItems.size()).toBe 0
      atom.clipboard.write('abc')
      systemClipboard.writeText('123')
      expect(clipboardItems.size()).toBe 1
      expect(clipboardItems.get(0).text).toBe 'abc'
      clipboardItems.syncSystemClipboard()
      expect(clipboardItems.size()).toBe 2
      expect(clipboardItems.get(1).text).toBe '123'

  it "limit", ->
    expect(clipboardItems.size()).toBe 0
    atom.clipboard.write('1')
    atom.clipboard.write('2')
    atom.clipboard.write('3')
    atom.clipboard.write('4')
    expect(clipboardItems.size()).toBe limit

  it "with metadata", ->
    expect(clipboardItems.size()).toBe 0
    atom.clipboard.write('1', {fullLine: false})
    atom.clipboard.write('2', {fullLine: false})
    expect(clipboardItems.size()).toBe 2
    {text, metadata} = clipboardItems.get(1)
    expect(text).toBe '2'
    expect(metadata.fullLine).toBe false

  it "with metadata replace", ->
    expect(clipboardItems.size()).toBe 0
    atom.clipboard.write('1', {fullLine: false})
    atom.clipboard.write('2', {fullLine: false})
    atom.clipboard.write('3', {fullLine: false, replace: true})
    expect(clipboardItems.size()).toBe 2
    {text, metadata} = clipboardItems.get(1)
    expect(text).toBe '3'
    expect(metadata.fullLine).toBe false
    expect(metadata.replace).not.toBeExists

  it "destroy", ->
    clipboardItems.destroy()
    expect(clipboardItems.size()).toBe 0
    atom.clipboard.write('1', {fullLine: false})
    atom.clipboard.write('2', {fullLine: false})
    expect(clipboardItems.size()).toBe 0

  it "unique", ->
    atom.clipboard.write('1', {fullLine: false})
    atom.clipboard.write('1', {fullLine: false})
    expect(clipboardItems.size()).toBe 2
    clipboardItems.clear()

    atom.config.set('clipboard-plus.unique', true)
    atom.clipboard.write('1', {fullLine: false})
    atom.clipboard.write('1', {fullLine: false})
    expect(clipboardItems.size()).toBe 1

  it "delete", ->
    atom.clipboard.write('1', {fullLine: false})
    atom.clipboard.write('2', {fullLine: false})
    atom.clipboard.write('3', {fullLine: false})
    expect(clipboardItems.size()).toBe 3
    clipboardItems.delete(clipboardItems.get(1))
    expect(clipboardItems.size()).toBe 2
    item1 = clipboardItems.get(0)
    expect(item1.text).toBe '1'
    item2 = clipboardItems.get(1)
    expect(item2.text).toBe '3'

  describe 'isIgnoreText', ->
    it 'ignore blank', ->
      atom.clipboard.write('1', {fullLine: false})
      atom.clipboard.write(" \n\n ", {fullLine: true})
      atom.clipboard.write("   \t ", {fullLine: true})
      expect(clipboardItems.size()).toBe 1
      item = clipboardItems.get(0)
      expect(item.text).toBe '1'

    it 'minimumTextLength', ->
      expect(clipboardItems.size()).toBe 0
      atom.clipboard.write('1', {fullLine: false})
      expect(clipboardItems.size()).toBe 1
      atom.config.set('clipboard-plus.minimumTextLength', 3)
      atom.clipboard.write('ab', {fullLine: false})
      expect(clipboardItems.size()).toBe 1
      atom.clipboard.write('abc', {fullLine: false})
      expect(clipboardItems.size()).toBe 2
      atom.clipboard.write('   ab  ', {fullLine: false})
      expect(clipboardItems.size()).toBe 2

    it 'maximumTextLength', ->
      expect(clipboardItems.size()).toBe 0
      atom.clipboard.write('abcdeabcde1', {fullLine: false})
      expect(clipboardItems.size()).toBe 1
      atom.config.set('clipboard-plus.maximumTextLength', 10)
      atom.clipboard.write('abcdeabcde1', {fullLine: false})
      expect(clipboardItems.size()).toBe 1
      atom.clipboard.write('abcdeabcde', {fullLine: false})
      expect(clipboardItems.size()).toBe 2

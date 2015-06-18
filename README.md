# clipboard-plus package

Keeps your clipboard history.
[![Build Status](https://travis-ci.org/aki77/atom-clipboard-plus.svg)](https://travis-ci.org/aki77/atom-clipboard-plus)

[![Gyazo](http://i.gyazo.com/a7a0ec5441f2b3088647f4cc585548e1.gif)](http://gyazo.com/a7a0ec5441f2b3088647f4cc585548e1)

## Features
* can use the copy/cut command of core.
* support for multiple cursors
* basic support system clipboard
* coexist with [emacs-plus package](https://atom.io/packages/emacs-plus).

## Commands
* `clipboard-plus:toggle`
* `clipboard-plus:clear`

## Keymap

No keymap by default.

edit `~/.atom/keymap.cson`

**general**

```coffeescript
'.platform-darwin atom-text-editor:not([mini])':
  'cmd-shift-v': 'clipboard-plus:toggle'

'.platform-win32 atom-text-editor:not([mini])':
  'ctrl-shift-v': 'clipboard-plus:toggle'

'.platform-linux atom-text-editor:not([mini])':
  'ctrl-shift-v': 'clipboard-plus:toggle'
```

**emacs user**

```coffeescript
'atom-text-editor:not([mini])':
  'alt-y': 'clipboard-plus:toggle'
```

## Settings

* `limit` (default: 50)
* `unique` (default: true)
* `minimumTextLength`: (default: 3)
* `maximumTextLength`: (default: 1000)

[![Gyazo](http://i.gyazo.com/07358bcce48205afed9c896759fa4166.png)](http://gyazo.com/07358bcce48205afed9c896759fa4166)

## TODO

- [ ] ui improvements
- [x] watch system clipboard
- [ ] Share a history with multiple projects

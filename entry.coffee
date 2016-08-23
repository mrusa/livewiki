require './src/js/polyfills'

Livewiki = require './src/js/Livewiki.coffee'
Container = require './src/js/Container.coffee'
Term = require './src/js/Term.coffee'

require './src/css/livewiki.css'
require './src/img/spinner.gif'

require './src/icons/black/16x16.png'
require './src/icons/black/32x32.png'
require './src/icons/black/48x48.png'
require './src/icons/black/128x128.png'

require './manifest.json'

ready = (fn) ->
  if document.readyState != 'loading'
    fn()
  else
    document.addEventListener 'DOMContentLoaded', fn


ready ->
  mouse_over_link = false;

  document.addEventListener 'keyup', (e) =>
    if (e.which == 27 || e.which == 91 || e.which == 93 || e.which == 17 || e.ctrlKey) && !mouse_over_link
      Container::remove_container();

  document.querySelector('body').addEventListener 'click', (e) ->
    Container::remove_container();

  a_tags = document.querySelectorAll('a[href^="/wiki/"]:not(.new)')

  Array::forEach.call a_tags, (element, i) ->
    term = '';

    element.addEventListener 'mouseover', (e) ->
      mouse_over_link = true

      link = e.target.getAttribute('href')
      term = new Term(link)

      document.addEventListener 'keyup', term.display

      term.preload().then ((term) ->
        # console.log term
      ), (Error) ->
        console.log Error

    element.addEventListener 'mouseout', (e) ->
      mouse_over_link = false
      document.removeEventListener 'keyup', term.display

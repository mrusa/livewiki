Livewiki = require './src/js/Livewiki.coffee'
Container = require './src/js/Container.coffee'
Term = require './src/js/Term.coffee'

ready = (fn) ->
  if document.readyState != 'loading'
    fn()
  else
    document.addEventListener 'DOMContentLoaded', fn


ready ->
  a_tags = document.querySelectorAll('a[href^="/wiki/"]:not(.new)')

  Array::forEach.call a_tags, (element, i) ->
    term = '';

    element.addEventListener 'mouseover', (e) ->
      link = e.target.getAttribute('href')
      term = new Term(link)

      document.addEventListener 'keydown', term.display

      term.preload().then ((term) ->
        # console.log term
      ), (Error) ->
        console.log Error

    #
    element.addEventListener 'mouseout', (e) ->
      document.removeEventListener 'keydown', term.display

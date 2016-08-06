Livewiki = require './Livewiki.coffee'

class Container extends Livewiki
  constructor: () ->
    @container_element = '';

    element = @find_or_create()
    element.id = 'livewiki'
    element.addEventListener 'click', (e) =>
      e.stopPropagation()

    document.querySelector('body').appendChild(element)

    return element;

  find_or_create: () ->
    @container_element = @find_element()
    @container_element = document.createElement('div') unless @container_element

    return @container_element;

  find_element: () =>
    document.querySelector('#livewiki')

  remove_container: () ->
    container = @find_element()
    container.remove() if container

  remove_terms: () ->
    container = @find_element()
    container.innerHTML = '' if container

module.exports = Container

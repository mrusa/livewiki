Livewiki = require './Livewiki.coffee'

class Container extends Livewiki
  constructor: () ->
    return @find_or_create()

  find_or_create: () ->
    @container_element = document.querySelector('#livewiki')
    @container_element = document.createElement('div') unless @container_element

    @container_element.id = 'livewiki'

    document.querySelector('body').appendChild(@container_element)

    return @container_element;

module.exports = Container

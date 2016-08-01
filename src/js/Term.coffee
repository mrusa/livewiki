Livewiki = require './Livewiki.coffee'
Container = require './Container.coffee'
parser = new DOMParser()

class Term extends Livewiki
  constructor: (link) ->
    super()

    @link = link
    @loaded = false;
    @displayed = false;

    @term = {}
    @container = new Container()

  preload: =>

    new Promise( (resolve, reject) =>

      if @html_element()
        resolve(@)
        return false

      request = new XMLHttpRequest();
      request.open('GET', @link, true);

      request.onload = =>
        if (request.status == 200)

          resp = request.responseText;
          response = parser.parseFromString(resp, 'text/html')

          @headline = response.querySelector(@options.selectors.heading).textContent
          @paragraph = response.querySelector(@options.selectors.paragraph).textContent

          @update_html() if(@displayed)

          resolve(@)

        else
          reject(Error('Term didn\'t load successfully; error code: ' + request.statusText))

      request.onerror = ->
        reject(Error("There was a network error."))

      request.send()
    )

  display: (e) =>
    return false if @html_element()

    @append() if (e.which == 91 || e.which == 93 || e.ctrlKey)

  append: () ->
    @displayed = true
    @container.appendChild(@to_html())

  remove_term: () =>
    @html_element().remove()

  update_html: () =>
    @html_element().querySelector('h1').textContent = @headline
    @html_element().querySelector('p').textContent = @paragraph

  html_element: () =>
    return document.querySelector("[data-href='#{encodeURIComponent(@link)}']")

  to_html: () =>
    fragment = document.createDocumentFragment();

    close_button = create_element('button', 'CLOSE')
    headline = create_element('h1', @headline)
    paragraph = create_element('p', @paragraph)
    div = create_element('div', undefined, 'livewiki_term')

    close_button.addEventListener('click', @remove_term)
    div.setAttribute('data-href', encodeURIComponent(@link))

    fragment.appendChild(close_button);
    fragment.appendChild(headline);
    fragment.appendChild(paragraph);
    div.appendChild(fragment);

    return div

get_parent_element = (element, tag, css_class) ->
  while element.parentElement
    element = element.parentElement

    if element.tagName.toLowerCase() == tag.toLowerCase() and element.classList.contains(css_class)
      console.log 1, element
      return element

create_element = (element, text, css_class) ->
  el = document.createElement(element)

  if text != undefined
    el.textContent = text

  if css_class != undefined
    el.classList.add css_class

  return el

module.exports = Term

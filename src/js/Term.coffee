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
    # TODO: check if the term is already displayed
    new Promise( (resolve, reject) =>
      request = new XMLHttpRequest();
      request.open('GET', @link, true);

      request.onload = =>
        if (request.status == 200)

          resp = request.responseText;
          response = parser.parseFromString(resp, 'text/html')

          @headline = response.querySelector(@options.selectors.heading).textContent
          @paragraph = response.querySelector(@options.selectors.paragraph).innerHTML

          @update_html() if(@displayed)

          resolve(@term)

        else
          reject(Error('Term didn\'t load successfully; error code: ' + request.statusText))

      request.onerror = ->
        reject(Error("There was a network error."))

      request.send()
    )

  display: (e) =>
    @append() if (e.which == 91 || e.which == 93)

  append: () ->
    @displayed = true
    @container.appendChild(@to_html())

  remove_term: () =>
    @html_element().remove()

  update_html: () =>
    @html_element().querySelector('h1').innerHTML = @headline
    @html_element().querySelector('p').innerHTML = @paragraph

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
    el.innerHTML = text

  if css_class != undefined
    el.classList.add css_class

  return el

module.exports = Term

parser = new DOMParser()

Livewiki = require './Livewiki.coffee'
Container = require './Container.coffee'
term_html = require '../html/term.html'

class Term extends Livewiki
  constructor: (link) ->
    super()

    @link = link
    @loaded = false;
    @displayed = false;
    @container = new Container()

    @headline = '';
    @paragraph = '';
    @image_src = '';

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
          image = response.querySelector(@options.selectors.image)

          @image_src = image.getAttribute('src') if image

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

    Container::remove_terms();

    @append() if (e.which == 91 || e.which == 93 || e.ctrlKey)

  append: () ->
    @displayed = true
    @container.appendChild(@to_html())

  remove_term: () =>
    @html_element().remove()

  update_html: () =>
    element = @html_element()

    if element.querySelector('h1')
      element.querySelector('h1').textContent = @headline
    if element.querySelector('p')
      element.querySelector('p').textContent = @paragraph
    if element.querySelector('img')
      element.querySelector('img').src = @image_src if @image_src

  html_element: () =>
    return document.querySelector("[data-href='#{encodeURIComponent(@link)}']")

  to_html: () =>
    term_template = parser.parseFromString(term_html, 'text/html')

    close_button = term_template.querySelector("button")
    div = term_template.querySelector(".livewiki_term")
    headline = term_template.querySelector("h1")
    paragraph = term_template.querySelector("p")
    image = term_template.querySelector("img")

    headline.textContent = @headline
    paragraph.textContent = @paragraph

    console.log @image_src, "isrc"

    if @image_src
      image.src = @image_src
    else if @image_src in [null, '']
      image.remove()


    close_button.addEventListener('click', @remove_term)
    div.setAttribute('data-href', encodeURIComponent(@link))

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

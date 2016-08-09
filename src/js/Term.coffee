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

          headline = response.querySelector(@options.selectors.wikipedia.headline)
          @headline = if headline then headline.textContent else "Error"

          paragraph = response.querySelector(@options.selectors.wikipedia.paragraph);

          if paragraph && paragraph.textContent.length > 5
            @paragraph = paragraph.textContent
          else if !paragraph
            paragraph = response.querySelector('p')
            @paragraph = if paragraph then paragraph.textContent else @paragraph = "Sorry, we couldn't crawl that page."

          image = response.querySelector(@options.selectors.wikipedia.image)
          @image_src = image.getAttribute('src') if image

          @update_html() if(@displayed)
          @display_term(document)

          @loaded = true

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
    term = @to_html()
    if @loaded
      @display_term(term)

    @displayed = true
    @container.appendChild(term)

  remove_term: () =>
    @html_element().remove()

  update_html: () =>
    element = @html_element()

    @set_values(element)

  html_element: () =>
    return document.querySelector("[data-href='#{encodeURIComponent(@link)}']")

  to_html: () =>
    term_template = parser.parseFromString(term_html, 'text/html')

    close_button = term_template.querySelector(@options.selectors.close_button)
    div = term_template.querySelector(@options.selectors.term)
    cover = term_template.querySelector(@options.selectors.cover)
    headline = term_template.querySelector(@options.selectors.headline)
    headline_overlay = term_template.querySelector(@options.selectors.headline_overlay)
    image = term_template.querySelector(@options.selectors.image)
    spinner_image = term_template.querySelector(@options.selectors.spinner_image)

    spinner_image.setAttribute('src', chrome.extension.getURL('spinner.gif'))

    @set_values(term_template)

    if @image_src
      image.src = @image_src
      cover.classList.add('cover--default_size')
    else if @image_src in [null, '']
      headline.classList.add('color--black')
      image.remove()
      headline_overlay.remove()

    close_button.addEventListener('click', @remove_term)
    div.setAttribute('data-href', encodeURIComponent(@link))

    return div

  set_values: (element) =>
    headline = element.querySelector(@options.selectors.headline)
    headline.textContent = @headline if headline

    paragraph = element.querySelector(@options.selectors.paragraph)
    paragraph.textContent = @paragraph if paragraph

    image = element.querySelector(@options.selectors.image)
    image.src = @image_src if image && @image_src

  display_term: (element) =>
    cover = element.querySelector(@options.selectors.cover)
    cover.classList.remove('element--hidden') if cover

    paragraph = element.querySelector(@options.selectors.paragraph)
    paragraph.classList.remove('element--hidden') if paragraph

    spinner = element.querySelector(@options.selectors.spinner)
    spinner.classList.add('element--hidden') if spinner

get_parent_element = (element, tag, css_class) ->
  while element.parentElement
    element = element.parentElement

    if element.tagName.toLowerCase() == tag.toLowerCase() and element.classList.contains(css_class)
      return element

module.exports = Term

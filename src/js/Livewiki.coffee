default_options =
  selectors:
    wikipedia:
      headline: '#firstHeading'
      paragraph: '#mw-content-text > p'
      image: '.thumbimage'

    term: '.livewiki_term'
    cover: '.term__cover'
    close_button: 'button'
    headline: '.headline'
    headline_overlay: '.headline__overlay'
    paragraph: '.term__content'
    image: '.term__image'
    spinner: '.spinner'
    spinner_image: '.spinner__image'

class Livewiki

  constructor: (options) ->
    @options = {}
    @container_element = ''

    Object.assign(@options, default_options, options);

  add_term: (term) ->
    @terms.push term

  get_terms: () =>
    return @terms

module.exports = Livewiki

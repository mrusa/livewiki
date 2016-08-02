default_options = {
  selectors: {
    heading: '#firstHeading',
    paragraph: '#mw-content-text > p'
  }
}

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

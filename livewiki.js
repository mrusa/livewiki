/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var Container, Livewiki, Term, ready;

	Livewiki = __webpack_require__(1);

	Container = __webpack_require__(2);

	Term = __webpack_require__(3);

	ready = function(fn) {
	  if (document.readyState !== 'loading') {
	    return fn();
	  } else {
	    return document.addEventListener('DOMContentLoaded', fn);
	  }
	};

	ready(function() {
	  var a_tags;
	  a_tags = document.querySelectorAll('a[href^="/wiki/"]:not(.new)');
	  return Array.prototype.forEach.call(a_tags, function(element, i) {
	    var term;
	    term = '';
	    element.addEventListener('mouseover', function(e) {
	      var link;
	      link = e.target.getAttribute('href');
	      term = new Term(link);
	      document.addEventListener('keydown', term.display);
	      return term.preload().then((function(term) {}), function(Error) {
	        return console.log(Error);
	      });
	    });
	    return element.addEventListener('mouseout', function(e) {
	      return document.removeEventListener('keydown', term.display);
	    });
	  });
	});


/***/ },
/* 1 */
/***/ function(module, exports) {

	var Livewiki, default_options,
	  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

	default_options = {
	  selectors: {
	    heading: '#firstHeading',
	    paragraph: '#mw-content-text p'
	  }
	};

	Livewiki = (function() {
	  function Livewiki(options) {
	    this.get_terms = bind(this.get_terms, this);
	    this.options = {};
	    this.container_element = '';
	    Object.assign(this.options, default_options, options);
	  }

	  Livewiki.prototype.add_term = function(term) {
	    return this.terms.push(term);
	  };

	  Livewiki.prototype.get_terms = function() {
	    return this.terms;
	  };

	  return Livewiki;

	})();

	module.exports = Livewiki;


/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	var Container, Livewiki,
	  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
	  hasProp = {}.hasOwnProperty;

	Livewiki = __webpack_require__(1);

	Container = (function(superClass) {
	  extend(Container, superClass);

	  function Container() {
	    return this.find_or_create();
	  }

	  Container.prototype.find_or_create = function() {
	    this.container_element = document.querySelector('#livewiki');
	    if (!this.container_element) {
	      this.container_element = document.createElement('div');
	    }
	    this.container_element.id = 'livewiki';
	    document.querySelector('body').appendChild(this.container_element);
	    return this.container_element;
	  };

	  return Container;

	})(Livewiki);

	module.exports = Container;


/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	var Container, Livewiki, Term, create_element, get_parent_element, parser,
	  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
	  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
	  hasProp = {}.hasOwnProperty;

	Livewiki = __webpack_require__(1);

	Container = __webpack_require__(2);

	parser = new DOMParser();

	Term = (function(superClass) {
	  extend(Term, superClass);

	  function Term(link) {
	    this.to_html = bind(this.to_html, this);
	    this.update_html = bind(this.update_html, this);
	    this.remove_term = bind(this.remove_term, this);
	    this.display = bind(this.display, this);
	    this.preload = bind(this.preload, this);
	    Term.__super__.constructor.call(this);
	    this.link = link;
	    this.loaded = false;
	    this.displayed = false;
	    this.term = {};
	    this.container = new Container();
	  }

	  Term.prototype.preload = function() {
	    return new Promise((function(_this) {
	      return function(resolve, reject) {
	        var request;
	        request = new XMLHttpRequest();
	        request.open('GET', _this.link, true);
	        request.onload = function() {
	          var resp, response;
	          if (request.status === 200) {
	            resp = request.responseText;
	            response = parser.parseFromString(resp, 'text/html');
	            _this.headline = response.querySelector(_this.options.selectors.heading).textContent;
	            _this.paragraph = response.querySelector(_this.options.selectors.paragraph).innerHTML;
	            if (_this.displayed) {
	              _this.update_html();
	            }
	            return resolve(_this.term);
	          } else {
	            return reject(Error('Term didn\'t load successfully; error code: ' + request.statusText));
	          }
	        };
	        request.onerror = function() {
	          return reject(Error("There was a network error."));
	        };
	        return request.send();
	      };
	    })(this));
	  };

	  Term.prototype.display = function(e) {
	    if (e.which === 91 || e.which === 93) {
	      return this.append();
	    }
	  };

	  Term.prototype.append = function() {
	    this.displayed = true;
	    return this.container.appendChild(this.to_html());
	  };

	  Term.prototype.remove_term = function() {
	    return document.querySelector('[data-href="' + encodeURIComponent(this.link) + '"]').remove();
	  };

	  Term.prototype.update_html = function() {
	    var term_html;
	    term_html = document.querySelector('[data-href="' + encodeURIComponent(this.link) + '"]');
	    term_html.querySelector('h1').innerHTML = this.headline;
	    return term_html.querySelector('p').innerHTML = this.paragraph;
	  };

	  Term.prototype.to_html = function() {
	    var close_button, div, fragment, headline, paragraph;
	    fragment = document.createDocumentFragment();
	    close_button = create_element('button', 'CLOSE');
	    headline = create_element('h1', this.headline);
	    paragraph = create_element('p', this.paragraph);
	    div = create_element('div', void 0, 'livewiki_term');
	    close_button.addEventListener('click', this.remove_term);
	    div.setAttribute('data-href', encodeURIComponent(this.link));
	    fragment.appendChild(close_button);
	    fragment.appendChild(headline);
	    fragment.appendChild(paragraph);
	    div.appendChild(fragment);
	    return div;
	  };

	  return Term;

	})(Livewiki);

	get_parent_element = function(element, tag, css_class) {
	  while (element.parentElement) {
	    element = element.parentElement;
	    if (element.tagName.toLowerCase() === tag.toLowerCase() && element.classList.contains(css_class)) {
	      console.log(1, element);
	      return element;
	    }
	  }
	};

	create_element = function(element, text, css_class) {
	  var el;
	  el = document.createElement(element);
	  if (text !== void 0) {
	    el.innerHTML = text;
	  }
	  if (css_class !== void 0) {
	    el.classList.add(css_class);
	  }
	  return el;
	};

	module.exports = Term;


/***/ }
/******/ ]);
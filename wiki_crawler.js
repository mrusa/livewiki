var key_pressed = false;
var mouse_over_link = false;

ready = function(fn) {
  if (document.readyState != 'loading'){
    fn();
  } else {
    document.addEventListener('DOMContentLoaded', fn);
  }
}

append_element = function(e){
	if(e.which == "91" || e.which == "93") {
		link.appendChild(first_paragraph)
		appended_elements.push(first_paragraph)

		key_pressed = true
	}
}

remove_element = function(e) {
	key_pressed = false

	Array.prototype.forEach.call(appended_elements, function(el, i) {
		el.remove()
	})

	first_paragraph.remove()
	appended_elements.pop()

	if(!mouse_over_link) {
		document.removeEventListener("keyup", remove_element)	
	}
}

ready(function(){

	var parser = new DOMParser();
    var fragment = document.createDocumentFragment();

	a_tags = document.querySelectorAll('a[href^="/wiki/"]:not(.new)')
	appended_elements = new Array()


	Array.prototype.forEach.call(a_tags, function(el, i){
		el.addEventListener("mouseover", function(e){
			mouse_over_link = true

			link = e.target
			link_url = link.getAttribute("href")

			var request = new XMLHttpRequest();
			request.open('GET', link_url, true);

			request.onload = function() {
			  if (request.status >= 200 && request.status < 400) {
			    // Success!
			    var resp = request.responseText;

		    	parsed_response = parser.parseFromString(resp, "text/html")

			    first_paragraph = parsed_response.querySelectorAll("#mw-content-text p")[0]

				first_paragraph.id = "livewiki"

				document.addEventListener("keydown", append_element)
				document.addEventListener("keyup", remove_element)

			  }
			};

			request.onerror = function() {
			  // There was a connection error of some sort
			};

			request.send();

		})

		el.addEventListener("mouseout", function(e){
			mouse_over_link = false
			document.removeEventListener("keydown", append_element)
		})
	});
})



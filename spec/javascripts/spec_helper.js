// Use this file to require common dependencies or to setup useful test functions.

function fixture(element) {
	var fixtures = $('#fixtures');
	if (fixtures.size() === 0) fixtures = $('<div id="fixtures"/>').appendTo("body")
  fixtures.append(element);
}

function teardownFixtures() {
  $("#fixtures").remove();
}

// Stub out some common plugins.
jQuery.fn.live = function(){};
jQuery.fn.defaultValue = function(){};
// Use this file to require common dependencies or to setup useful test functions.

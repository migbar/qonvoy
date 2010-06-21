var Interests = function ($) {
	var split = function (val) {
		return $.grep($.map(val.split(/,\s*/), function (s) { return $.trim(s); }), function (v) { return v !== ''; });
	};
	
	var extractLast = function (term) {
		return split(term).pop();
	};
	
	return {
		init: function (group) {
			var linksSelector = '#' + group + '.interests a';
			var interestsField = $('#user_' + group);
			var availableTags = $(linksSelector).map(function (i, e) { return $(e).text(); });
			
			var appendTag = function (existing, added, pop) {
				var terms = split( existing );
				
				if (pop) terms.pop();
				terms.push( added );
				terms.push("");
				return terms.join(", ");
			};
			
			$(linksSelector).click(function (event) {
				var link = $(this), text = link.text();
				
				if (link.hasClass('selected')) {
					link.removeClass('selected');
					var terms = split(interestsField.val());
					terms.splice($.inArray(text, terms), 1);
					interestsField.val(terms.join(', '));
				} else {
					link.addClass('selected');
					interestsField.val(appendTag(interestsField.val(), text));
				}
			});
			
			function selectInterests(values) {
				$(linksSelector).removeClass('selected');
				$.each(values, function (i, value) {
					$(linksSelector+'[title='+value+']').addClass('selected');
				});
			}			
			
			selectInterests(split(interestsField.val()));
			
			interestsField.keydown(function (event) {
				var keyCode    = $.ui.keyCode,
					autocomplete = $(this).data('autocomplete'),
					menu         = autocomplete.menu;
				if (event.keyCode === keyCode.ENTER) {
					menu.next(event);
					menu.select(event);
					event.preventDefault();
				}
			});
			
			interestsField.focus(function () {
				var values = split($(this).val());
				values.push("");
				$(this).val(values.join(', '));
			});
			
			interestsField.autocomplete({
				minLength: 1,
				source: function(request, response) {
					var values = split(request.term);
					var last = values[values.length-1];
					
					selectInterests(values);
					
					var filtered = $.ui.autocomplete.filter(availableTags, last);
					
					if (filtered.length === 0) {
						values.pop();
						values.push("");
						interestsField.val(values.join(', '));
					}
					
					response(filtered);
				},
				select: function(event, ui) {
					console.log("select(): ", this.value, ui.item.value);
					this.value = appendTag(this.value, ui.item.value, true);
					selectInterests(split(this.value));
					return false;
				}
			});
		}
	};
}(jQuery);

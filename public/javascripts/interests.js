var Interests = function ($) {
	function split(val) {
		return val.split(/,\s*/);
	}
	
	function extractLast(term) {
		return split(term).pop();
	}
	
	return {
		init: function (group) {
			var linksQuery = '#' + group + '.interests a';
			var availableTags = $(linksQuery).map(function (i, e) { return $(e).text(); });
			
			function selectInterests(values) {
				$(linksQuery).removeClass('selected');

				$.each(values, function (i, value) {
					console.log(value);
					$(linksQuery+'[title='+value+']').addClass('selected');
				});
			}			
			selectInterests(split($('#user_' + group).val()));
			
			$('#user_' + group).autocomplete({
				minLength: 0,
				source: function(request, response) {
					var values = split(request.term);
					var last = values[values.length-1];
					
					selectInterests(values);
					
					response($.ui.autocomplete.filter(availableTags, last));
				},
				focus: function() {
					return false;
				},
				select: function(event, ui) {
					var terms = split( this.value );
					terms.pop();
					terms.push( ui.item.value );
					terms.push("");
					this.value = terms.join(", ");
					return false;
				}
			});
		}
	};
}(jQuery);

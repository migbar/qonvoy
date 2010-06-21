/*global Screw, before, after, fixture, teardownFixtures, expect, describe, be_null, Interests, it, be_true*/

require("spec_helper.js");
require("../../public/javascripts/jquery-ui-1.8.1.custom.min.js");
require("../../public/javascripts/interests.js");

Screw.Unit(function() {
	describe("Interests", function() {
		describe("init", function () {
			
			var controlChars = [18,8,20,188,17,46,40,35,13,27,36,45,37,107,110,111,108,106,109,34,33,190,39,16,9,38];	
			
			function keydown(field, key) {
				var charCode = typeof(key) === 'number' ? key : key.charCodeAt(0);
				var e = $.Event("keydown");
				e.which = charCode;
				field.trigger(e);
				
				if ($.inArray(charCode, controlChars) < 0) {
					field.val(field.val() + String.fromCharCode(charCode));
				}
			}
			
			function sendKeys(keys, field) {
				field = $(field);
				
				if (typeof(keys) === 'string') {
					$.each(keys, function (i, v) {
						keydown(field, v);
					});
				} else {
					keydown(field, keys);
				}
			}
			
			function expectSelectedInterest(group, interest) {
				var elements = $('#'+ group + ' a').filter(function () { return $(this).attr('title') === interest; });
				expect(elements.hasClass('selected')).to(be_true);
			}
			
			function field() {
				return $('#user_cuisine');
			}
			
			after(function(){ teardownFixtures(); });

			before(function () {
				var interests = $('<div id="cuisine" class="interests"/>');
				$.each(['french', 'chinese', 'italian'], function (i, v) {
					interests.append($('<a href="#"/>').attr('title', v).text(v));
				});
				fixture(interests);
				fixture($('<input type="text" id="user_cuisine" value="french"/>'));
			});
			
			it("appends a ', ' to the field value when focused", function () {
				Interests.init('cuisine');
				field().trigger('focus');
				expect(field().val()).to(equal, 'french, ');
			});
			
			it("does not append a ', ' to the field value if already ends in ',' or ', '", function() {
				field().val('french, ');
				Interests.init('cuisine');
				field().trigger('focus');
				expect(field().val()).to(equal, 'french, ');
			});
			
			it("initializes the input field for the specified group with autocomplete", function () {
				Interests.init('cuisine');
				expect($('#user_cuisine').data('autocomplete')).to_not(be_null);
			});
			
			it("adds the 'selected' class to tags which are part of the input", function () {
				Interests.init('cuisine');
				expectSelectedInterest('cuisine', 'french');
			});
			
			// it("selects the correct interest when typing in a partial match and tab and enter is pressed", function() {
			// 	Interests.init('cuisine');
			// 	field().trigger('focus');
			// 	
			// 	sendKeys("ita", "#user_cuisine");
			// 	sendKeys($.ui.keyCode.DOWN, "#user_cuisine");
			// 	
			// 	sendKeys($.ui.keyCode.ENTER, "#user_cuisine");
			// 	expectSelectedInterest('cuisine', 'italian');
			// });
			
		});
	});
});

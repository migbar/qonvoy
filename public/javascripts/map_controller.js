var MapController = function ($) {
	var markers = [], map = null;
	
	var _init = function (callback) {
		$(document).ready(function () {
			map = callback();
		});
	};
	
	var _addMarker = function (marker) {
		markers[markers.length] = marker;
	};
	
	var _getMarker = function (i) {
		return markers[i];
	};
	
	var _getMarkerId = function (i) {
		return "mtgt_unnamed_" + i;
	};
	
	return {
		addMarker: _addMarker,
		init: _init,
		getMarker: _getMarker,
		getMarkerId: _getMarkerId
	};
}(jQuery);

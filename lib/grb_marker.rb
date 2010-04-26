class GrbMarker < Ym4r::GmPlugin::GMarker
  def create
    %Q|
      (function () {
      	var marker = #{super}

      	MapController.addMarker(marker);

      	return marker;
      })()
    |
  end
end
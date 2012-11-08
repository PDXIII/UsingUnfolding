import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.utils.*;
import de.fhpotsdam.unfolding.providers.*;
import processing.opengl.*;
import codeanticode.glgraphics.*;

UnfoldingMap map;
List<Marker> countryMarkers;

void setup() {
  size(800, 600, GLConstants.GLGRAPHICS);
  smooth();

  map = new UnfoldingMap(this);
  MapUtils.createDefaultEventDispatcher(this, map);

  List<Feature> countries = GeoJSONReader.loadData(this, "countries.geo.json");
  countryMarkers = MapUtils.createSimpleMarkers(countries);
}

void draw() {
  map.draw();
  for (int i = 0; i < countryMarkers.size(); i++){
    Marker country = countryMarkers.get(i);
    if(country.isInside(map, mouseX, mouseY)){
      country.draw(map);
      HashMap countryProps = country.getProperties();
      String countryName = countryProps.get("name").toString();
      println(countryName);
    }
  }
}
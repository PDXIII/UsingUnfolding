---
layout: page
title: GeoJSONApp-ext01
category: GeoJSONApp
teaser: In the second part we are going to create a hover effect and string output.
prev: GeoJSONApp-basic
next: GeoJSONApp-ext02
lightbox:
- GeoJSONApp-ext01-1a.png
- GeoJSONApp-ext01-1b.png
- GeoJSONApp-ext01-2a.png
- GeoJSONApp-ext01-2b.png
- GeoJSONApp-ext01-3a.png
- GeoJSONApp-ext01-3b.png
- GeoJSONApp-ext01-4a.png
- GeoJSONApp-ext01-4b.png
titleimage: GeoJSONApp-ext01-title.png
---

That means we don't want the `countryMarkers` to be added to the `map` and for further use we need those `Markers` globaly. So please make following changes:

**DELETE:**

{% highlight java %}

    map.addMarkers(countryMarkers);

{% endhighlight %}

**INSERT (AT TOP):**

{% highlight java %}

    List<Marker> countryMarkers;

{% endhighlight %}

**CHANGE:**

{% highlight java %}

    List<Marker> countryMarkers = MapUtils.createSimpleMarkers(countries);

{% endhighlight %}

**INTO:**

{% highlight java %}

    countryMarkers = MapUtils.createSimpleMarkers(countries);

{% endhighlight %}

**RUN THE PROGRAM!**

If you get no error and you see no shape – everthing is fine!

Remember, that we only want to see the country's shape when we hover it. Therefore we need to ask every country, if the mouse is inside its borders and then tell the country to draw itself. Please move to your `draw()` function and edit it like this:

{% highlight java %}

    void draw() {
      map.draw();
      for (int i = 0; i < countryMarkers.size(); i++){
        Marker country = countryMarkers.get(i);
        if(country.isInside(map, mouseX, mouseY)){
          country.draw(map);
        }
      }
    }

{% endhighlight %}

**RUN!**

Ah! Nice! We have a hover effect. At this point I'd like to talk a little bit about the use of the properties of a geo.json feature. Often you will find really useful content inside it. For example every feature (country) of our *countries.geo.json* contains the full name of its country. You can use this to eventually display it. 

The properties are stored in a `HashMap`, though you can get a value by looking for the wanted key, in this case `"name"`.

Please edit your if-statement like this:

{% highlight java %}

    if(country.isInside(map, mouseX, mouseY)){
      country.draw(map);
      HashMap countryProps = country.getProperties();
      String countryName = countryProps.get("name").toString();
      println(countryName);
    }

{% endhighlight %}

**RUN!**

Now you should have the hover effect and a string output in your console. Good Job! If you should have contrary to expectations any trouble, then you can now compare your code:

{% highlight java %}

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

{% endhighlight %}

[next part …][GeoJSONApp-ext02]

{% include linklist.md %}
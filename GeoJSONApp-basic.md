---
layout: page
title: GeoJSONApp-basic
category: GeoJSONApp
teaser: In our first part we are going to chase some data for our map.
next: GeoJSONApp-ext01
titleimage: GeoJSONApp-basic-title.png
---

##Data
We need to give our program the chance to know, if the mouse is inside a country or not. So, we need the shapes of the countries. A nice file wich serves the purpose could be found here: [countries.geo.json][countries.geo.json].
The shapes in this file are a little rough, but this provides better performance for our app. Then we need the locations of all airports. Let's take a look at [GeoCommons][GeoCommons]. Type into the search field "world airports" and hit the first result. As you can see, there is no option for downloading a valid *geo.json* version of this data set, but I have a gift for you: 

<button class="btn"><a href="javascript:(function(){var currURL=document.URL;var dataSetID=currURL.match('([0-9]+)');var dataSetURL='http://geocommons.com/overlays/'+dataSetID[0]+'/features.json?geojson=1';dataSetJSON=window.open(dataSetURL,'GeoCommonsJSON');}());">GeoCommonsGEOJSON</a>
</button> 

Drag this button into bookmark bar to create a bookmarklet.

Now when you are back on the data-set at *GeoCommons* you only need to hit this bookmarklet and you will be led to a valid *geo.json* version of this data-set. Save it as *WorldAirports.geo.json*

Now, we have two files: *countries.geo.json* and *WorldAirports.json*. So, let's write some code.

**Note:** While writing this tutorial, the world airports data-set disappeared on GeoCommons. But there is a version in the download files.

##Code
Let's start with opening the *GeoJsonApp.pde* from the examples folder of the Unfolding library, save it as *GeoJSONApp-basic.pde* and add the files to your project (for lazy guys is this sketch already included in the download folder). 

###Countries & Interaction
Now, let's see how the countries will be displayed by changing the following

{% highlight java %}
      List<Feature> countries = GeoJSONReader.loadData(this, "countries-simple.geo.json");
{% endhighlight %}

into

{% highlight java %}
      List<Feature> countries = GeoJSONReader.loadData(this, "countries.geo.json");
{% endhighlight %}

**Run!**

Yes, I told you the shapes are rough, but the performance is quite good. Please don't mind the gray, you can take care about that later. The bigger problem for now is: we don't want the countries to be displayed permanently. Just when the mouse hovers it, we want to see the shape. So let`s continue with the [next part …][GeoJSONApp-ext01]

{% include linklist.md %}


# Monthly indoorCO2map.com summary January 2026

There is a well documented relationship between indoor levels of
CO<sub>2</sub> and the amount of ventilation in indoor environments.
Buildings with high indoor levels of CO<sub>2</sub> have poor
ventilation and are therefore more likely to be vectors of airborne
diseases (like COVID-19, Measles, and Flu) and to trap indoor
pollutants.

Measuring CO<sub>2</sub> inside is a cheap way of measuring the air
quality in indoor environments. When we breathe, we exhale
CO<sub>2</sub> and it gets trapped inside the room we are in. If the
building has good ventilation it will leave quickly. If it has bad
ventilation, it stays in the room and builds up.

If there is bad ventilation, then smoke from cooking can build up and
that’s bad for you. Same thing for VOCs from perfumes, as well as gas
leaks, radon, and mold spores. At high concentrations in artificial
environments, they contribute to all sorts of things:
cancer<sup>1</sup>, Alzheimer’s<sup>2–4</sup>, Parkinson’s<sup>3</sup>,
childhood asthma<sup>5–9</sup>, childhood lung problems<sup>10,11</sup>,
and heart conditions<sup>12</sup>. Bad ventilation also contributes to a
much higher risk of respiratory infections. If someone who is sick
breathes in a badly ventilated room, the infectious aerosols will float
around in the room until someone breathes them in. In a well ventilated
space, they are dispersed very quickly and the risk of infection is much
lower. Having an open window in a classroom (or having an air filter),
for instance, reduces school absences significantly.

CO<sub>2</sub> levels outside are typically around 420 parts per million
(ppm), so if we measure the CO<sub>2</sub> in a room and it is higher
than that, you know its not ventilating much. Anywhere from 400 - 600
ppm are considered well ventilated. Every indoor environment is going to
trap some CO<sub>2</sub> and that’s okay. Levels between 600 ppm and
1000 ppm may need some improvement. Anything above 1000 ppm is generally
considered bad and should certainly be improved in some manner.

[Indoor CO2-Map](https://indoorco2map.com) is a community science
project to monitor indoor CO<sub>2</sub> levels in non-residential
buildings and transit systems around the world. Since April 2024
volunteers have brought CO<sub>2</sub> monitors into cafes, shops,
schools, trains, and all sorts of other places to monitor CO<sub>2</sub>
levels in them and upload them to a public database.

The following is a monthly summary of how this project is going.

## Buildings

<img src="monthly_report_files/figure-commonmark/animbuildings-1.gif"
style="width:100.0%" />

<div class="cr-section">

This month there were 963 measurements of 739 unique buildings.

<sup>**cr-ccplot?**</sup>

The most measured building was Rewe, a supermarket in Kassel, Germany
(min: 682, mean: 773, max: 844), which was measured 13 times.

There were measurements in 24 separate countries. Additionally, the
first measurement was added in Taiwan this month. Welcome to the
glorious world of CO<sub>2</sub> monitoring Taiwan!

<sup>**cr-histco2plot?**</sup>

Here is a graph that shows the distribution of all the CO<sub>2</sub>
measurements this month. The dashed red line shows the median which was
846 ppm. There are many measurements that we would consider good
CO<sub>2</sub> levels, however, you’ll notice that about 32 percent are
over 1000 ppm, which really should be addressed.

<div id="cr-histco2plot">

![](monthly_report_files/figure-commonmark/unnamed-chunk-9-1.png)

</div>

<div id="cr-ccplot">

![](monthly_report_files/figure-commonmark/unnamed-chunk-11-1.png)

</div>

<sup>**cr-buildingtypes?**</sup>

This graph shows the distribution of the most common building types in
the month of January. The dark bar in the middle of each box and whisker
plot shows the median value for each category. The rest of the lines
show the range of the distribution. Most of the values fall within each
box. If you want more information about how to interpret this graph,
watch [this video](https://youtu.be/b2C9I8HuCe4?si=73FKu7wSJr1rWwWt).

As is common, supermarkets tend to have higher CO<sub>2</sub> values
than other types of buildings. I’ve converted those CO<sub>2</sub>
values to the percentage of rebreathed air, which specifies how much of
each breath you take has already been exhaled by someone else.

<div id="cr-buildingtypes">

![](monthly_report_files/figure-commonmark/buildingtypes2-1.png)

</div>

Here is a graph of all the recordings that happened this month shown by
the grey curves. I’ve highlighted the highest
one.<sup>**cr-allcurves?**</sup>

The building with the highest measured CO<sub>2</sub> levels was
CineStar in Saarbrücken, Germany with a median CO<sub>2</sub> value of
6593 ppm. While this is incredibly high, it is important to realize that
this is an outlier. The majority of measurements are much lower than
this. There is a boxplot to the right of the graph which shows where the
majority of measurements fall.

The building with the lowest measured CO<sub>2</sub> levels was Lidl in
Wolfsberg, Austria with a median CO<sub>2</sub> value of 419.5 ppm.
There were some measurements that were even lower than this, but we have
removed them from this analysis. Generally outdoor CO<sub>2</sub> levels
don’t go below 410 ppm, therefore we have removed any datapoints that
are below 400 ppm. If your CO<sub>2</sub> monitor consistently shows
levels below 410 ppm while you are inside or outside, it is likely that
your monitor needs recalibrating.

<div id="cr-allcurves">

![](monthly_report_files/figure-commonmark/allcurves3-1.png)

</div>

</div>

Here is a chart showing the 7 measurements that had a median
CO<sub>2</sub> value under 500. Keep in mind that some of these are
potentially miscalibrated sensors or erroneous recordings where the
sensor was outside. However, it is important to celebrate the places
that do in fact have well ventilated spaces.

<div>

<div id="nrwxykcfts" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#nrwxykcfts table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#nrwxykcfts thead, #nrwxykcfts tbody, #nrwxykcfts tfoot, #nrwxykcfts tr, #nrwxykcfts td, #nrwxykcfts th {
  border-style: none;
}
&#10;#nrwxykcfts p {
  margin: 0;
  padding: 0;
}
&#10;#nrwxykcfts .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#nrwxykcfts .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#nrwxykcfts .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#nrwxykcfts .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#nrwxykcfts .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#nrwxykcfts .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#nrwxykcfts .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#nrwxykcfts .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#nrwxykcfts .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#nrwxykcfts .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#nrwxykcfts .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#nrwxykcfts .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#nrwxykcfts .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#nrwxykcfts .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#nrwxykcfts .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#nrwxykcfts .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#nrwxykcfts .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#nrwxykcfts .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 0px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#nrwxykcfts .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#nrwxykcfts .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#nrwxykcfts .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#nrwxykcfts .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#nrwxykcfts .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#nrwxykcfts .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#nrwxykcfts .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#nrwxykcfts .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#nrwxykcfts .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#nrwxykcfts .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#nrwxykcfts .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#nrwxykcfts .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#nrwxykcfts .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#nrwxykcfts .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#nrwxykcfts .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#nrwxykcfts .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#nrwxykcfts .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#nrwxykcfts .gt_left {
  text-align: left;
}
&#10;#nrwxykcfts .gt_center {
  text-align: center;
}
&#10;#nrwxykcfts .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#nrwxykcfts .gt_font_normal {
  font-weight: normal;
}
&#10;#nrwxykcfts .gt_font_bold {
  font-weight: bold;
}
&#10;#nrwxykcfts .gt_font_italic {
  font-style: italic;
}
&#10;#nrwxykcfts .gt_super {
  font-size: 65%;
}
&#10;#nrwxykcfts .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#nrwxykcfts .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#nrwxykcfts .gt_indent_1 {
  text-indent: 5px;
}
&#10;#nrwxykcfts .gt_indent_2 {
  text-indent: 10px;
}
&#10;#nrwxykcfts .gt_indent_3 {
  text-indent: 15px;
}
&#10;#nrwxykcfts .gt_indent_4 {
  text-indent: 20px;
}
&#10;#nrwxykcfts .gt_indent_5 {
  text-indent: 25px;
}
&#10;#nrwxykcfts .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#nrwxykcfts div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>

| Measurements under 500 ppm |         |               |                                |
|----------------------------|---------|---------------|--------------------------------|
| Name                       | CO2 ppm | Building type | Location                       |
| ESO Supernova Planetarium  | 494.0   | Planetarium   | Garching bei München, Germany  |
| CVS Pharmacy               | 493.0   | Pharmacy      | Iowa City, United States       |
| Liverpool Street           | 489.0   |               | City of London, United Kingdom |
| Rådhuspladsen              | 443.0   | Station       | København, NA                  |
| 了凡油雞飯.麵              | 483.0   | Restaurant    | 桃園市, Taiwan                 |
| Lidl                       | 419.5   | Supermarket   | Wolfsberg, Austria             |
| Palí                       | 475.0   | Supermarket   | La Fortuna, Costa Rica         |

</div>

</div>

## Trends over time

<img src="monthly_report_files/figure-commonmark/animtrends-1.gif"
style="width:100.0%" />

The following are charts that are updated every month, but they reflect
all data collected so far from the indoorco2 monitoring project (since
April 2024). Over time, we should be able to see yearly trends where
CO<sub>2</sub> levels are higher in the Winter when shopkeepers close
their windows to keep things warm and then lower CO<sub>2</sub> levels
when shopkeepers open their windows in the Summer.

<div class="cr-section">

<sup>**cr-metweekall?**</sup>

We can start to see trends like in this graph which shows CO<sub>2</sub>
against the week of the year. There are two relevant points you should
know about the X axis, `Week of the year (meteorological)`, before
moving on.

1.  Datapoints are aggregated into weeks regardless of the year they are
    collected in, so some weeks were measured in 2024, 2025 and 2026 but
    they would all show up in the same week number.

2.  This accounts for the hemisphere in which the recording was
    collected. Since Winter in the Southern Hemisphere is June through
    August, while Winter in the Northern Hemisphere is December through
    February, we have adjusted the week numbers so that they line up
    meterologically. Essentially, a measurement collected in the
    Northern Hemisphere on the first of January would show up as week 1,
    however, a measurement collected in the Southern Hemisphere on the
    first of January would show up as week 27.

<div id="cr-metweekall">

![](monthly_report_files/figure-commonmark/metweekall-1.png)

</div>

<sup>**cr-metweektype?**</sup>

If we split the graph by the most popular building types, we can start
to see some interesting trends. Supermarkets remain relatively high
throughout the year with little variation while fast food, and chemists
have quite a strong dip in CO<sub>2</sub> levels during the Summer. This
may be because most supermarkets keep their doors closed throughout the
year and they tend to have larger buildings; conversely, chemists and
fast food restaurants tend to be small to medium sized buildings which
means that they can be very easily ventilated if they leave their front
door open in the Summer. Restaurants have a very interesting trend here,
the strong upward trend of the model at the end of the year is probably
due to not enough measurements of restaurants yet rather that there
being any meaningful conclusions. Over time we should hopefully see more
stable trends show up.

<div id="cr-metweektype">

![](monthly_report_files/figure-commonmark/metweektype-1.png)

</div>

Here’s a histogram showing how many measurements have been recorded each
week since the start of the project. Over the last 12 months there have
been 10707 building measurements which is 892 per month or 206 per
week.<sup>**cr-allhist?**</sup>

<div id="cr-allhist">

![](monthly_report_files/figure-commonmark/allhist-1.png)

</div>

</div>

## Transit

<img src="monthly_report_files/figure-commonmark/animtransit-1.gif"
style="width:100.0%" />

<div class="cr-section">

This month there were 341 measurements of 169 unique transit lines. The
most measured transit line was subway U6 in the U-Bahn Wien transit
network in Wien, Austria (min: 491, mean: 737, max: 1187), which was
measured 20 times. This graph shows the number of transit recordings in
each transit network during the last month. Keep in mind that this graph
only shows networks with more than 2 transit recordings this month
(there were quite a few with one or two). Transit recordings seem very
popular in Vienna at the moment.<sup>**cr-transitcount?**</sup>

<div id="cr-transitcount">

</div>

When we look at the distribution of CO<sub>2</sub> measurements by the
transit type this month we can see some patterns. Trains often have
higher CO<sub>2</sub> values than buses, subways and trams because they
usually travel for longer distances between stations. This causes trains
to rely more heavily on mechanical ventilation than buses, subways, and
trams which open their doors at stations more
frequently.<sup>**cr-transitmonthbox?**</sup>

<div id="cr-transitmonthbox">

![](monthly_report_files/figure-commonmark/transitmonthbox-1.png)

</div>

This trend can also be seen when we look at the distribution of each
transit type on all the data from 2024, 2025 and
2026.<sup>**cr-transitallbox?**</sup>

<div id="cr-transitallbox">

![](monthly_report_files/figure-commonmark/transitallbox-1.png)

</div>

</div>

That’s all for this month! Check back soon for more updates.

If this was useful to you, please consider [supporting
me](https://liberapay.com/samherniman/) so I can make more things like
this. I would be incredibly grateful.

<script src="https://liberapay.com/samherniman/widgets/button.js"></script>
<noscript>
<a href="https://liberapay.com/samherniman/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a>
</noscript>

### Some news

Recently Aurel Wünsch and I gave a talk about this project at Fluconf
2026. Check out the [recording
here](https://www.youtube.com/live/60YwSH9g3Bg?si=RAdTgYvftXXevaIa), and
the [companion website
here](https://samherniman.github.io/Fluconf2026-indoorco2map/abstract.html).

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/60YwSH9g3Bg?si=WsgFugFTD8ozkfF6" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen>
</iframe>

I was also interviewed for a podcast. You can listen to the [recording
here](https://soundcloud.com/modulator-69529428/the-indoor-co2-map-community-science-in-the-pandemicene?si=c21857205e794f34998da835bf581d61&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing).

<iframe width="100%" height="166" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/soundcloud%253Atracks%253A2258686259&amp;color=%23ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;show_teaser=true">
</iframe>

<div style="font-size: 10px; color: #cccccc;line-break: anywhere;word-break: normal;overflow: hidden;white-space: nowrap;text-overflow: ellipsis; font-family: Interstate,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Garuda,Verdana,Tahoma,sans-serif;font-weight: 100;">

<a href="https://soundcloud.com/modulator-69529428" title="modulator" target="_blank" style="color: #cccccc; text-decoration: none;">modulator</a>
·
<a href="https://soundcloud.com/modulator-69529428/the-indoor-co2-map-community-science-in-the-pandemicene" title="The Indoor CO2 Map: Community Science in the Pandemicene" target="_blank" style="color: #cccccc; text-decoration: none;">The
Indoor CO2 Map: Community Science in the Pandemicene</a>

</div>

### Some thanks

This work would not be possible without the hard work of all the
contributors to [OpenStreetMap](https://www.openstreetmap.org/) and
[indoorco2map](https://indoorco2map.com). If you would like to
contribute to either of these projects, please visit their websites. You
can contribute to the indoorco2map by downloading the [Android
app](https://play.google.com/store/apps/details?id=com.aurelwu.indoorairqualitycollector&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1)
or [iOS
app](https://apps.apple.com/us/app/indoorco2map-data-collector/id6504560820?itscg=30200&itsct=apps_box_badge&mttnsubad=6504560820)
and connecting it to any one of the following CO<sub>2</sub> sensors:
[Aranet4](https://www.aranet.com/en/home/products/aranet4-home),
[Airvalent](https://airvalent.com/),
[AirSpot](https://airspothealth.com/products/airspot-copy) and [Inkbird
IAM-T1](https://www.inkbird.com/products/smart-indoor-air-quality-monitor-iam-t1).
You can also donate by contributing to the [indoorCO2map
gofundme](https://www.gofundme.com/f/indoorco2mapcom-collectively-measuring-indoor-air-quality).  
I would also like to thank [Aurel Wünsch](https://github.com/AurelWu)
who tirelessly works on the project as well as the other contributors to
the project [ahunt](https://github.com/ahunt),
[da5nsy](https://github.com/da5nsy),
[paul-hammant](https://github.com/paul-hammant), and
[samherniman](https://github.com/samherniman).

Finally, many thanks go to the teams who work on the following software,
which I used heavily.

We used R v. 4.4.3<sup>13</sup> and the following R packages:
autocruller v. 0.0.0.9000<sup>14</sup>, dbscan v. 1.2.4<sup>15,16</sup>,
duckplyr v. 1.1.3.9007<sup>17</sup>, gganimate v. 1.0.11<sup>18</sup>,
ggrepel v. 0.9.6<sup>19</sup>, glue v. 1.8.0<sup>20</sup>, gt v.
1.2.0<sup>21</sup>, h3 v. 3.7.2<sup>22</sup>, here v.
1.0.2<sup>23</sup>, mapview v. 2.11.4<sup>24</sup>, osmdata v.
0.3.0<sup>25</sup>, pak v. 0.9.2<sup>26</sup>, patchwork v.
1.3.2<sup>27</sup>, rmarkdown v. 2.30<sup>28–30</sup>, rnaturalearth v.
1.2.0<sup>31</sup>, rnaturalearthhires v. 1.0.0.9000<sup>32</sup>,
scales v. 1.4.0<sup>33</sup>, scico v. 1.5.0<sup>34</sup>, sf v.
1.0.24<sup>35,36</sup>, tidygeocoder v. 1.0.6<sup>37</sup>, tidyplots v.
0.4.0<sup>38</sup>, tidyverse v. 2.0.0<sup>39</sup>.

All figures in this report are licensed under
<a href="https://creativecommons.org/licenses/by-sa/4.0/">CC BY-SA
4.0</a><img src="https://mirrors.creativecommons.org/presskit/icons/cc.svg" alt="" style="max-width: 1em;max-height:1em;margin-left: .2em;"><img src="https://mirrors.creativecommons.org/presskit/icons/by.svg" alt="" style="max-width: 1em;max-height:1em;margin-left: .2em;"><img src="https://mirrors.creativecommons.org/presskit/icons/sa.svg" alt="" style="max-width: 1em;max-height:1em;margin-left: .2em;">.
Please feel free to use and remix them and let me know if you do. I love
to see my work being used elsewhere!

<div id="refs" class="references csl-bib-body" entry-spacing="0"
line-spacing="2">

<div id="ref-guzman_air_2025" class="csl-entry">

<span class="csl-left-margin">1.
</span><span class="csl-right-inline">Guzman, R. D. & Schiller, J. [Air
pollution and its impact on cancer incidence, cancer care and cancer
outcomes](https://doi.org/10.1136/bmjonc-2024-000535). *bmjonc* **4**,
(2025).</span>

</div>

<div id="ref-fu_air_2020" class="csl-entry">

<span class="csl-left-margin">2.
</span><span class="csl-right-inline">Fu, P. & Yung, K. K. L. [Air
pollution and alzheimer’s disease: A systematic review and
meta-analysis](https://doi.org/10.3233/JAD-200483). *Journal of
Alzheimer’s Disease* **77**, 701–714 (2020).</span>

</div>

<div id="ref-shi_long-term_2020" class="csl-entry">

<span class="csl-left-margin">3.
</span><span class="csl-right-inline">Shi, L. *et al.* [Long-term
effects of PM2·5 on neurological disorders in the american medicare
population: A longitudinal cohort
study](https://doi.org/10.1016/S2542-5196(20)30227-8). *Lancet Planet
Health* **4**, e557–e565 (2020).</span>

</div>

<div id="ref-olloquequi_inhalation_2024" class="csl-entry">

<span class="csl-left-margin">4.
</span><span class="csl-right-inline">Olloquequi, J. *et al.* [From
inhalation to neurodegeneration: Air pollution as a modifiable risk
factor for alzheimer’s disease](https://doi.org/10.3390/ijms25136928).
*International Journal of Molecular Sciences* **25**, 6928
(2024).</span>

</div>

<div id="ref-akar-ghibril_indoor_2020" class="csl-entry">

<span class="csl-left-margin">5.
</span><span class="csl-right-inline">Akar-Ghibril, N. & Phipatanakul,
W. [The indoor environment and childhood
asthma](https://doi.org/10.1007/s11882-020-00941-5). *Curr Allergy
Asthma Rep* **20**, 43 (2020).</span>

</div>

<div id="ref-rosser_air_2022" class="csl-entry">

<span class="csl-left-margin">6.
</span><span class="csl-right-inline">Rosser, F. *et al.* [Air quality
index and emergency department visits and hospitalizations for childhood
asthma](https://doi.org/10.1513/AnnalsATS.202105-539OC). *Annals ATS*
**19**, 1139–1148 (2022).</span>

</div>

<div id="ref-pan_interactions_2020" class="csl-entry">

<span class="csl-left-margin">7.
</span><span class="csl-right-inline">Pan, R. *et al.* [Interactions
between climate factors and air quality index for improved childhood
asthma
self-management](https://doi.org/10.1016/j.scitotenv.2020.137804).
*Science of The Total Environment* **723**, 137804 (2020).</span>

</div>

<div id="ref-breysse_indoor_2010" class="csl-entry">

<span class="csl-left-margin">8.
</span><span class="csl-right-inline">Breysse, P. N. *et al.* [Indoor
air pollution and asthma in
children](https://doi.org/10.1513/pats.200908-083RM). *Proc Am Thorac
Soc* **7**, 102–106 (2010).</span>

</div>

<div id="ref-hulin_indoor_2010" class="csl-entry">

<span class="csl-left-margin">9.
</span><span class="csl-right-inline">Hulin, M., Caillaud, D. &
Annesi-Maesano, I. [Indoor air pollution and childhood asthma:
Variations between urban and rural
areas](https://doi.org/10.1111/j.1600-0668.2010.00673.x). *Indoor Air*
**20**, 502–514 (2010).</span>

</div>

<div id="ref-maung_indoor_2022" class="csl-entry">

<span class="csl-left-margin">10.
</span><span class="csl-right-inline">Maung, T. Z., Bishop, J. E., Holt,
E., Turner, A. M. & Pfrang, C. [Indoor air pollution and the health of
vulnerable groups: A systematic review focused on particulate matter
(PM), volatile organic compounds (VOCs) and their effects on children
and people with pre-existing lung
disease](https://doi.org/10.3390/ijerph19148752). *International Journal
of Environmental Research and Public Health* **19**, 8752 (2022).</span>

</div>

<div id="ref-kurmi_indoor_2012" class="csl-entry">

<span class="csl-left-margin">11.
</span><span class="csl-right-inline">Kurmi, O. P., Lam, K. B. H. &
Ayres, J. G. [Indoor air pollution and the lung in low- and
medium-income countries](https://doi.org/10.1183/09031936.00190211).
*European Respiratory Journal* **40**, 239–254 (2012).</span>

</div>

<div id="ref-uzoigwe_emerging_2013" class="csl-entry">

<span class="csl-left-margin">12.
</span><span class="csl-right-inline">Uzoigwe, J. C., Prum, T.,
Bresnahan, E. & Garelnabi, M. [The emerging role of outdoor and indoor
air pollution in cardiovascular
disease](https://doi.org/10.4103/1947-2714.117290). *N Am J Med Sci*
**5**, 445–453 (2013).</span>

</div>

<div id="ref-base" class="csl-entry">

<span class="csl-left-margin">13.
</span><span class="csl-right-inline">R Core Team. *[R: A Language and
Environment for Statistical Computing](https://www.R-project.org/)*. (R
Foundation for Statistical Computing, Vienna, Austria, 2025).</span>

</div>

<div id="ref-autocruller" class="csl-entry">

<span class="csl-left-margin">14.
</span><span class="csl-right-inline">Herniman, S.
*[<span class="nocase">autocruller</span>: Tools to Download and Analyze
indoorCO2map Data](https://samherniman.github.io/autocruller/)*.</span>

</div>

<div id="ref-dbscan2019" class="csl-entry">

<span class="csl-left-margin">15.
</span><span class="csl-right-inline">Hahsler, M., Piekenbrock, M. &
Doran, D. [<span class="nocase">dbscan</span>: Fast density-based
clustering with R](https://doi.org/10.18637/jss.v091.i01). *Journal of
Statistical Software* **91**, 1–30 (2019).</span>

</div>

<div id="ref-dbscan2025" class="csl-entry">

<span class="csl-left-margin">16.
</span><span class="csl-right-inline">Hahsler, M. & Piekenbrock, M.
*[<span class="nocase">dbscan</span>: Density-Based Spatial Clustering
of Applications with Noise (DBSCAN) and Related
Algorithms](https://CRAN.R-project.org/package=dbscan)*. (2025).</span>

</div>

<div id="ref-duckplyr" class="csl-entry">

<span class="csl-left-margin">17.
</span><span class="csl-right-inline">Mühleisen, H. & Müller, K.
*[<span class="nocase">duckplyr</span>: A ‘DuckDB’-Backed Version of
‘<span class="nocase">dplyr</span>’](https://github.com/tidyverse/duckplyr)*.</span>

</div>

<div id="ref-gganimate" class="csl-entry">

<span class="csl-left-margin">18.
</span><span class="csl-right-inline">Pedersen, T. L. & Robinson, D.
*[<span class="nocase">gganimate</span>: A Grammar of Animated
Graphics](https://CRAN.R-project.org/package=gganimate)*. (2025).</span>

</div>

<div id="ref-ggrepel" class="csl-entry">

<span class="csl-left-margin">19.
</span><span class="csl-right-inline">Slowikowski, K.
*[<span class="nocase">ggrepel</span>: Automatically Position
Non-Overlapping Text Labels with
‘<span class="nocase">ggplot2</span>’](https://CRAN.R-project.org/package=ggrepel)*.
(2024).</span>

</div>

<div id="ref-glue" class="csl-entry">

<span class="csl-left-margin">20.
</span><span class="csl-right-inline">Hester, J. & Bryan, J.
*[<span class="nocase">glue</span>: Interpreted String
Literals](https://CRAN.R-project.org/package=glue)*. (2024).</span>

</div>

<div id="ref-gt" class="csl-entry">

<span class="csl-left-margin">21.
</span><span class="csl-right-inline">Iannone, R. *et al.*
*[<span class="nocase">gt</span>: Easily Create Presentation-Ready
Display Tables](https://CRAN.R-project.org/package=gt)*. (2025).</span>

</div>

<div id="ref-h3" class="csl-entry">

<span class="csl-left-margin">22.
</span><span class="csl-right-inline">Kuethe, S. *[H3: R Bindings for
H3](https://github.com/crazycapivara/h3-r)*. (2022).</span>

</div>

<div id="ref-here" class="csl-entry">

<span class="csl-left-margin">23.
</span><span class="csl-right-inline">Müller, K.
*[<span class="nocase">here</span>: A Simpler Way to Find Your
Files](https://CRAN.R-project.org/package=here)*. (2025).</span>

</div>

<div id="ref-mapview" class="csl-entry">

<span class="csl-left-margin">24.
</span><span class="csl-right-inline">Appelhans, T., Detsch, F.,
Reudenbach, C. & Woellauer, S. *[<span class="nocase">mapview</span>:
Interactive Viewing of Spatial Data in
r](https://CRAN.R-project.org/package=mapview)*. (2025).</span>

</div>

<div id="ref-osmdata" class="csl-entry">

<span class="csl-left-margin">25.
</span><span class="csl-right-inline">Mark Padgham, Bob Rudis, Robin
Lovelace & Maëlle Salmon.
[Osmdata](https://doi.org/10.21105/joss.00305). *Journal of Open Source
Software* **2**, 305 (2017).</span>

</div>

<div id="ref-pak" class="csl-entry">

<span class="csl-left-margin">26.
</span><span class="csl-right-inline">Csárdi, G. & Hester, J.
*[<span class="nocase">pak</span>: Another Approach to Package
Installation](https://CRAN.R-project.org/package=pak)*. (2025).</span>

</div>

<div id="ref-patchwork" class="csl-entry">

<span class="csl-left-margin">27.
</span><span class="csl-right-inline">Pedersen, T. L.
*[<span class="nocase">patchwork</span>: The Composer of
Plots](https://CRAN.R-project.org/package=patchwork)*. (2025).</span>

</div>

<div id="ref-rmarkdown2018" class="csl-entry">

<span class="csl-left-margin">28.
</span><span class="csl-right-inline">Xie, Y., Allaire, J. J. &
Grolemund, G. *[R Markdown: The Definitive
Guide](https://bookdown.org/yihui/rmarkdown)*. (Chapman; Hall/CRC, Boca
Raton, Florida, 2018).</span>

</div>

<div id="ref-rmarkdown2020" class="csl-entry">

<span class="csl-left-margin">29.
</span><span class="csl-right-inline">Xie, Y., Dervieux, C. & Riederer,
E. *[R Markdown
Cookbook](https://bookdown.org/yihui/rmarkdown-cookbook)*. (Chapman;
Hall/CRC, Boca Raton, Florida, 2020).</span>

</div>

<div id="ref-rmarkdown2025" class="csl-entry">

<span class="csl-left-margin">30.
</span><span class="csl-right-inline">Allaire, J. *et al.*
*[<span class="nocase">rmarkdown</span>: Dynamic Documents for
r](https://github.com/rstudio/rmarkdown)*. (2025).</span>

</div>

<div id="ref-rnaturalearth" class="csl-entry">

<span class="csl-left-margin">31.
</span><span class="csl-right-inline">Massicotte, P. & South, A.
*[<span class="nocase">rnaturalearth</span>: World Map Data from Natural
Earth](https://CRAN.R-project.org/package=rnaturalearth)*.
(2026).</span>

</div>

<div id="ref-rnaturalearthhires" class="csl-entry">

<span class="csl-left-margin">32.
</span><span class="csl-right-inline">South, A., Michael, S. &
Massicotte, P. *[<span class="nocase">rnaturalearthhires</span>: High
Resolution World Vector Map Data from Natural Earth Used in
Rnaturalearth](https://github.com/ropensci/rnaturalearthhires)*.
(2025).</span>

</div>

<div id="ref-scales" class="csl-entry">

<span class="csl-left-margin">33.
</span><span class="csl-right-inline">Wickham, H., Pedersen, T. L. &
Seidel, D. *[<span class="nocase">scales</span>: Scale Functions for
Visualization](https://CRAN.R-project.org/package=scales)*.
(2025).</span>

</div>

<div id="ref-scico" class="csl-entry">

<span class="csl-left-margin">34.
</span><span class="csl-right-inline">Pedersen, T. L. & Crameri, F.
*[<span class="nocase">scico</span>: Colour Palettes Based on the
Scientific Colour-Maps](https://CRAN.R-project.org/package=scico)*.
(2023).</span>

</div>

<div id="ref-sf2018" class="csl-entry">

<span class="csl-left-margin">35.
</span><span class="csl-right-inline">Pebesma, E.
[<span class="nocase">Simple Features for R: Standardized Support for
Spatial Vector Data</span>](https://doi.org/10.32614/RJ-2018-009). *The
R Journal* **10**, 439–446 (2018).</span>

</div>

<div id="ref-sf2023" class="csl-entry">

<span class="csl-left-margin">36.
</span><span class="csl-right-inline">Pebesma, E. & Bivand, R.
*<span class="nocase">Spatial Data Science: With applications in
R</span>*. (Chapman and Hall/CRC, 2023).
doi:[10.1201/9780429459016](https://doi.org/10.1201/9780429459016).</span>

</div>

<div id="ref-tidygeocoder" class="csl-entry">

<span class="csl-left-margin">37.
</span><span class="csl-right-inline">Cambon, J., Hernangómez, D.,
Belanger, C. & Possenriede, D.
[<span class="nocase">tidygeocoder</span>: An r package for
geocoding](https://doi.org/10.21105/joss.03544). *Journal of Open Source
Software* **6**, 3544 (2021).</span>

</div>

<div id="ref-tidyplots" class="csl-entry">

<span class="csl-left-margin">38.
</span><span class="csl-right-inline">Engler, J. B. Tidyplots empowers
life scientists with easy code-based data visualization. *iMeta* e70018
(2025)
doi:[10.1002/imt2.70018](https://doi.org/10.1002/imt2.70018).</span>

</div>

<div id="ref-tidyverse" class="csl-entry">

<span class="csl-left-margin">39.
</span><span class="csl-right-inline">Wickham, H. *et al.* [Welcome to
the
<span class="nocase">tidyverse</span>](https://doi.org/10.21105/joss.01686).
*Journal of Open Source Software* **4**, 1686 (2019).</span>

</div>

</div>

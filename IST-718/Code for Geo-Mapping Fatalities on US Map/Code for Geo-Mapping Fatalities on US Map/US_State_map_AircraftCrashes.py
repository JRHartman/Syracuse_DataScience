"""
US States map based on geocodes, incorporating data visualization. EGF Final Project Spring 2019 IST718

This program was adapted from: http://shallowsky.com/blog/programming/plotting-election-data-basemap.html
And from https://github.com/matplotlib/basemap/blob/master/examples/fillstates.py


The program uses 3 shape files and a data file that must reside in the same directory: st99_d00.dbf, st99_d00.shp, st99_d00.shx, and MeanForecast.csv
The last file is the data file, a result of work using Jupiter Notebook.

The first part draws an empty map of the US states and boundaries.

"""
import sys
import os
import re
import pandas as pd
import pprint
import matplotlib
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.colors import LinearSegmentedColormap
from matplotlib.colors import rgb2hex, Normalize
from matplotlib.patches import Polygon
from matplotlib.colorbar import ColorbarBase

fig, ax = plt.subplots()

# Lambert Conformal map of lower 48 states.
m = Basemap(llcrnrlon=-119,llcrnrlat=20,urcrnrlon=-64,urcrnrlat=49,
            projection='lcc',lat_1=33,lat_2=45,lon_0=-95)

# Mercator projection, for Alaska and Hawaii
m_ = Basemap(llcrnrlon=-190,llcrnrlat=20,urcrnrlon=-143,urcrnrlat=46,
            projection='merc',lat_ts=20)  # do not change these numbers


## ---------   draw state boundaries  ----------------------------------------
## originally data obtained from U.S Census Bureau
## http://www.census.gov/geo/www/cob/st2000.html
shp_info = m.readshapefile('st99_d00','states',drawbounds=True,
                           linewidth=0.45,color='gray')
shp_info_ = m_.readshapefile('st99_d00','states',drawbounds=False)


## ---------   prepare data  ----------------------------------------
# download the data frame that contains state names and corresponding aircraft fatality counts by state
# find min. And max values to prorate the colors. 
# In a three step process, convert the data frame to a dictionary
 
StateFatal= pd.read_csv('StateFatal.csv')
countmin=StateFatal['Fatal_Counts'].min()
countmax=StateFatal['Fatal_Counts'].max()
fatal1=StateFatal['State'].tolist()
fatal2=StateFatal['Fatal_Counts'].tolist()
zipfatal = zip(fatal1, fatal2)
countFatal = dict(zipfatal)


## -------- choose a color for each state corresponding to fatalities value -------
colors={}
cmap = plt.cm.viridis_r    # use 'reversed viridis’ colormap


statenames=[]
vmin = countmin; vmax = countmax   # set range.
norm = Normalize(vmin=vmin, vmax=vmax)
for shapedict in m.states_info:
    statename = shapedict['NAME']
    if statename != 'Puerto Rico':
        CF = countFatal[statename]
        # calling colormap with value between 0 and 1 returns rgba value.  
        # Invert color range. hot colors are high. take sqrt root to spread out colors more.
        # matches the idea of scaling down a range of dollars to fit the range of colors.
        # a similar formula I came up with: f(x) = 256*(x-min)/range = colorfactor*(x-min) 
        # is also found at: 
        # stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value
        if statename == 'California':
            # subtract 1,000 in the calculation because California which is at the top gets a 1 and becomes completely black.
            colors[statename] = cmap(np.sqrt((CF-vmin-1000)/(vmax-vmin)))[:3]
        if statename != 'California':
            colors[statename] = cmap(np.sqrt((CF-vmin)/(vmax-vmin)))[:3]
    statenames.append(statename)


## ---------  cycle through state names, color each one  --------------------
for nshape,seg in enumerate(m.states):
    if statenames[nshape] not in ['Puerto Rico']:
        color = rgb2hex(colors[statenames[nshape]])
        poly = Polygon(seg,facecolor=color,edgecolor=color)
        ax.add_patch(poly)


## ---------  scale, move, and plot Hawaii and Alaska --------------------
AREA_1 = 0.005  # exclude small Hawaiian islands that are smaller than AREA_1
AREA_2 = AREA_1 * 30.0  # exclude Alaskan islands that are smaller than AREA_2
AK_SCALE = 0.19  # scale down Alaska to show as a map inset
HI_OFFSET_X = -1900000  # X coordinate offset amount to move Hawaii "beneath" Texas
HI_OFFSET_Y = 250000    # similar to above: Y offset for Hawaii
AK_OFFSET_X = -250000   # X offset for Alaska 
AK_OFFSET_Y = -750000   # Y offset for Alaska

for nshape, shapedict in enumerate(m_.states_info):  # plot Alaska and Hawaii as map insets
    if shapedict['NAME'] in ['Alaska', 'Hawaii']:
        seg = m_.states[int(shapedict['SHAPENUM'] - 1)]
        if shapedict['NAME'] == 'Hawaii' and float(shapedict['AREA']) > AREA_1:
            seg = [(x + HI_OFFSET_X, y + HI_OFFSET_Y) for x, y in seg]
            color = rgb2hex(colors[statenames[nshape]])
        elif shapedict['NAME'] == 'Alaska' and float(shapedict['AREA']) > AREA_2:
            seg = [(x*AK_SCALE + AK_OFFSET_X, y*AK_SCALE + AK_OFFSET_Y)\
                   for x, y in seg]
            color = rgb2hex(colors[statenames[nshape]])
        poly = Polygon(seg, facecolor=color, edgecolor='gray', linewidth=.45)
        ax.add_patch(poly)

ax.set_title('US Aviation Fatality Counts by State')


## ---------  Plot bounding boxes for Alaska and Hawaii insets  --------------
light_gray = [0.8]*3  # define light gray color RGB
x1,y1 = m_([-190,-183,-180,-180,-175,-171,-171],[29,29,26,26,26,22,20])
x2,y2 = m_([-180,-180,-177],[26,23,20])  # these numbers are fine-tuned manually
m_.plot(x1,y1,color=light_gray,linewidth=0.8)  # do not change them drastically
m_.plot(x2,y2,color=light_gray,linewidth=0.8)

## ---------   Show color bar  ---------------------------------------
ax_c = fig.add_axes([0.9, 0.1, 0.03, 0.8])
cb = ColorbarBase(ax_c,cmap=cmap,norm=norm,orientation='vertical')

plt.show()











 

















# -*- coding: utf-8 -*-
"""
Created on Thu Mar 24 11:05:19 2022

@author: Ed
"""
import csv 

# od attributes contains the daily trip count per day and cycle trips per day
with open('PCT/commute-lsoa-west-yorkshire-od_attributes (2).csv', newline='') as csvfile:
     reader = csv.reader(csvfile, delimiter=',')
     row1 = next(reader)
     print(row1)
#     for row in reader:
#         print(', '.join(row))
       
# z geojson defines the zone polygon  
import geojson
with open('PCT/commute-lsoa-west-yorkshire-z.geojson') as f:
    gj = geojson.load(f)
feature0 = gj['features'][0]

# generate random trips from origin zone to destination zone

import xml.etree.cElementTree as ET
root = ET.Element("root")
doc = ET.SubElement(root, "doc")

ET.SubElement(doc, "field1", name="departure_time").text = "10.2"
ET.SubElement(doc, "field1", name="departure_time").text = "21.3"

tree = ET.ElementTree(root)
tree.write("pct_bicycle.trips.xml")

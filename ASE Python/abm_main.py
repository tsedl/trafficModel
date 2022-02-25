from Utilities import SingleThreadPubSub, GraphAStar
##import json
##
##network_file_content = "'nodes':{ 'N1':[0.0, 0.0],
##                        'N2':[500.0, 0.0],
##                        'N3':[1000.0, 0.0]},
##                        'links':{
##                            'L1':{'start_id':'N1', 'end_id':'N2', 'waypoints':[[0.0, 0.0],
##                                                                           [250.0, 250.0],
##                                                                           [500.0, 0.0]]},
##                            'L2':{'start_id':'N1', 'end_id':'N2', 'waypoints':[[0.0, 0.0],
##                                                                           [250.0, -250.0],
##                                                                           [500.0, 0.0]]},
##                            'L3':{'start_id':'N2', 'end_id':'N3', 'waypoints':[[500.0, 0.0],
##                                                                           [750.0, 0.0],
##                                                                           [1000.0, 0.0]]},
##                                  
##                              }"
import yaml
import numpy
example_content = dct = yaml.safe_load('''
name: John
age: 30
automobiles:
- brand: Honda
  type: Odyssey
  year: 2018
- brand: Toyota
  type: Sienna
  year: 2015
''')

network_file_content = dct = yaml.safe_load('''
nodes:
- N1:[0.0, 0.0]
- N2:[500.0, 0.0]
- N3:[1000.0, 0.0]}
links:
- L1:
- - start_id:N1
- - end_id:N2
- - waypoints:[[0.0, 0.0],
               [250.0, 250.0],
               [500.0, 0.0]]
- L2:
- - start_id:N1
- - end_id:N2
- - waypoints:[[0.0, 0.0],
               [250.0, -250.0],
               [500.0, 0.0]]              
- L3:
- - start_id:N2
- - end_id:N3
- - waypoints:[[500.0, 0.0],
               [750.0, 0.0],
               [1000.0, 0.0]]
                                                              
                                          ''') 
print(network_file_content)

nodes = network_file_content['nodes']
links = network_file_content['links']
g = GraphAStar.Graph()
for node_str in nodes:
    str_list = node_str.split(':')
    node_id = str_list[0]
    pos_str = str_list[1]
    num_str_arr = pos_str.replace('[', '').replace(']', '').split(',')
    nnum_str_arr = numpy.array(num_str_arr)
    pos = nnum_str_arr.astype(float)
    g.AddNodeG(pos, [])
pass #endfor


    
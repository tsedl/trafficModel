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
network_file_content = dct = yaml.safe_load('''
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
print(network_file_content)

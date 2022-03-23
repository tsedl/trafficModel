# this file wil run sumo with the traci python interface and make one simulation step and recover the average speeds
# for it to work you need to install the sumo binaries from https://sumo.dlr.de/docs/Downloads.php
# the config file was generated using OSM Web wizard for Sumo, which is included in the installer
# following the instruction https://sumo.dlr.de/docs/TraCI/Interfacing_TraCI_from_Python.html
# to get summary statistics use --statistic-output <FILE>
import os
print(os.environ.get("SUMO_HOME"))

import traci



#sumoCmd = ["sumo-gui", "-c", "leeds-bradford-link.sumocfg"]
sumoCmd = ["sumo-gui", "-c", os.path.join("2022-03-10-11-17-40","osm.sumocfg")]
print(sumoCmd)
traci.start(sumoCmd)
step = 0
while step < 1000:
   traci.simulationStep()
   print('t',step)
   for veh_id in traci.vehicle.getIDList():
      position = traci.vehicle.getPosition(veh_id)
      print(veh_id, position)
   pass #endfor
#   if traci.inductionloop.getLastStepVehicleNumber("0") > 0:
#       traci.trafficlight.setRedYellowGreenState("0", "GrGr")
#   pass #endif
   step += 1
pass #endwhile
traci.close()
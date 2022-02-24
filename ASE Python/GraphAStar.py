#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 28 08:27:59 2019

@author: Ed
"""

'''
GraphAStar will operate on a Graph class which can represent a weighted, directed graph but extend to a undirected graph with uniform weighting
each node will have a uid and a position vector to be used to calculate the heuristic
'''

from heapq import *
import numpy

class Node:
    def __init__(self, uid, position, heading, groups):
        self.uid = uid
        self.position = position
        self.heading = heading
        self.groups = groups
        self.links = []
    def AddLink(self, uid):
        self.links.append(uid)
    def __str__(self):
        return 'Node at {} links {}'.format(self.position, self.links)
    def __repr__(self):
        return 'Node at {} links {}'.format(self.position, self.links)
        
class Graph:
    def __init__(self):
        self.node_dict = {}
    def _AddNode(self, uid, position, heading, groups):
        position = numpy.matrix(numpy.reshape(position, (2,1)))
        self.node_dict[uid] = Node(uid, position, heading, groups)
    def AddNodeG(self, position, groups):
        uid = len(self.node_dict)
        heading = 0;
        self._AddNode(uid, position, heading, groups)
    def AddNode(self, pose):
        groups = -1
        uid = self.CurrentUid()
        position = pose[0:2]
        heading = pose[2]
        self._AddNode(uid, position, heading, groups)
        return uid
    def CurrentUid(self):
        return len(self.node_dict)
    def Get(self, uid):
        return self.node_dict[uid]
    def AddLink(self, from_id, to_id):
        self.node_dict[from_id].AddLink(to_id)
    def AddLinkBi(self, from_id, to_id):
        self.node_dict[from_id].AddLink(to_id)
        self.node_dict[to_id].AddLink(from_id)
            
def heuristic(a, b):
    return (b[0] - a[0]) ** 2 + (b[1] - a[1]) ** 2

def FindPath(graph):
    start_id = 0
    goal_id = len(graph.node_dict)-1
    return FindPathBetween(graph, start_id, goal_id)
    
def FindPathBetween(graph, start_id, goal_id):
    close_set = set()
    came_from = {}
    gscore = {start_id:0}
    fscore = {start_id:heuristic(graph.Get(start_id).position, graph.Get(goal_id).position)}
    oheap = []
    
    heappush(oheap, (fscore[start_id], start_id))
    
    while oheap:
        #print('oh heap', fscore[start_id])
        current_id = heappop(oheap)[1] #why would I need element one? Because the heap is full of (score, id) tuples
        #print('current_id', current_id)
        if current_id == goal_id:
            reverse_list=[]
            while current_id in came_from:
                reverse_list.append(current_id)
                current_id = came_from[current_id]
            reverse_list.append(current_id)
            data = [ reverse_list[len(reverse_list)-1-i] for i in range(len(reverse_list)) ]
            return data

        close_set.add(current_id)
        #print('current', graph.Get(current_id))
        #print('current', graph.Get(current_id).position, graph.Get(current_id).links)
        for neighbour_id in graph.Get(current_id).links:
            tentative_g_score = gscore[current_id] + heuristic(graph.Get(current_id).position, graph.Get(neighbour_id).position)
            
            if neighbour_id in close_set and tentative_g_score >= gscore.get(neighbour_id, 0):
                #print('break out of for loop')
                continue
                
            if  tentative_g_score < gscore.get(neighbour_id, 0) or neighbour_id not in [i[1]for i in oheap]:
                #print('check neighbour ', neighbour_id, 'for tgscore ', tentative_g_score)
                came_from[neighbour_id] = current_id
                gscore[neighbour_id] = tentative_g_score
                fscore[neighbour_id] = tentative_g_score + heuristic(graph.Get(neighbour_id).position, graph.Get(goal_id).position)
                heappush(oheap, (fscore[neighbour_id], neighbour_id))
    print("no route found between",start_id,"and", goal_id)          
    return False
    

    

'''
----------------------------------------------------
 GraphAStar Tests
----------------------------------------------------
'''    
if __name__=="__main__":

    # some sort of graph example
    region_count = 3
    graph = Graph()
    graph.AddNodeG([0.0,0.0],[0])
    graph.AddNodeG([1.0,0.0],[0])
    graph.AddNodeG([1.0,1.0],[0,1])
    graph.AddNodeG([0.0,1.0],[0])
    graph.AddNodeG([0.5,0.5],[0,1])
    graph.AddNodeG([1.5,0.5],[1,2])
    graph.AddNodeG([1.5,1.5],[1,2])
    graph.AddNodeG([0.5,1.5],[1])
    graph.AddNodeG([1.1,0.0],[1,2])
    graph.AddNodeG([2.0,0.0],[2])
    graph.AddNodeG([2.0,1.0],[1,2])
    graph.AddNodeG([1.1,1.0],[1,2])
    graph.AddNodeG([1.8,0.8], [2])
    
    # add all the links
    for idi in graph.node_dict:
        for idj in graph.node_dict:
            if idi != idj:
                if any(group in graph.Get(idi).groups for group in graph.Get(idj).groups):
                    graph.AddLink(idi, idj)
    # now calculate the initial feasible solution parameters from a list of nodes
    # generate a path segment to region matrix H from a list of ids
    nodes = FindPath(graph)
    waypoints = [graph.Get(node).position for node in nodes]
    membership = [graph.Get(node).groups for node in nodes]
    print('membership' , membership, 'len', len(membership))
    H = numpy.zeros((len(membership)-1, region_count)) 

    segments = []
    for i in range(len(membership)-1):
        for region_i in membership[i]:
            for region_i1 in membership[i+1]:
                if region_i == region_i1:
                    H[i,region_i] = 1
        params = waypoints[i+1] - waypoints[i]
        origin = waypoints[i]
        #segments.append(Path2P.Segment(params, origin))

#    print('segments', segments)
    print('H', H)
    
    assert(H[0,0]==1) # The start node is in region 0, the path must start here
    assert(H[1,1]==1) # The only way between region 0 and two in the example above is through region 1
    assert(H[2,2]==1) # The goal node is in region 2, the path must end here
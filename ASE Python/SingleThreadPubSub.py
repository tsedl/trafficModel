##!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
Created on Fri Feb 14 10:52:18 2020
SingleThreadPubSub offers a dispatcher for any type of message, identified by 
topic string. All classes must be passed a reference to a single Dispatcher 
object, which offers both Publish() and Subscribe() methods.
Messages published to a topic are stored in a queue and routed in order 
to every subscriber when Dispatch(timeout) is called. This function will block 
until the specified timeout even if the queue becomes empty. The overall effect 
is that classes and messaging interaces can be decoupled based on the publish-
subscribe pattern, while reduciung the burden of complexity of threading 
and serialization. I'm hoping it will be useful for prototyping a pub/sub design    
@author: Ed
"""
import queue
import time

class Message:
    def __init__(self, message_topic, item):
        self.topic = message_topic
        self.item = item 
        
class Dispatcher:
    def __init__(self):
        self.message_queue = queue.Queue(maxsize = 0)
        self.subscription_dict = {}
        
    def Subscribe(self, message_topic, callback):
        if message_topic in self.subscription_dict:
            self.subscription_dict[message_topic].append(callback)
        else:
            self.subscription_dict[message_topic] = [callback]
            
    def Publish(self, message_topic, item):
        self.message_queue.put_nowait(Message(message_topic, item));
        
    def Dispatch(self, timeout):
        #This will run until end_time even if the queue gets empty
        end_time = time.time() + timeout
        while time.time() < end_time:
            try:            
                message = self.message_queue.get_nowait() # I think this removes the item from the queue like pop()
                for callback in self.subscription_dict[message.topic]:
                    callback(message)
            except queue.Empty:
                return None
        
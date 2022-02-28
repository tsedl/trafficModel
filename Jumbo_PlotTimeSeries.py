# -*- coding: utf-8 -*-
"""
Created on Mon Feb 28 09:11:44 2022
Jumbo Visma objkective function - plot a time series of speed or energy use
@author: Ed
"""
import math
import numpy
import matplotlib.pyplot as plt

def state_space_model(t_k, s_k, U_k, W_k, P_vector, cyclist_params, track_params, wind_vector_list):

    m_e = cyclist_params['m(kg)'] + 10 #add a few kgs for the bicycle
    # track params
    g = 9.81 #m/s/s
    #wind vector
    V = [0.5, 0.0]
    C_DA = 0.473
    p = 1.225 

    CRR = 0.0032# is this a preoperty of the bike or the track?
    # cyclist heading (for the wind)
    yaw_vec = track_params['yaw_vec']
    s_index = int(s_k)
    yaw_k = yaw_vec[s_index]
    V_k = numpy.dot(V, [math.sin(yaw_k), math.cos(yaw_k)])
    # elevation along the track 
    theta_vec = track_params['theta_vec']
    theta_k = theta_vec[s_index]
    #cyclist pedal intensity
    P_k = P_vector[s_index]
    
    s_dot = U_k
    U_dot = (1/m_e)*( (P_k/U_k) - m_e*g*(math.sin(theta_k) 
                                       + CRR*math.cos(theta_k))
                     - 0.5*C_DA*p*(U_k - V_k))
    a = cyclist_params['a']
    b = cyclist_params['b(W)']
    CP = cyclist_params['CP(W)']
    phi = a*(P_k/CP) + b
    W_dot  = -(CP*((P_k/CP)-1)*phi)
               
    return s_dot, U_dot, W_dot

if __name__ == '__main__':
    cyclist_params = {'name':'subject 6',
                        'm(kg)':79,
                        'CP(W)':269,
                        'AWC(J)':12030,
                        'a':0.11,
                        'b(W)':237.5,
                        'alpha_w(rpm/J)':0.017,
                        'omega_max(rpm)':139}
    # loop track with sin2 hills and perfectly circular direction
    L=3600 #m
    theta_max = 50 #metres
    theta_vec = numpy.zeros(L)
    yaw_vec = numpy.zeros(L)
    for s in range(0,L):
        theta_vec[s] = theta_max*math.sin(s*2*math.pi/L)**2
        yaw_vec[s] = math.sin(s*2*math.pi/L)
    pass #endfor
    
    track_params = {'L':L,
                    'theta_max':theta_max,
                    'theta_vec': theta_vec,
                    'yaw_vec':yaw_vec}
    T_forecast = 22 #seconds
    wind_vector_list = []
    westerly = [0.5, 0.0]
    northerly = [0.5, 1.0]
    T_wind_picks_up = 60#seconds
    for t in range(T_forecast):
        if t > T_wind_picks_up:
            wind_vector_list.append(northerly)
        else:
            wind_vector_list.append(westerly)
        pass #endif
    pass #endfor
    #intial values 
    s_k = 0.0
    U_k = 2.0 #m/s start nonzero to avoid singularity
    W_k = cyclist_params['AWC(J)']

    dT = 1 #second
    n_iters = int(numpy.ceil(T_forecast/dT))
    
    #power input parameter vector - say they alwasyy give 50% powre
    P_vector = 0.5*cyclist_params['CP(W)']*numpy.ones(L)
    
    #result collection vectors
    t_vector = numpy.zeros(n_iters)
    s_vector = numpy.zeros(n_iters)
    U_vector = numpy.zeros(n_iters)
    W_vector = numpy.zeros(n_iters)
    for i in range(n_iters):
        t_k = i*dT
        s_dot, U_dot, W_dot = state_space_model(t_k, s_k, U_k, W_k, P_vector, cyclist_params, track_params, wind_vector_list)
        # rectangle approx integration
        s_k = s_k + dT*s_dot
        U_k = U_k + dT*U_dot
        W_k = W_k + dT*W_dot
        
        #'store for plotting'
        t_vector[i] = t_k
        s_vector[i] = s_k
        U_vector[i] = U_k
        W_vector[i] = W_k
    pass #endfor
    
    plt.scatter(t_vector, s_vector)
    plt.xlabel('t [s]')
    plt.ylabel('s [m]')
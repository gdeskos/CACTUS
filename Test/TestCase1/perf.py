#! /usr/bin/python3

# This script runs a number of simulation for a given tip-speed-ratio start and end point

import os
import shutil
import sys
import string
import filecmp
import difflib
import subprocess
import math
import re
import argparse
import csv
from numpy import genfromtxt
import matplotlib.pyplot as plt
from math import sqrt

# Executable Direction
CACTUSExe='/home/gdeskos/bin/cactus'
# ====================================
# Parser Arguments
# ====================================
parser = argparse.ArgumentParser(description="Calculate the performance of a Turbine for different Tip Speed Ratios")
group = parser.add_mutually_exclusive_group()
group.add_argument("-v","--verbose",action="store_true",help="Prints a script description on the screen")
group.add_argument("-p","--plot",action="store_true",help="Plots the Cp versus the TSR")
parser.add_argument("IFN", type=str, help="The input filename")
parser.add_argument("TSR_START",type=float,help="The first Tip Speed Ratio Number")
parser.add_argument("TSR_END",type=float,help="The last Tip Speed Ratio Number")
parser.add_argument("dTSR",type=float,help="Interval for advancing the Tip Speed Ratio Number")
args = parser.parse_args()
input_file = args.IFN
TSR_start = args.TSR_START
TSR_end = args.TSR_END
dTSR = args.dTSR

if args.verbose:
    print('Runing perf.py with for IFN = ' + input_file + ', for Tip-Speed-Ratios from ' + str(TSR_start) + ' to ' + str(TSR_end))

print('########################')
print('Running perf.py')
print('First Tip Speed Ratio: ',TSR_start)
print('Last Tip Speed Ratio: ', TSR_end)
Nsteps=round((TSR_end-TSR_start)/dTSR)
print('#######################')


tsr=[];
Power_coeff=[];
Fx_coeff=[];
Fy_coeff=[];
Fz_coeff=[];
Thrust_coeff=[];
Uinf=1.5;
R=0.4;
print('Start the simulation')
for n in range(0, Nsteps):
    Ut=TSR_start+dTSR*n
    #RPM=Ut*Uinf*60/(R*2*math.pi)
    with open(input_file) as f:
        content=f.read()
        newcont=re.sub('(\s*Ut.*=.*) [0-9]+', r'\1 '+str(Ut),content)
        #newcont=re.sub('(\s*RPM.*=.*) [0-9]+', r'\1 '+str(RPM),content)
    with open('tmp.in',"w") as ftmp:
        ftmp.write(newcont)
    # RUN CACTUS
    subprocess.call([CACTUSExe,'tmp.in'])
    # READ FILES
    Revfile= 'tmp_RevData.csv'
    my_data = genfromtxt(Revfile,delimiter=',',skip_header=1)

    tsr.append(Ut)
    Power_coeff.append(my_data[-1,1])
    Fx_coeff.append(my_data[-1,4])
    Fy_coeff.append(my_data[-1,5])
    Fz_coeff.append(my_data[-1,6])

    #Compute Thrust
    thrust_num=sqrt(pow(my_data[-1,4],2)+pow(my_data[-1,5],2)+pow(my_data[-1,6],2))
    Thrust_coeff.append(thrust_num)
if args.plot:

    plt.figure(figsize=(5, 5))
    plt.title('Power Coefficient Cp')
    plt.grid(True)
    plt.plot(tsr,Power_coeff,color="blue")
    plt.ylim(0,0.6)
    plt.xlim(0,10)

    plt.figure(figsize=(5, 5))
    plt.title('Thrust Coefficient Ct')
    plt.grid(True)
    plt.plot(tsr,Thrust_coeff,color="blue")
    plt.ylim(0,0.6)
    plt.xlim(0,10)


    plt.show()



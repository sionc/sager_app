#!/usr/bin/env python
import serial, time
from xbee import xbee
# for graphing stuff
import wx
import numpy as np
import matplotlib
matplotlib.use('WXAgg') # do this before importing pylab
from pylab import *
import pycurl


SERIALPORT = "/dev/ttyUSB0"    # the com/serial port the XBee is connected to
BAUDRATE = 9600      # the baud rate we talk to the xbee
CURRENTSENSE = 4       # which XBee ADC has current draw data
VOLTSENSE = 0          # which XBee ADC has mains voltage data
MAINSVPP = 170 * 2     # +-170V is what 120Vrms ends up being (= 120*2sqrt(2))
VREF = 492          # approx ((2.4v * (10Ko/14.7Ko)) / 3
CURRENTNORM = 15.5  # conversion to amperes from ADC
NUMWATTDATASAMPLES = 1800 # how many samples to watch in the plot window, 1 hr @ 2s samples

# open up the FTDI serial port to get data transmitted to xbee
ser = serial.Serial(SERIALPORT, BAUDRATE)
ser.open()

# Create an animated graph
fig = plt.figure()
# with three subplots: line voltage/current, watts and watthr
wattusage = fig.add_subplot(211)
mainswatch = fig.add_subplot(212)

# data that we keep track of, the average watt usage as sent in
avgwattdata = [0] * NUMWATTDATASAMPLES # zero out all the data to start
avgwattdataidx = 0 # which point in the array we're entering new data

# The watt subplot
watt_t = np.arange(0, len(avgwattdata), 1)
wattusageline, = wattusage.plot(watt_t, avgwattdata)
wattusage.set_ylabel('Watts')
wattusage.set_ylim(0, 500)
    
# the mains voltage and current level subplot
mains_t = np.arange(0, 18, 1)
voltagewatchline, = mainswatch.plot(mains_t, [0] * 18, color='blue')
mainswatch.set_ylabel('Volts')
mainswatch.set_xlabel('Sample #')
mainswatch.set_ylim(-200, 200)
# make a second axies for amp data
mainsampwatcher = mainswatch.twinx()
ampwatchline, = mainsampwatcher.plot(mains_t, [0] * 18, color='green')
mainsampwatcher.set_ylabel('Amps')
mainsampwatcher.set_ylim(-15, 15)

# and a legend for both of them
legend((voltagewatchline, ampwatchline), ('volts', 'amps'))


fiveminutetimer = lasttime = time.time()  # get the current time
cumulativewatthr = 0

def update_graph(idleevent):
    global avgwattdataidx, lasttime, cumulativewatthr, fiveminutetimer
     
    # grab one packet from the xbee, or timeout
    packet = xbee.find_packet(ser)
    if packet:
        xb = xbee(packet)

        #print xb
        # we'll only store n-1 samples since the first one is usually messed up
        voltagedata = [-1] * (len(xb.analog_samples) - 1)
        ampdata = [-1] * (len(xb.analog_samples ) -1)
        # grab 1 thru n of the ADC readings, referencing the ADC constants
        # and store them in nice little arrays
        for i in range(len(voltagedata)):
            voltagedata[i] = xb.analog_samples[i+1][VOLTSENSE]
            ampdata[i] = xb.analog_samples[i+1][CURRENTSENSE] 
            
        # get max and min voltage and normalize the curve to '0'
        # to make the graph 'AC coupled' / signed
        min_v = 1024     # XBee ADC is 10 bits, so max value is 1023
        max_v = 0
        for i in range(len(voltagedata)):
            if (min_v > voltagedata[i]):
                min_v = voltagedata[i]
            if (max_v < voltagedata[i]):
                max_v = voltagedata[i]

        # figure out the 'average' of the max and min readings
        avgv = (max_v + min_v) / 2
        # also calculate the peak to peak measurements
        vpp =  max_v-min_v

        for i in range(len(voltagedata)):
            #remove 'dc bias', which we call the average read
            voltagedata[i] -= avgv
            # We know that the mains voltage is 120Vrms = +-170Vpp
            voltagedata[i] = (voltagedata[i] * MAINSVPP) / vpp

        # normalize current readings to amperes
        for i in range(len(ampdata)):
            # VREF is the hardcoded 'DC bias' value, its
            # about 492 but would be nice if we could somehow
            # get this data once in a while maybe using xbeeAPI
            ampdata[i] -= VREF
            # the CURRENTNORM is our normalizing constant
            # that converts the ADC reading to Amperes
            ampdata[i] /= CURRENTNORM

        #print "Voltage, in volts: ", voltagedata
        #print "Current, in amps:  ", ampdata

        # calculate instant. watts, by multiplying V*I for each sample point
        wattdata = [0] * len(voltagedata)
        for i in range(len(wattdata)):
            wattdata[i] = voltagedata[i] * ampdata[i]

        # sum up the current drawn over one 1/60hz cycle
        avgamp = 0
        # 16.6 samples per second, one cycle = ~17 samples
        # close enough for govt work :(
        for i in range(17):
            avgamp += abs(ampdata[i])
        avgamp /= 17.0

        # sum up power drawn over one 1/60hz cycle
        avgwatt = 0
        # 16.6 samples per second, one cycle = ~17 samples
        for i in range(17):         
            avgwatt += abs(wattdata[i])
        avgwatt /= 17.0


        # Print out our most recent measurements
        print "\tCurrent draw, in amperes: "+str(avgamp)
        print "\tWatt draw, in VA: "+str(avgwatt)

        # Add the current watt usage to our graph history
        avgwattdata[avgwattdataidx] = avgwatt
        avgwattdataidx += 1
        if (avgwattdataidx >= len(avgwattdata)):
            # If we're running out of space, shift the first 10% out
            tenpercent = int(len(avgwattdata)*0.1)
            for i in range(len(avgwattdata) - tenpercent):
                avgwattdata[i] = avgwattdata[i+tenpercent]
            for i in range(len(avgwattdata) - tenpercent, len(avgwattdata)):
                avgwattdata[i] = 0
            avgwattdataidx = len(avgwattdata) - tenpercent

        # add up the delta-watthr used since last reading
        # Figure out how many watt hours were used since last reading
        elapsedseconds = time.time() - lasttime
        dwatthr = (avgwatt * elapsedseconds) / (60.0 * 60.0)  # 60 seconds in 60 minutes = 1 hr
        lasttime = time.time()
        print "\t\tWh used in last ",elapsedseconds," seconds: ",dwatthr
        cumulativewatthr += dwatthr
	
	print time.strftime("%Y %m %d, %H:%M"),", ",dwatthr, cumulativewatthr

        # Determine the minute of the hour (ie 6:42 -> '42')
        currminute = (int(time.time())/60) % 10
        # Figure out if its been five minutes since our last save
        if (((time.time() - fiveminutetimer) >= 60.0) and (currminute % 1 == 0)):
            # Print out debug data, Wh used in last 1 minutes
            avgwattsused = cumulativewatthr * (60.0*60.0 / (time.time() - fiveminutetimer))
            print time.strftime("%Y %m %d, %H:%M"),", ",cumulativewatthr,"Wh = ",avgwattsused," W average"


            c = pycurl.Curl()
            c.setopt(c.URL, 'http://gentle-window-1593.herokuapp.com/sensor_readings')
            #c.setopt(pycurl.VERBOSE, 1)
            c.setopt(c.POSTFIELDS, "sensor_reading[watthours]="+str(avgwattsused)+"&sensor_reading[local_id]=1&sensor_reading[mac_address]=00:0C:29:60:65:18")
            c.setopt(c.HTTPHEADER, ['Accept: application/json'])
            c.perform()
            c.close()
           
 
            # Reset our 5 minute timer
            fiveminutetimer = time.time()
            cumulativewatthr = 0
            
        # Redraw our pretty picture
        fig.canvas.draw_idle()
        # Update with latest data
        wattusageline.set_ydata(avgwattdata)
        voltagewatchline.set_ydata(voltagedata)
        ampwatchline.set_ydata(ampdata)
        # Update our graphing range so that we always see all the data
        maxamp = max(ampdata)
        minamp = min(ampdata)
        maxamp = max(maxamp, -minamp)
        mainsampwatcher.set_ylim(maxamp * -1.2, maxamp * 1.2)
        wattusage.set_ylim(0, max(avgwattdata) * 1.2)
        
timer = wx.Timer(wx.GetApp(), -1)
timer.Start(100)        # run an in every 'n' milli-seconds
wx.GetApp().Bind(wx.EVT_TIMER, update_graph)
plt.show()

# -*- coding: utf-8 -*-
"""
Created on Sat May 11 11:48:40 2013

@author: tom
"""
import serial
import numpy as np


class MeasurementBoardBaseSerial(object):
    __mSerialPort = None

    def __init__(self, port):
        self.__mSerialPort = serial.Serial(
            port=port,
            baudrate=115200,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            timeout=60,
            xonxoff=False,
            rtscts=False,
            dsrdtr=False,
            writeTimeout=None,
            interCharTimeout=None)
    
    def __del__(self):
        if self.__mSerialPort is not None:
            self.__mSerialPort.close()
        self.__mSerialPort = None

    def read_address(self, address):
        cmd = b'\xA0'
        for i in range(4):
            cmd += bytes([(address >> (8 * i)) & 0xFF])

        self.__mSerialPort.write(cmd)
        result = self.__mSerialPort.read()
        if len(result) != 1:
            raise Exception('Could not read from serial port!')
        if ord(result) != 0x00:
            raise Exception('Illeagel response from serial port: %i!' %
                            ord(result))

        value_string = self.__mSerialPort.read(4)
        if len(value_string) != 4:
            raise Exception('Could not read from serial port!')

        value = np.uint32(0)
        for i in range(4):
            value += np.uint32(value_string[i]) << (8 * i)

        #if address != 0xc:
        #    print('Address: %x: %d (%s)' % (address, value, value_string))
        return np.uint32(value)

    def write_address(self, address, value):
        cmd = b'\xB0'
        for i in range(4):
            cmd += bytes([(address >> (8 * i)) & 0xFF])
        for i in range(4):
            cmd += bytes([(value >> (8 * i)) & 0xFF])

        self.__mSerialPort.write(cmd)
        result = self.__mSerialPort.read()
        if len(result) != 1:
            raise Exception('Could not read from serial port!')
        if ord(result) != 0x00:
            raise Exception('Illeagel response from serial port: %i!' %
                            ord(result))

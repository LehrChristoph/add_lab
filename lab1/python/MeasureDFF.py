# -*- coding: utf-8 -*-

import time
import sys
import numpy as np

import MeasurementInfrastructure.LTD_DFF_MTBF_SerialModule

def worker(result_queue):
    port = '/dev/ttyUSB0'
          
    max_data_points = 100   
    cnt_target = 200
    max_duration_step_seconds = 2 * 3600

    min_phase_shift = -3
    max_phase_shift = 20

    current_data_point = 0
    start_time = time.strftime("%Y%m%d%H%M%S", time.localtime())

    measurement_board = MeasurementInfrastructure.LTD_DFF_MTBF_SerialModule.LTD_DFF_MTBF_Serial(port)

    board_name = measurement_board.get_board_name()
    hardware_version = measurement_board.get_hardware_version()

    if board_name == 'de2_115':
      clock_pulse_length_offset = 0
      initial_steps_detector = 5    
    elif board_name == 'v4fx12lc':
      clock_pulse_length_offset = 100
      initial_steps_detector = 10
    elif board_name == 'kc705':
      clock_pulse_length_offset = 0
      initial_steps_detector = 15
    elif board_name == 'kc705v2':
      clock_pulse_length_offset = 0
      initial_steps_detector = 15
    else:
      raise Exception('Unknown board: ' + board_name + "!")

    print("Calibrate clock pulse length")
    measurement_board.calibrate_clock_pulse_length_value()
    measurement_board.set_clock_pulse_length_value(measurement_board.get_pulse_length_calibration_value())

    print("Selecting duty cycle")
    measurement_board.set_clock_pulse_length_value(measurement_board.get_pulse_length_calibration_value() +
                                                   clock_pulse_length_offset)

    print("Calibrating detector")
    measurement_board.calibrate()
    
    print("Setting initial alignment for the detector")
    #measurement_board.set_phase_shift_value_det(measurement_board.get_phase_shift_calibration_value_det() -
    #                                            initial_steps_detector)
    
    measurement_board.set_phase_shift_value_det(min_phase_shift)
    

    print('Starting Measurement')
    print('')

    results = [None]
    results[0] = \
      { 'name' : '',
        'settings': {
                  'board': board_name,
                  'hardware_version': hardware_version,
                  'controller_freq': measurement_board.get_contr_freq(),
                  'uut_freq': measurement_board.get_uut_freq(),
                  'clock_pulse_length_offset': clock_pulse_length_offset,
                  'initial_steps_detector': initial_steps_detector,
                  'max_data_points': max_data_points,
                  'cnt_target': cnt_target,
                  'start_time': start_time,
                  'step_size_n': measurement_board.get_step_size_n(),
                  'step_size_d': measurement_board.get_step_size_d_int64(),
                  'max_duration_step_seconds': max_duration_step_seconds
        },
        'data' : {
               'times': [],
               'ps_values': np.zeros([max_data_points], np.dtype('u4')),
               'cnt_values': np.zeros([max_data_points], np.dtype('u8')),
               'cnt_values_0to0': np.zeros([max_data_points], np.dtype('u8')),
               'cnt_values_0to1': np.zeros([max_data_points], np.dtype('u8')),
               'cnt_values_1to0': np.zeros([max_data_points], np.dtype('u8')),
               'cnt_values_1to1': np.zeros([max_data_points], np.dtype('u8')),
               'overflowed': np.zeros([max_data_points]),
               'overflowed_0to0': np.zeros([max_data_points]),
               'overflowed_0to1': np.zeros([max_data_points]),
               'overflowed_1to0': np.zeros([max_data_points]),
               'overflowed_1to1': np.zeros([max_data_points]),
               'upset_times' : [],
               'upset_times_0to0' : [],
               'upset_times_0to1' : [],
               'upset_times_1to0' : [],
               'upset_times_1to1' : [],
               }
          };
    
    continue_measurement = True
    ps = measurement_board.get_phase_shift_value_det()
    while continue_measurement and ps <= max_phase_shift:
        cnts = [0, 0, 0, 0, 0]
        data = [[],[],[],[],[]]

        measurement_board.reset_target_set(1)
        measurement_board.unfreeze_counter()
        measurement_board.reset_target_release()
        
        current = np.array([np.inf, np.inf, np.inf, np.inf, np.inf])

        min_cnt = 0
        ps = measurement_board.get_phase_shift_value_det()
        while (cnts[0] + cnts[2] < cnt_target or cnts[1] + cnts[3] < cnt_target) and min_cnt < results[0]['settings']['uut_freq'] * max_duration_step_seconds:
          data_mask = measurement_board.get_mtbf_stack_empty()
          if data_mask != 31:
            for i in reversed(range(5)):
              while data_mask & (1 << i) == 0 and current[i] == np.inf:
                  temp = measurement_board.get_mtbf_stack_int64(i)                 
                  if temp > 0:
                    current[i] = temp
            min_cnt = current.min()
            candidates = np.where(current == min_cnt)[0]
            for c in candidates:
              cnts[c] += 1
              data[c] += [current[c]]
              current[c] = np.inf
            print('%d;ps=%d;%s;%s' % (current_data_point, ps, time.strftime("%Y%m%d%H%M%S", time.localtime()),repr(cnts)), end='')
            for c in candidates:
                print(';%d;%d' % (c, data[c][-1]), end='')
            print('')
        overflowed = measurement_board.get_mtbf_stack_overflowed()
        measurement_board.freeze_counter()
        
        results[0]['data']['times'] += [time.strftime("%Y%m%d%H%M%S", time.localtime())]
        results[0]['data']['ps_values'][current_data_point] = measurement_board.get_phase_shift_value_det()
        results[0]['data']['cnt_values'][current_data_point] = cnts[4]
        results[0]['data']['cnt_values_0to0'][current_data_point] = cnts[1]
        results[0]['data']['cnt_values_0to1'][current_data_point] = cnts[3]
        results[0]['data']['cnt_values_1to0'][current_data_point] = cnts[2]
        results[0]['data']['cnt_values_1to1'][current_data_point] = cnts[0]
        results[0]['data']['overflowed'][current_data_point] = (overflowed >> 4) & 0x1
        results[0]['data']['overflowed_0to0'][current_data_point] = (overflowed >> 1) & 0x1
        results[0]['data']['overflowed_0to1'][current_data_point] = (overflowed >> 3) & 0x1
        results[0]['data']['overflowed_1to0'][current_data_point] = (overflowed >> 2) & 0x1
        results[0]['data']['overflowed_1to1'][current_data_point] = (overflowed >> 0) & 0x1
        results[0]['data']['upset_times'] += [np.array(data[4], np.dtype('u8'))]
        results[0]['data']['upset_times_0to0'] += [np.array(data[1], np.dtype('u8'))]
        results[0]['data']['upset_times_0to1'] += [np.array(data[3], np.dtype('u8'))]
        results[0]['data']['upset_times_1to0'] += [np.array(data[2], np.dtype('u8'))]
        results[0]['data']['upset_times_1to1'] += [np.array(data[0], np.dtype('u8'))]

        with open(board_name + '_' + start_time + '_' + hardware_version + '.np', "wb") as f:
            data = {'state': {
                           'current_data_point': current_data_point,
                           'save_time': time.strftime("%Y%m%d%H%M%S", time.localtime())
                           },
                    'results': results}
            np.save(f, [data])
         
        if result_queue is not None:
          result_queue.put(results)
          
        measurement_board.increment_phase_shift_det()
        current_data_point += 1

if __name__ == '__main__':
    worker(None)

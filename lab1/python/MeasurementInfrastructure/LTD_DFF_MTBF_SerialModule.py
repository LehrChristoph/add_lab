import time
import numpy as np
import MeasurementInfrastructure.LTD_DFF_MTBF_SerialBaseModule


class LTD_DFF_MTBF_Serial(MeasurementInfrastructure.LTD_DFF_MTBF_SerialBaseModule.LTD_DFF_MTBF_SerialBaseModule):
    CALIBRATION_RESET_DURATION = 0.1
    CHECK_HEART_BEAT_DURATION = 0.1
    CALIBRATION_TIMEOUT = 1
    
    #PS_VALUE_MIN = -47
    #PS_VALUE_MAX = 47    
    #CONTROL_CLK_FREQ = 50 * 1000 * 1000
    #CLK_FREQ = 200 * 1000 * 1000    
    #CLOCK_PULSE_LENGTH_VALUE_MIN = -5
    
    # PS_VALUE_MIN = -153
    # PS_VALUE_MAX = 153
    # CONTROL_CLK_FREQ = 100 * 1000 * 1000
    # CLK_FREQ = 200 * 1000 * 1000    
    # CLOCK_PULSE_LENGTH_VALUE_MIN = -153
    
    # PS_VALUE_MIN = -255
    # PS_VALUE_MAX = 255
    # CONTROL_CLK_FREQ = 100 * 1000 * 1000
    # CLK_FREQ = 200 * 1000 * 1000    
    # CLOCK_PULSE_LENGTH_VALUE_MIN = 1

    def __init__(self, port):
        super(MeasurementInfrastructure.LTD_DFF_MTBF_SerialBaseModule.LTD_DFF_MTBF_SerialBaseModule, self).__init__(port)
        self.m_calibration_value = 0
        self.m_clock_pulse_length_calibration_value = 0

    def __del__(self):
        super(MeasurementInfrastructure.LTD_DFF_MTBF_SerialBaseModule.LTD_DFF_MTBF_SerialBaseModule, self).__del__()
        
    def get_phase_shift_value_det(self):
        return self.get_ps_value_det()
        
    def get_phase_shift_calibration_value_det(self):
        return self.m_calibration_value
        
    def set_phase_shift_value_det(self, value):
        current = self.get_phase_shift_value_det()
        while current < value:
            self.increment_phase_shift_det()
            current = self.get_phase_shift_value_det()
        while current > value:
            self.decrement_phase_shift_det()
            current = self.get_phase_shift_value_det()
        
    def increment_phase_shift_det(self):
        self.set_ps_inc_det(1)
        while self.get_ps_in_progress_det() == 0:
            pass
        self.set_ps_inc_det(0)
        while self.get_ps_in_progress_det() == 1:
            pass
            
    def decrement_phase_shift_det(self):
        self.set_ps_dec_det(1)
        while self.get_ps_in_progress_det() == 0:
            pass
        self.set_ps_dec_det(0)
        while self.get_ps_in_progress_det() == 1:
            pass
        
    def freeze_counter(self):
        self.set_cnt_en_ext(0)

    def unfreeze_counter(self):
        self.set_cnt_en_ext(1)
        
    def reset_target_set(self, duration):
        self.set_res_n_ext(0)
        time.sleep(duration)

    def reset_target_release(self):
        self.set_res_n_ext(1)

    def reset_target_cycle(self, duration):
        self.reset_target_set(duration)
        self.reset_target_release()
        
    def enable_calibration_mode(self):
        self.set_cal(1)
       
    def disable_calibration_mode(self):
        self.set_cal(0)
                       
    def calibrate(self):
        print('Starting calibration ...')
        ps_value = self.get_phase_shift_value_det()
        print('Initial phase alignment: %i' % ps_value)
   
        #Enable calibration mode
        print('Enabling calibration mode ...')
        self.enable_calibration_mode()
 
        #Set phase shift to zero            
        print('Adjusting phase ...')
        self.set_phase_shift_value_det(0)
        ps_value = self.get_phase_shift_value_det()
        print('New phase alignment: %i' % ps_value)
 
        #Decrementing phase shift until metastability is observed
        meta_found = False
        print(
            'Decrementing phase shift until metastability is observed')
        while not meta_found:
            self.reset_target_set(self.CALIBRATION_RESET_DURATION)
            self.unfreeze_counter()
            self.reset_target_release()
            time.sleep(self.CALIBRATION_TIMEOUT)
            self.freeze_counter()
            #Correct phase alignment
            if (self.get_mtbf_stack_empty() & (1 << 4)) == 0:
                meta_found = True
            else:
                if ps_value == self.get_min_step():
                    raise Exception('Already at the minimum phase shift value!')
                self.decrement_phase_shift_det()
                ps_value = self.get_phase_shift_value_det()
                print('New phase alignment: %i' % ps_value)

        #Incrementing phase shift until metastability is no longer
        #observed
        print(
            'Incrementing phase shift until metastability is no ' +
            'longer observed')
        while meta_found:
            self.reset_target_set(self.CALIBRATION_RESET_DURATION)
            self.unfreeze_counter()
            self.reset_target_release()
            time.sleep(self.CALIBRATION_TIMEOUT)
            self.freeze_counter()
            #Correct phase alignment
            if (self.get_mtbf_stack_empty() & (1 << 4)) != 0:
                meta_found = False
            else:
                if ps_value == self.get_max_step():
                    raise Exception('Already at the maximum phase shift value!')
                self.increment_phase_shift_det()
                ps_value = self.get_phase_shift_value_det()
                print('New phase alignment: %i' % ps_value)

        #Phaseshift threshold for metastability free operation found
        ps_value = self.get_phase_shift_value_det()
        self.m_calibration_value = ps_value
        print('Phase alignment found: %i' % ps_value)
       
        print('Disabling calibration mode ...')
        self.disable_calibration_mode()
        print('Calibration finished.')
        
    def set_calibration_value_det_manually(self, value):
        self.m_calibration_value = value
        self.set_phase_shift_to_calibration_value_det()

    def set_phase_shift_to_calibration_value_det(self):
        self.set_phase_shift_value_det(self.m_calibration_value)

    def set_measurement_duration_counter(self, value):
        self.set_mes_cnt_int64(value)
            
    def set_reset_duration_counter(self, value):
        self.set_res_cnt_int64(value)
        
    def execute_command(self, command):
        self.set_opcode(command)
        while self.is_target_busy():
            pass
        
    def execute_measure_with_current_settings(self):
        self.execute_command(self.COMMAND_MEASURE_WITH_CURRENT_SETTINGS)
        
    def execute_idle(self):
        self.execute_command(self.COMMAND_IDLE)
        
    def is_target_busy(self):
        return self.get_busy()
                
    def get_clock_pulse_length_value(self):
        return self.get_ps_value_pulse()
        
    def set_clock_pulse_length_value(self, value):
        current = self.get_clock_pulse_length_value()
        while current < value:
            self.increment_clock_pulse_value()
            current = self.get_clock_pulse_length_value()

        while current > value:
            self.decrement_clock_pulse_value()
            current = self.get_clock_pulse_length_value()

    def increment_clock_pulse_value(self):
        self.set_ps_inc_pulse(1)
        while self.get_ps_in_progress_pulse() == 0:
            pass
        self.set_ps_inc_pulse(0)
        while self.get_ps_in_progress_pulse() == 1:
            pass

    def decrement_clock_pulse_value(self):
        self.set_ps_dec_pulse(1)
        while self.get_ps_in_progress_pulse() == 0:
            pass
        self.set_ps_dec_pulse(0)
        while self.get_ps_in_progress_pulse() == 1:
            pass
        
    def is_heart_beat_alive(self):
        self.clear_heart_beat()
        time.sleep(self.CHECK_HEART_BEAT_DURATION)
        return self.get_heart_beat_changed()
        
    def clear_heart_beat(self):
        self.set_heart_beat_clear(1)
        self.set_heart_beat_clear(0)
       
    def set_pulse_length_calibration_value_manually(self, value):
        self.m_clock_pulse_length_calibration_value = value
        self.set_clock_pulse_length_value(value)
        
    def get_pulse_length_calibration_value(self):
        return self.m_clock_pulse_length_calibration_value
        
    def calibrate_clock_pulse_length_value(self):
        # self.set_clock_pulse_length_value(0)
        is_alive = self.is_heart_beat_alive()
        print("%d: %d" % (self.get_clock_pulse_length_value(), is_alive))
        while is_alive and self.get_clock_pulse_length_value() > self.get_min_duty():
            self.decrement_clock_pulse_value()
            is_alive = self.is_heart_beat_alive()
            print("%d: %d" % (self.get_clock_pulse_length_value(), is_alive))
        while not is_alive:
            self.increment_clock_pulse_value()
            is_alive = self.is_heart_beat_alive()
            print("%d: %d" % (self.get_clock_pulse_length_value(), is_alive))
        self.m_clock_pulse_length_calibration_value = self.get_clock_pulse_length_value()
        print("Clock pulse calibration value: %d" % self.m_clock_pulse_length_calibration_value)

    def get_board_name(self):
        board_name = ''
        i = 0
        character = 1
        while character != 0:
            character = self.get_board(i)
            if character != 0:
                board_name += chr(character)
            i += 1
        return board_name

    def get_hardware_version(self):
        version = ''
        i = 0
        character = 1
        while character != 0:
            character = self.get_version(i)
            if character != 0:
                version += chr(character)
            i += 1
        return version

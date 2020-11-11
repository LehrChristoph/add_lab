import numpy as np
import MeasurementInfrastructure.MeasurementBoardBaseSerialModule


class LTD_DFF_MTBF_SerialBaseModule(MeasurementInfrastructure.MeasurementBoardBaseSerialModule.MeasurementBoardBaseSerial):
    BASE_ADDRESS_PS_INC_PULSE = 0x00000118
    BASE_ADDRESS_VERSION = 0x00000080
    BASE_ADDRESS_CONTR_FREQ = 0x00000100
    BASE_ADDRESS_PS_DEC_DET = 0x0000011d
    BASE_ADDRESS_UUT_FREQ = 0x00000101
    BASE_ADDRESS_MIN_STEP = 0x00000102
    BASE_ADDRESS_MAX_STEP = 0x00000103
    BASE_ADDRESS_MIN_DUTY = 0x00000104
    BASE_ADDRESS_MAX_DUTY = 0x00000105
    BASE_ADDRESS_STEP_SIZE_N = 0x00000106
    BASE_ADDRESS_HEART_BEAT_CHANGED = 0x00000115
    BASE_ADDRESS_BUSY = 0x00000114
    BASE_ADDRESS_STEP_SIZE_D = 0x00000108
    BASE_ADDRESS_MTBF_STACK = 0x00000120
    BASE_ADDRESS_CNT = 0x0000010a
    BASE_ADDRESS_PS_VALUE_DET = 0x0000011e
    BASE_ADDRESS_HEART_BEAT_CLEAR = 0x00000116
    BASE_ADDRESS_PS_IN_PROGRESS_PULSE = 0x00000117
    BASE_ADDRESS_RES_N_EXT = 0x0000010c
    BASE_ADDRESS_CAL = 0x0000011f
    BASE_ADDRESS_PS_DEC_PULSE = 0x00000119
    BASE_ADDRESS_BOARD = 0x00000000
    BASE_ADDRESS_CNT_EN_EXT = 0x0000010d
    BASE_ADDRESS_PS_VALUE_PULSE = 0x0000011a
    BASE_ADDRESS_MES_CNT = 0x00000112
    BASE_ADDRESS_PS_IN_PROGRESS_DET = 0x0000011b
    BASE_ADDRESS_OPCODE = 0x0000010e
    BASE_ADDRESS_MTBF_STACK_EMPTY = 0x00000130
    BASE_ADDRESS_PS_INC_DET = 0x0000011c
    BASE_ADDRESS_RES_CNT = 0x00000110
    BASE_ADDRESS_MTBF_STACK_OVERFLOWED = 0x00000131

    def __init__(self, port):
        super(LTD_DFF_MTBF_SerialBaseModule, self).__init__(port)

    def __del__(self):
        super(LTD_DFF_MTBF_SerialBaseModule, self).__del__()

    def get_ps_inc_pulse(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_PS_INC_PULSE + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_ps_inc_pulse(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_PS_INC_PULSE + addr, val)
    
    def get_version(self, addr):
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_VERSION + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_version(self, addr, val):
        self.write_address(self.BASE_ADDRESS_VERSION + addr, val)
    
    def get_contr_freq(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_CONTR_FREQ + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_contr_freq(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_CONTR_FREQ + addr, val)
    
    def get_ps_dec_det(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_PS_DEC_DET + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_ps_dec_det(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_PS_DEC_DET + addr, val)
    
    def get_uut_freq(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_UUT_FREQ + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_uut_freq(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_UUT_FREQ + addr, val)
    
    def get_min_step(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_MIN_STEP + addr * 1 + 0)
        val[0] = np.int32(tmp)
        return val[0]
    
    def set_min_step(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_MIN_STEP + addr, val)
    
    def get_max_step(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_MAX_STEP + addr * 1 + 0)
        val[0] = np.int32(tmp)
        return val[0]
    
    def set_max_step(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_MAX_STEP + addr, val)
    
    def get_min_duty(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_MIN_DUTY + addr * 1 + 0)
        val[0] = np.int32(tmp)
        return val[0]
    
    def set_min_duty(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_MIN_DUTY + addr, val)
    
    def get_max_duty(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_MAX_DUTY + addr * 1 + 0)
        val[0] = np.int32(tmp)
        return val[0]
    
    def set_max_duty(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_MAX_DUTY + addr, val)
    
    def get_step_size_n(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_STEP_SIZE_N + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_step_size_n(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_STEP_SIZE_N + addr, val)
    
    def get_heart_beat_changed(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_HEART_BEAT_CHANGED + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def get_busy(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_BUSY + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def get_step_size_d(self):
        addr = 0
        val = [None] * 2
        tmp = self.read_address(self.BASE_ADDRESS_STEP_SIZE_D + addr * 2 + 0)
        val[0] = np.uint32(tmp)
        tmp = self.read_address(self.BASE_ADDRESS_STEP_SIZE_D + addr * 2 + 1)
        val[1] = np.uint32(tmp)
        return val
    
    def get_step_size_d_int64(self):
        tmp = self.get_step_size_d()
        val = np.uint64(tmp[1])
        val = np.left_shift(val, np.uint32(32))
        val = np.bitwise_or(val, tmp[0])
        return val
    
    def set_step_size_d(self, val):
        addr = 0
        if len(val) != 2:
            raise Exception('Not enough data items in input vector')
        self.write_address(self.BASE_ADDRESS_STEP_SIZE_D + addr * 2 + 1, val[1])
        self.write_address(self.BASE_ADDRESS_STEP_SIZE_D + addr * 2 + 0, val[0])
    
    def set_step_size_d_int64(self, val):
        tmp = [None] * 2
        tmp[0] = np.uint32(np.bitwise_and(val, np.uint32(0xFFFFFFFF)))
        tmp[1] = np.uint32(np.right_shift(val, np.uint32(32)))
        self.set_step_size_d(tmp)
    
    def get_mtbf_stack(self, addr):
        val = [None] * 2
        tmp = self.read_address(self.BASE_ADDRESS_MTBF_STACK + addr * 2 + 0)
        val[0] = np.uint32(tmp)
        tmp = self.read_address(self.BASE_ADDRESS_MTBF_STACK + addr * 2 + 1)
        val[1] = np.uint32(tmp)
        return val
    
    def get_mtbf_stack_int64(self, addr):
        tmp = self.get_mtbf_stack(addr)
        val = np.uint64(tmp[1])
        val = np.left_shift(val, np.uint32(32))
        val = np.bitwise_or(val, tmp[0])
        return val
    
    def get_cnt(self):
        addr = 0
        val = [None] * 2
        tmp = self.read_address(self.BASE_ADDRESS_CNT + addr * 2 + 0)
        val[0] = np.uint32(tmp)
        tmp = self.read_address(self.BASE_ADDRESS_CNT + addr * 2 + 1)
        val[1] = np.uint32(tmp)
        return val
    
    def get_cnt_int64(self):
        tmp = self.get_cnt()
        val = np.uint64(tmp[1])
        val = np.left_shift(val, np.uint32(32))
        val = np.bitwise_or(val, tmp[0])
        return val
    
    def get_ps_value_det(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_PS_VALUE_DET + addr * 1 + 0)
        val[0] = np.int32(tmp)
        return val[0]
    
    def get_heart_beat_clear(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_HEART_BEAT_CLEAR + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_heart_beat_clear(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_HEART_BEAT_CLEAR + addr, val)
    
    def get_ps_in_progress_pulse(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_PS_IN_PROGRESS_PULSE + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def get_res_n_ext(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_RES_N_EXT + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_res_n_ext(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_RES_N_EXT + addr, val)
    
    def get_cal(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_CAL + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_cal(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_CAL + addr, val)
    
    def get_ps_dec_pulse(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_PS_DEC_PULSE + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_ps_dec_pulse(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_PS_DEC_PULSE + addr, val)
    
    def get_board(self, addr):
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_BOARD + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_board(self, addr, val):
        self.write_address(self.BASE_ADDRESS_BOARD + addr, val)
    
    def get_cnt_en_ext(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_CNT_EN_EXT + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_cnt_en_ext(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_CNT_EN_EXT + addr, val)
    
    def get_ps_value_pulse(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_PS_VALUE_PULSE + addr * 1 + 0)
        val[0] = np.int32(tmp)
        return val[0]
    
    def get_mes_cnt(self):
        addr = 0
        val = [None] * 2
        tmp = self.read_address(self.BASE_ADDRESS_MES_CNT + addr * 2 + 0)
        val[0] = np.uint32(tmp)
        tmp = self.read_address(self.BASE_ADDRESS_MES_CNT + addr * 2 + 1)
        val[1] = np.uint32(tmp)
        return val
    
    def get_mes_cnt_int64(self):
        tmp = self.get_mes_cnt()
        val = np.uint64(tmp[1])
        val = np.left_shift(val, np.uint32(32))
        val = np.bitwise_or(val, tmp[0])
        return val
    
    def set_mes_cnt(self, val):
        addr = 0
        if len(val) != 2:
            raise Exception('Not enough data items in input vector')
        self.write_address(self.BASE_ADDRESS_MES_CNT + addr * 2 + 1, val[1])
        self.write_address(self.BASE_ADDRESS_MES_CNT + addr * 2 + 0, val[0])
    
    def set_mes_cnt_int64(self, val):
        tmp = [None] * 2
        tmp[0] = np.uint32(np.bitwise_and(val, np.uint32(0xFFFFFFFF)))
        tmp[1] = np.uint32(np.right_shift(val, np.uint32(32)))
        self.set_mes_cnt(tmp)
    
    def get_ps_in_progress_det(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_PS_IN_PROGRESS_DET + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def get_opcode(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_OPCODE + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_opcode(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_OPCODE + addr, val)
    
    def get_mtbf_stack_empty(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_MTBF_STACK_EMPTY + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def get_ps_inc_det(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_PS_INC_DET + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    
    def set_ps_inc_det(self, val):
        addr = 0
        self.write_address(self.BASE_ADDRESS_PS_INC_DET + addr, val)
    
    def get_res_cnt(self):
        addr = 0
        val = [None] * 2
        tmp = self.read_address(self.BASE_ADDRESS_RES_CNT + addr * 2 + 0)
        val[0] = np.uint32(tmp)
        tmp = self.read_address(self.BASE_ADDRESS_RES_CNT + addr * 2 + 1)
        val[1] = np.uint32(tmp)
        return val
    
    def get_res_cnt_int64(self):
        tmp = self.get_res_cnt()
        val = np.uint64(tmp[1])
        val = np.left_shift(val, np.uint32(32))
        val = np.bitwise_or(val, tmp[0])
        return val
    
    def set_res_cnt(self, val):
        addr = 0
        if len(val) != 2:
            raise Exception('Not enough data items in input vector')
        self.write_address(self.BASE_ADDRESS_RES_CNT + addr * 2 + 1, val[1])
        self.write_address(self.BASE_ADDRESS_RES_CNT + addr * 2 + 0, val[0])
    
    def set_res_cnt_int64(self, val):
        tmp = [None] * 2
        tmp[0] = np.uint32(np.bitwise_and(val, np.uint32(0xFFFFFFFF)))
        tmp[1] = np.uint32(np.right_shift(val, np.uint32(32)))
        self.set_res_cnt(tmp)
    
    def get_mtbf_stack_overflowed(self):
        addr = 0
        val = [None] * 1
        tmp = self.read_address(self.BASE_ADDRESS_MTBF_STACK_OVERFLOWED + addr * 1 + 0)
        val[0] = np.uint32(tmp)
        return val[0]
    

import matplotlib
import numpy as np 
import os
from pprint import pprint

def import_data(import_folder):
    data = {}

    for root, dirs, files in os.walk(import_folder):
        for file_name in files:
            filepath = os.path.join(root, file_name)
            with open(filepath, "rb") as fd:
                data_file = np.load(fd, allow_pickle=True)
                data[file_name[:-3]] = data_file[0]["results"][0]
                data[file_name[:-3]]["settings"]["last_data_point"] = data_file[0]["state"]["current_data_point"]
            # end with
        # end for
    # end for

    return data

def do_calculations(datasets):
    for dataset_name in datasets:
        lambda_dat = 2*56*10**6 
        dataset = datasets[dataset_name]
        f_clk = dataset["settings"]['uut_freq']
        T_clk = 1/f_clk
        dataset["settings"]['ps_mult'] = 104.16 * 10**-12 #104.16 pico seconds
        
        calculate_tbu_mtbf(dataset)
        calculate_t_res(dataset)
        [tau,offset] = calculate_T0_tau(dataset["data"]["t_res"], dataset["data"]["mtbf"])
        T0 = (1/(offset*f_clk*lambda_dat))
        dataset["data"]["tau"] = tau
        dataset["data"]["T0"] = T0
    # end for
#end def

def calculate_tbu_mtbf(dataset):
    datapoint_cnt = dataset["settings"]['last_data_point'] +1
    dataset["data"]["mtbf"] = [None]*datapoint_cnt
    dataset["data"]["mtbf_0to0"] = [None]*datapoint_cnt
    dataset["data"]["mtbf_0to1"] = [None]*datapoint_cnt
    dataset["data"]["mtbf_1to1"] = [None]*datapoint_cnt
    dataset["data"]["mtbf_1to0"] = [None]*datapoint_cnt

    dataset["data"]["tbu"] = [None]*datapoint_cnt
    dataset["data"]["tbu_0to0"] = [None]*datapoint_cnt
    dataset["data"]["tbu_0to1"] = [None]*datapoint_cnt
    dataset["data"]["tbu_1to1"] = [None]*datapoint_cnt
    dataset["data"]["tbu_1to0"] = [None]*datapoint_cnt

    for datapoint_id in range(0, datapoint_cnt):
        run_upsets = dataset["data"]["upset_times"][datapoint_id]
        tbu = []
        for index in range(0, run_upsets.size-1):
            tbu.append(run_upsets[index+1] - run_upsets[index])
        # end for
        dataset["data"]["tbu"][datapoint_id] = tbu
        dataset["data"]["mtbf"][datapoint_id] = np.mean(tbu)

        run_upsets = dataset["data"]["upset_times_0to0"][datapoint_id]
        tbu = []
        for index in range(0, run_upsets.size-1):
            tbu.append(run_upsets[index+1] - run_upsets[index])
        # end for
        dataset["data"]["tbu_0to0"][datapoint_id] = tbu
        dataset["data"]["mtbf_0to0"][datapoint_id] = np.mean(tbu)
        
        run_upsets = dataset["data"]["upset_times_0to1"][datapoint_id]
        tbu = []
        for index in range(0, run_upsets.size-1):
            tbu.append(run_upsets[index+1] - run_upsets[index])
        # end for
        dataset["data"]["tbu_0to1"][datapoint_id] = tbu
        dataset["data"]["mtbf_0to1"][datapoint_id] = np.mean(tbu)

        run_upsets = dataset["data"]["upset_times_1to1"][datapoint_id]
        tbu = []
        for index in range(0, run_upsets.size-1):
            tbu.append(run_upsets[index+1] - run_upsets[index])
        # end for
        dataset["data"]["tbu_1to1"][datapoint_id] = tbu
        dataset["data"]["mtbf_1to1"][datapoint_id] = np.mean(tbu)

        run_upsets = dataset["data"]["upset_times_1to0"][datapoint_id]
        tbu = []
        for index in range(0, run_upsets.size-1):
            tbu.append(run_upsets[index+1] - run_upsets[index])
        # end for
        dataset["data"]["tbu_1to0"][datapoint_id] = tbu
        dataset["data"]["mtbf_1to0"][datapoint_id] = np.mean(tbu)
    # end for
# end def

def calculate_t_res(dataset):
    datapoint_cnt = dataset["settings"]['last_data_point'] +1
    dataset["data"]["t_res"] = [None] * datapoint_cnt
    ps_mult = dataset["settings"]['ps_mult']
    for datapoint_id in range(0, datapoint_cnt):
        ps_val = dataset["data"]["ps_values"][datapoint_id]
        if ps_val > 99:
            dataset["data"]["t_res"][datapoint_id] = ps_val - np.iinfo(np.uint32).max #4294967296
        else:
            dataset["data"]["t_res"][datapoint_id] = ps_val
        # end if
        dataset["data"]["t_res"][datapoint_id] = dataset["data"]["t_res"][datapoint_id] * ps_mult
    # end for
# end def

def calculate_T0_tau(x, y):
    if len(x) != len(y):
        raise Exception("length of arrays not equal")
    x_bar = np.mean(x)
    y_bar = np.mean(y)
    x_x_bar = [None] * len(x)
    y_y_bar = [None] * len(x)
    x_x_bar_square = [None] * len(x)
    x_y_bar = [None] * len(x)
    for i in range(0, len(x)):
        x_x_bar[i] = x[i] - x_bar
        y_y_bar[i] = y[i] - y_bar
        x_y_bar[i] = x_x_bar[i] * y_y_bar[i]
        x_x_bar_square[i] = x_x_bar[i] ** 2

    m = np.sum(x_y_bar) / np.sum(x_x_bar_square)
    tau = 1/m
    T0 = y_bar - m * x_bar

    return [tau, T0]
# end def

def store_data(filepath, datasets):
    with open(filepath, "wb") as f:
        np.save(f, datasets)
    # end def
# end def

def generate_figures():
    pass
# end def


if __name__ == "__main__":
    data = import_data("./measurements")
    do_calculations(data)
    store_data("./figure_data.np",data)
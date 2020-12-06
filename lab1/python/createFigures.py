import os
import math
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from pprint import pprint
matplotlib.use("Agg")


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
        dataset["settings"]['ps_mult'] = 104.16 * 10**-12 #104.16 pico seconds

        calculate_tbu_mtbu(dataset)
        calculate_t_res(dataset)
        [tau,offset] = calculate_T0_tau(dataset["data"]["t_res"], dataset["data"]["mtbu"])
        T0 = (1/(offset*f_clk*lambda_dat))
        dataset["data"]["tau"] = tau
        dataset["data"]["T0"] = T0
    # end for
#end def

def calculate_tbu_mtbu(dataset):
    upsetTypes = ["", "_0to0", "_0to1", "_1to0", "_1to1"]
    datapoint_cnt = dataset["settings"]['last_data_point'] +1
    for t in upsetTypes:
        dataset["data"][f"mtbu{t}"] = [None]*datapoint_cnt
        dataset["data"][f"fr{t}"] = [None]*datapoint_cnt
        dataset["data"][f"tbu{t}"] = [None]*datapoint_cnt

    for datapoint_id in range(0, datapoint_cnt):
        def calculateNumbers(dataset, keyPostfix):
            f_clk = dataset["settings"]['uut_freq']
            T_clk = 1/f_clk
            tbu = []
            upsetTimes = dataset["data"][f"upset_times{keyPostfix}"][datapoint_id]
            for ts, nextTs in zip(upsetTimes, upsetTimes[1:]): # Get pairs i, i+1
                tbu.append(T_clk * (nextTs - ts))
            # end for
            dataset["data"][f"tbu{keyPostfix}"][datapoint_id] = tbu
            dataset["data"][f"mtbu{keyPostfix}"][datapoint_id] = np.mean(tbu)
            dataset["data"][f"fr{keyPostfix}"][datapoint_id] = 1/np.mean(tbu)
        # end def

        for t in upsetTypes:
            calculateNumbers(dataset, t)
    # end for
# end def

def calculate_t_res(dataset):
    datapoint_cnt = dataset["settings"]['last_data_point'] +1
    dataset["data"]["t_res"] = [None] * datapoint_cnt
    ps_mult = dataset["settings"]['ps_mult']
    for datapoint_id in range(0, datapoint_cnt):
        ps_val = dataset["data"]["ps_values"][datapoint_id]
        dataset["data"]["t_res"][datapoint_id] = np.int32(ps_val) * ps_mult
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

def generate_figures(datasets, export_folder):
    for dataset_name in datasets:
        dataset = datasets[dataset_name]
        folder = os.path.join(export_folder, dataset_name)
        plot_mtbu(dataset,folder)
        plot_fr(dataset,folder)
        plot_tbu_distribution(dataset,folder)
    # end for
    folder = os.path.join(export_folder, "comparisons")
    plot_mtbu_comparision(datasets, folder)
    plot_fr_comparision(datasets, folder)
# end def

def plot_mtbu(dataset, export_folder):
    t_res = np.array(dataset["data"]["t_res"])*10**12 # Plot in ps

    plots = [
        ("Total", ""),
        ("1to0" , "_1to0"),
        ("0to1" , "_0to1"),
        ("0to0" , "_0to0"),
        ("1to1" , "_1to1"),
    ]

    for _, postfix in plots:
        mtbu = np.array(dataset["data"][f"mtbu{postfix}"])
        mtbu_mask = np.isfinite(mtbu.astype(np.double))
        plt.plot(t_res[mtbu_mask], mtbu[mtbu_mask])
    # end for

    plt.title('MTBU')
    plt.yscale("log")
    plt.grid(which='both')

    plt.ylabel('MTBU (s)')
    plt.xlabel('Resolution time (ps)')

    lastTr = t_res[np.isfinite(np.array(dataset["data"]["mtbu"]))][-1]

    plt.yticks([10**i for i in range(-8, 5)])
    plt.xticks(range(math.floor(int(t_res[0])/200)*200, int(lastTr)+50, 200) )


    plt.legend([elem[0] for elem in plots])

    if not os.path.exists(export_folder):
        os.makedirs(export_folder)
    # end if

    filepath = os.path.join(export_folder, 'MTBU.jpeg')
    plt.savefig(filepath)
    plt.close()
# end def

def plot_fr(dataset, export_folder):
    t_res = np.array(dataset["data"]["t_res"])*10**12 # Plot in ps

    plots = [
        ("Total", ""),
        ("1to0" , "_1to0"),
        ("0to1" , "_0to1"),
        ("0to0" , "_0to0"),
        ("1to1" , "_1to1"),
    ]

    for _, postfix in plots:
        fr = np.array(dataset["data"][f"fr{postfix}"])
        fr_mask = np.isfinite(fr.astype(np.double))
        plt.plot(t_res[fr_mask], fr[fr_mask])
    # end for

    plt.yscale("log")
    plt.title('Failure Rate')
    plt.grid(which='both')

    plt.ylabel('Failure rate (s$^{-1}$)')
    plt.xlabel('Resolution time (ps)')

    lastTr = t_res[np.isfinite(np.array(dataset["data"]["fr"]))][-1]

    plt.yticks([10**i for i in range(-4, 9)])
    plt.xticks(range(math.floor(int(t_res[0])/200)*200, int(lastTr)+50, 200))


    plt.legend([elem[0] for elem in plots])

    if not os.path.exists(export_folder):
        os.makedirs(export_folder)
    # end if
    filepath = os.path.join(export_folder, 'failure_rate.jpeg')
    plt.savefig(filepath)
    plt.close()
# end def

def plot_tbu_distribution(dataset, export_folder):
    tbu_list = []
    t_res = []

    elements = len(dataset["data"]["tbu"])

    for i in range(elements):
        tbu_list.extend(dataset["data"]["tbu"][i])
    # end for

    total_tbu = np.array(tbu_list)
    tbu_bins = np.logspace(np.log10(total_tbu.min()), np.log10(total_tbu.max()), num=30)

    tbu_hist = []
    t_res_hist = []

    x = []  # x coordinates of each bar
    y = []  # y coordinates of each bar
    dz = [] # Height of each bar

    for i in range(elements):
        dp_tbus = dataset["data"]["tbu"][i]
        hist, edges = np.histogram(dp_tbus, bins=tbu_bins)
        tmp = np.array(hist)/len(dp_tbus)

        if(tmp.size > 0 ):
            j =0
            for entry in tmp.tolist():

                if(entry != 0 and entry != np.nan):
                    x.append(dataset["data"]["t_res"][i] )
                    y.append(j)#tbu_bins[j])
                    dz.append(entry)
                # end if
                j+=1
            # end for
        # end if
    # end for

    z =  [0] * len(x)      # z coordinates of each bar
    dx = [dataset["settings"]['ps_mult']] * len(x) #, 0.5, 0.5]  # Width of each bar
    dy = [1] * len(x) #, 0.5, 0.5]  # Depth of each bar

    fig = plt.figure()          #create a canvas, tell matplotlib it's 3d
    ax = fig.add_subplot(111, projection='3d')
    ax.bar3d(x, y, z, dx, dy, dz)
    ax.set_xlim3d(min(x),max(x))
    ax.set_zlim3d(min(y),max(y))
    ax.set_zlim3d(min(dz),max(dz))

    if not os.path.exists(export_folder):
        os.makedirs(export_folder)
    # end if
    filepath = os.path.join(export_folder, 'tbu_distribution.jpeg')
    plt.savefig(filepath)
    plt.close()
# end def

def plot_mtbu_comparision(datasets,export_folder):
    legend = []
    max_Tr= -np.inf
    min_Tr= np.inf
    
    for dataset_name in datasets:
        dataset = datasets[dataset_name]["data"]
        mtbu = np.array(dataset["mtbu"])
        t_res = np.array(dataset["t_res"])*10**12 # Plot in ps

        mtbu_mask = np.isfinite(mtbu.astype(np.double))
        plt.plot(t_res[mtbu_mask], mtbu[mtbu_mask])
        legend.append(dataset_name.replace("_", " "))

        lastTr = t_res[np.isfinite(np.array(dataset["mtbu"]))][-1]
        if(lastTr > max_Tr):
            max_Tr = lastTr
        # end if

        firstTr = t_res[np.isfinite(np.array(dataset["mtbu"]))][0]
        if(firstTr < min_Tr):
            min_Tr = firstTr
        # end if

    # end for

    plt.title('MTBU')
    plt.yscale("log")
    plt.grid(which='both')

    plt.ylabel('MTBU (s)')
    plt.xlabel('Resolution time (ps)')

    plt.yticks([10**i for i in range(-8, 5)])
    plt.xticks(range(math.floor(int(t_res[0])/200)*200, int(lastTr)+50, 200) )

    plt.legend(legend)

    if not os.path.exists(export_folder):
        os.makedirs(export_folder)
    # end if

    filepath = os.path.join(export_folder, 'MTBU_comparison.jpeg')
    plt.xlim(min_Tr, max_Tr)
    plt.savefig(filepath)
    plt.close()
# end def

def plot_fr_comparision(datasets,export_folder):
    legend = []
    max_Tr= -np.inf
    min_Tr= np.inf
    
    for dataset_name in datasets:
        dataset = datasets[dataset_name]["data"]
        mtbu = np.array(dataset["fr"])
        t_res = np.array(dataset["t_res"])*10**12 # Plot in ps

        mtbu_mask = np.isfinite(mtbu.astype(np.double))
        plt.plot(t_res[mtbu_mask], mtbu[mtbu_mask])
        legend.append(dataset_name.replace("_", " "))

        lastTr = t_res[np.isfinite(np.array(dataset["fr"]))][-1]
        if(lastTr > max_Tr):
            max_Tr = lastTr
        # end if

        firstTr = t_res[np.isfinite(np.array(dataset["fr"]))][0]
        if(firstTr < min_Tr):
            min_Tr = firstTr
        # end if

    # end for

    plt.title('Failure Rate')
    plt.yscale("log")
    plt.grid(which='both')

    plt.ylabel('Failure Rate (1/s)')
    plt.xlabel('Resolution time (ps)')

    plt.yticks([10**i for i in range(-8, 5)])
    plt.xticks(range(math.floor(int(t_res[0])/200)*200, int(lastTr)+50, 200) )

    plt.legend(legend)

    if not os.path.exists(export_folder):
        os.makedirs(export_folder)
    # end if

    filepath = os.path.join(export_folder, 'FR_comparison.jpeg')
    plt.xlim(min_Tr, max_Tr)
    plt.savefig(filepath)
    plt.close()
# end def

if __name__ == "__main__":
    data = import_data("./measurements")
    do_calculations(data)
    store_data("./figure_data.np",data)
    generate_figures(data, "./figures")
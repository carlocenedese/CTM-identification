clear all
close all
p = genpath('fnc');
addpath(p);

%% Identification of CTM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Carlo Cenedese (ccenedese@ethz.ch)
% Affiliation: ETH zurich - Automatic Control Laboratory
% Code version: v2.0
% Date: 21/01/2022
% Based on the theory developed in "Highway Traffic Control via Smart 
% e-Mobility" submitted to IEEE - TRANSACTION ON INTELLIGENT 
% TRANSPORTATION SYSTEMS available at  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Preliminaries
% The data on traffic flows in the netherlands are obtained from 
% https://dexter.ndwcloud.nu/home
% The user is assumed to select the the sensors and then dave a .cvs data.
% This has to be saved in the folder '>fnc>data_reader>traffic_data'
% The details on the data used in this example can be found in details in
% the papaer "Highway Traffic Control via Smart 
% e-Mobility - Part II : Case Study" 


%% 1. Data extraction
% Extract the data about traffic from the file 'export4_light' stored in 
% the folder: >fnc>data_reader>traffic_data

% print information on the steps performed
opt_DATEX.verbatim = 1; 

% plot the data obtained graphs
opt_DATEX.display = 0; 

% load previously extracted data, i.e., 1 if wants load 
% previously extracted data and 0 if you desire to
% extract it from the raw data
opt_DATEX.load = 1; 

% minimum frequency per minute at which you want the 
% data. Performs an interpolation if the data are 
% sampled at a lower rate 
extra.min_freq = 6; 

% the number assoiciated to the sensor by DATEX, these has to be found 
% directly in the raw data or in the data site 
extra.sensor_id = {'162','158','154','150','147','142','137','132'};

% extract the data from 'export4_light' and save the result in 
% 'data_structure4' and store it in the structure data
data = csv_DATEX_reader_v2('export4_light','data_structure4_v2',opt_DATEX,extra);

%% 2. CTM param identification
% Identify the parameters of the CTM model
% and the input flow 'phi_1'

% plot the figures realtive to the CTM identification, mainly the 
% fundamental diagram 
opt_identification.disp = 1;


% threshold below which the vehicles are assumed to be into a congestion.
% This was tuned for the problem at hand by looking at the plots attained
% in 'cvs_DATEX_reader' regarding the velocity.
opt_identification.speed_th = [78 90  95 95 95 95 95];

% The threshold used in the quantile regression, these are tuned for the
% particular date used in this example. The vector has to be as long as the
% number of cells in teh CTM model.
opt_identification.coeff_quantile = [0.95 0.95 0.8 0.90 0.9 0.9 0.9];

[CTM_param,phi_1] = CTM_identification(data,opt_identification);


% Run for ToR-ORd+Land electro-mechanical model
% (Margara, F., Wang, Z.J., Levrero-Florencio, F., Santiago, A., Vázquez, M., Bueno-Orovio, A.,
% and Rodriguez, B. (2021). In-silico human electro-mechanical ventricular modelling and simulation for
% drug-induced pro-arrhythmia and inotropic risk assessment. Progress in Biophysics and Molecular Biology).
% https://doi.org/10.1016/j.pbiomolbio.2020.06.007
%% Setting parameters
clear

param.bcl = 1000; % basic cycle length in ms
param.model = @model_ToRORd_Land; % which model is to be used
param.verbose = true; % printing numbers of beats simulated.
param.cellType = 0; %0 endo, 1 epi, 2 mid

options = []; % parameters for ode15s - usually empty
beats = 200; % number of beats
ignoreFirst = beats - 100; % this many beats at the start of the simulations are ignored when extracting the structure of simulation outputs (i.e., beats - 1 keeps the last beat).

X0 = getStartingState('m_endo'); % starting state - can be also m_mid or m_epi for midmyocardial or epicardial cells respectively.

% Simulation and extraction of outputs
tic
[time, X] = modelRunner(X0, options, param, beats, ignoreFirst);
toc
currents = getCurrentsStructure(time, X, beats, param, 0);

ActiveTension = X{1, 1}(:,44)*480; % = XS*Tref/dr - only if lambda=1, mode 'intact'. 
    % add Ta as output in getCurrentsStructure otherwise


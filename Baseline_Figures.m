% Endo, Mid, Epi Simulations at Control Pacing (BCL = 1000/800/500ms) with
% Figure outputs for action potential, calcium transient and active tension.

clear

%% Setting parameters

% param is the default model parametrization here
param.bcl = 1000;
param.model = @model_ToRORd_Land_Female;
param.IKr_Multiplier = 1;
param.cellType = 0; %0 endo, 1 epi, 2 mid

% A list of multipliers
cellTypes = [0, 1, 2];

% Here, we make an array of parameter structures
params(1:length(cellTypes)) = param; % These are initially all the default parametrisation

% And then each is assigned a different IKr_Multiplier
for iParam = 1:length(cellTypes)
    params(iParam).cellType = cellTypes(iParam); % because of this line, the default parametrisation needs to have IKr_Multiplier defined (otherwise Matlab complains about different structure type).
end

options = [];
beats = 100;
ignoreFirst = beats - 1;

%% Simulation and output extraction

% Now, the structure of parameters is used to run multiple models in a
% parallel-for loop.
parfor i = 1:length(params) 
    X0 = getStartingState('m_endo');
    [time{i}, X{i}] = modelRunner(X0, options, params(i), beats, ignoreFirst);
    currents{i} = getCurrentsStructure(time{i}, X{i}, beats, params(i), 0);
    ActiveTension{i} = X{i}{1, 1}(:,44)*480;
end


%% Plotting APs
f1 = figure(1); clf;
f1.Position = [100 100 970 600];
for i = 1:length(params)
    hold on
%   set(hData, 'LineStyle', '-')
%    set(hData, 'LineWidth', 2)
%    plot(hData)
    plot(currents{i}.time, currents{i}.V, 'LineWidth', 2);
    hold off
end

htitle = title('ToR-ORd-Land Baseline, AP');
hlegend = legend('Endo', 'Epi', 'Mid');
hlegend.Position = [1, 400, 60, 97];
hxlabel = xlabel('Time (ms)');
hylabel = ylabel('Membrane potential (mV)');
set(gca, 'FontName', 'Helvetica')
set([hxlabel, hylabel, hlegend], 'FontSize', 20)
set(htitle, 'FontSize', 24, 'FontWeight', 'bold')
set (gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02, 0.02], ...
    'XMinorTick', 'on', ...
    'YMinorTick', 'on', ...
    'LineWidth', 2, ...
    'XTick', 0:100:600, ...
    'YTick', -100:50:50)
grid on
ax = gca;
ax.FontSize = 18;

xlim([-25 600]);
ylim([-100 50])
drawnow();

%% Plotting CaTs
f2 = figure(2); clf;
f2.Position = [100 100 970 600];
for i = 1:length(params)
    hold on
%   set(hData, 'LineStyle', '-')
%    set(hData, 'LineWidth', 2)
%    plot(hData)
    plot(currents{i}.time, currents{i}.Cai * 1000, 'LineWidth', 2);
    hold off
end

htitle = title('ToR-ORd-Land Baseline, CaT');
hlegend = legend('Endo', 'Epi', 'Mid');
hlegend.Position = [1, 400, 60, 97];
hxlabel = xlabel('Time (ms)');
hylabel = ylabel('Ca^{2+} Transient (\muM)');
set(gca, 'FontName', 'Helvetica')
set([hxlabel, hylabel, hlegend], 'FontSize', 20)
set(htitle, 'FontSize', 24, 'FontWeight', 'bold')
set (gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02, 0.02], ...
    'XMinorTick', 'on', ...
    'YMinorTick', 'on', ...
    'LineWidth', 2, ...
    'XTick', 0:100:600, ...
    'YTick', 0:0.2:1.2)
grid on
ax = gca;
ax.FontSize = 18;

xlim([-25 600]);
ylim([0 1.2]);
drawnow();

%% Plotting Active Tension (intact)
f3 = figure(3); clf;
f3.Position = [100 100 970 600];
for i = 1:length(params)
    hold on
%   set(hData, 'LineStyle', '-')
%    set(hData, 'LineWidth', 2)
%    plot(hData)
    plot(currents{i}.time, ActiveTension{i}, 'LineWidth', 2);
    hold off
end

htitle = title('ToR-ORd-Land Baseline, Active Tension');
hlegend = legend('Endo', 'Epi', 'Mid');
hlegend.Position = [1, 400, 60, 97];
hxlabel = xlabel('Time (ms)');
hylabel = ylabel(['Active Tension (kPa)']);
set(gca, 'FontName', 'Helvetica')
set([hxlabel, hylabel, hlegend], 'FontSize', 20)
set(htitle, 'FontSize', 24, 'FontWeight', 'bold')
set (gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02, 0.02], ...
    'XMinorTick', 'on', ...
    'YMinorTick', 'on', ...
    'LineWidth', 2, ...
    'XTick', 0:100:600)
grid on
ax = gca;
ax.FontSize = 18;

xlim([-25 600]);
drawnow();

% Output APD, CaT and AT biomarkers to Console
fprintf('Biomarkers for Endo Cell \n');
fprintf('APD: \n');
apd90           = getAPD(currents{1}.time, currents{1}.V, 0.9);
apd50           = getAPD(currents{1}.time, currents{1}.V, 0.5);
apd30           = getAPD(currents{1}.time, currents{1}.V, 0.3);
overshoot       = max(currents{1}.V);
maxDvDt         = getmaxDvDt(currents{1}.time, currents{1}.V, 1);
RMP             = currents{1}.V(end);
tp              = getTP(currents{1}.time, currents{1}.V);
fprintf('   APD30 = %d ms \n', apd30);
fprintf('   APD50 = %d ms \n', apd50);
fprintf('   APD90 = %d ms \n', apd90);
fprintf('   OS = %d mV \n', overshoot);
fprintf('   RMP = %d mV \n', RMP);
fprintf('   maxDvDt = %d mV/ms \n', maxDvDt);
fprintf('   tp = %d ms \n', tp);

fprintf('CaT: \n');
rt90           = getAPD(currents{1}.time, currents{1}.Cai, 0.9);
rt50           = getAPD(currents{1}.time, currents{1}.Cai, 0.5);
peakCai        = max(currents{1}.Cai) * 1000;
diastolicCai   = currents{1}.Cai(end) * 1000;
tp             = getTP(currents{1}.time, currents{1}.Cai);

fprintf('   rt50 = %d ms \n', rt50);
fprintf('   rt90 = %d ms \n', rt90);
fprintf('   peakCai = %d \mu M \n', peakCai);
fprintf('   diastolicCai = %d \mu M \n', diastolicCai);
fprintf('   tp = %d ms \n', tp);

fprintf('Active Tension \n');
rt90           = getAPD(currents{1}.time, ActiveTension{1}, 0.9);
rt50           = getAPD(currents{1}.time, ActiveTension{1}, 0.5);
peakTension    = max(ActiveTension{1});
restTension    = ActiveTension{1}(end);
tp             = getTP(currents{1}.time, ActiveTension{1});

fprintf('   rt50 = %d ms \n', rt50);
fprintf('   rt90 = %d ms \n', rt90);
fprintf('   peak Tension = %d kPa \n', peakTension);
fprintf('   rest Tension = %d kPa \n', restTension);
fprintf('   tp = %d ms \n', tp);

fprintf('Biomarkers for Epi Cell \n');

fprintf('APD: \n');
apd90           = getAPD(currents{2}.time, currents{2}.V, 0.9);
apd50           = getAPD(currents{2}.time, currents{2}.V, 0.5);
apd30           = getAPD(currents{2}.time, currents{2}.V, 0.3);
overshoot       = max(currents{2}.V);
maxDvDt         = getmaxDvDt(currents{2}.time, currents{2}.V, 1);
RMP             = currents{2}.V(end);
tp              = getTP(currents{1}.time, currents{2}.V);
fprintf('   APD30 = %d ms \n', apd30);
fprintf('   APD50 = %d ms \n', apd50);
fprintf('   APD90 = %d ms \n', apd90);
fprintf('   OS = %d mV \n', overshoot);
fprintf('   RMP = %d mV \n', RMP);
fprintf('   maxDvDt = %d mV/ms \n', maxDvDt);
fprintf('   tp = %d ms \n', tp);

fprintf('CaT: \n');
rt90           = getAPD(currents{2}.time, currents{2}.Cai, 0.9);
rt50           = getAPD(currents{2}.time, currents{2}.Cai, 0.5);
peakCai        = max(currents{2}.Cai) * 1000;
diastolicCai   = currents{2}.Cai(end) * 1000;
tp             = getTP(currents{2}.time, currents{2}.Cai);

fprintf('   rt50 = %d ms \n', rt50);
fprintf('   rt90 = %d ms \n', rt90);
fprintf('   peakCai = %d \mu M \n', peakCai);
fprintf('   diastolicCai = %d \mu M \n', diastolicCai);
fprintf('   tp = %d ms \n', tp);

fprintf('Active Tension \n');
rt90           = getAPD(currents{2}.time, ActiveTension{2}, 0.9);
rt50           = getAPD(currents{2}.time, ActiveTension{2}, 0.5);
peakTension    = max(ActiveTension{2});
restTension    = ActiveTension{2}(end);
tp             = getTP(currents{2}.time, ActiveTension{2});

fprintf('   rt50 = %d ms \n', rt50);
fprintf('   rt90 = %d ms \n', rt90);
fprintf('   peak Tension = %d kPa \n', peakTension);
fprintf('   rest Tension = %d kPa \n', restTension);
fprintf('   tp = %d ms \n', tp);

fprintf('Biomarkers for Mid Cell');

fprintf('APD:');
apd90           = getAPD(currents{3}.time, currents{3}.V, 0.9);
apd50           = getAPD(currents{3}.time, currents{3}.V, 0.5);
apd30           = getAPD(currents{3}.time, currents{3}.V, 0.3);
overshoot       = max(currents{3}.V);
maxDvDt         = getmaxDvDt(currents{3}.time, currents{3}.V, 1);
RMP             = currents{3}.V(end);
tp              = getTP(currents{3}.time, currents{3}.V);
fprintf('   APD30 = %d ms \n', apd30);
fprintf('   APD50 = %d ms \n', apd50);
fprintf('   APD90 = %d ms \n', apd90);
fprintf('   OS = %d mV \n', overshoot);
fprintf('   RMP = %d mV \n', RMP);
fprintf('   maxDvDt = %d mV/ms \n', maxDvDt);
fprintf('   tp = %d ms \n', tp);

fprintf('CaT:');
rt90           = getAPD(currents{3}.time, currents{3}.Cai, 0.9);
rt50           = getAPD(currents{3}.time, currents{3}.Cai, 0.5);
peakCai        = max(currents{3}.Cai) * 1000;
diastolicCai   = currents{3}.Cai(end) * 1000;
tp             = getTP(currents{3}.time, currents{3}.Cai);

fprintf('   rt50 = %d ms \n', rt50);
fprintf('   rt90 = %d ms \n', rt90);
fprintf('   peakCai = %d \mu M \n', peakCai);
fprintf('   diastolicCai = %d \mu M \n', diastolicCai);
fprintf('   tp = %d ms \n', tp);

fprintf('Active Tension');
rt90           = getAPD(currents{3}.time, ActiveTension{3}, 0.9);
rt50           = getAPD(currents{3}.time, ActiveTension{3}, 0.5);
peakTension    = max(ActiveTension{3});
restTension    = ActiveTension{3}(end);
tp             = getTP(currents{3}.time, ActiveTension{3});

fprintf('   rt50 = %d ms \n', rt50);
fprintf('   rt90 = %d ms \n', rt90);
fprintf('   peak Tension = %d kPa \n', peakTension);
fprintf('   rest Tension = %d kPa \n', restTension);
fprintf('   tp = %d ms \n', tp);

function tp = getTP(time, membranePotential)
    % Extract the time to peak for any signal
    [peakVm, peakIndex] = max(membranePotential);
    overshoot = peakVm;
    tp = time(peakIndex) - time(1);
end

function apd = getAPD(time, membranePotential, level, varargin)
    % function which returns APD at the specified level of repolarisation
    % also works for CaT and AT.

    if numel(varargin) > 0
        removeFirstNms      = varargin{1};
    else
        removeFirstNms      = 0;
    end

    membranePotential(time<removeFirstNms) = [];
    time(time<removeFirstNms) = [];

    baseline = membranePotential(end);
    threshold               = (baseline + (1 - level)*(max(membranePotential) - baseline));
    s                       = bwconncomp(membranePotential > threshold);

    % Now, the first object above this threshold is taken.
    interval                = s.PixelIdxList{1};

    % Linear interpolation of the dt after the segment above threshold ends
    tEndInterval            = time(max(interval));
    tAfterEndInterval       = time(max(interval) + 1);
    vEndInterval            = membranePotential(max(interval));
    vAfterEndInterval       = membranePotential(max(interval) + 1);
    howFarThreshAfterEnd    = (threshold - vEndInterval) / (vAfterEndInterval - vEndInterval);
    addInterpolation        = (tAfterEndInterval - tEndInterval) * howFarThreshAfterEnd;
    apd                     = time(interval(end)) - time(interval(1)) + addInterpolation;
end

function maxDvDt = getmaxDvDt(time, membranePotential, ignoreMs)
    % function that returns max dV/dT of an AP, ignoring the synthetic
    % signal.
    
    membranePotential       = membranePotential(time > ignoreMs);
    time                    = time(time > ignoreMs);
    dv                      = diff(membranePotential);
    dt                      = diff(time);
    maxDvDt                 = max(dv./dt);
end

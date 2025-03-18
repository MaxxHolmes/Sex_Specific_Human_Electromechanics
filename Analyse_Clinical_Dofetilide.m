%% Analysis of Clinical Data

fileName = "D:\PostDoc\In_Silico_Trials_Paper\ECG Analysis\ECG_Healthy_Dofetilide_Verapamil_Quinidine_Ranolazine_Dataset.xlsx";

%% Dofetilide: Effect on QT interval and T-wave Amplitude

%dof_male_data = xlsread(fileName, 'Sheet', 'Dofetilide Males', 'Range', 'A3:AU530');
%dof_female_data = xlsread(fileName, 'Sheet', 'Dofetilide Females', 'Range', 'A3:AU530');

dof_m_dose = xlsread(fileName, 'Dofetilide Males', 'AI3:AI530');
dof_m_deltaQT = xlsread(fileName, 'Dofetilide Males', 'AM3:AM530');
dof_m_t_amp = xlsread(fileName, 'Dofetilide Males', 'AS3:AS530');
dof_f_dose = xlsread(fileName, 'Dofetilide Females', 'AI3:AI530');
dof_f_deltaQT = xlsread(fileName, 'Dofetilide Females', 'AM3:AM530');
dof_f_t_amp =  xlsread(fileName, 'Dofetilide Females', 'AS3:AS530');

% Filter all data by removing baseline values

dof_m_deltaQT = dof_m_deltaQT(dof_m_dose ~= 0);
dof_m_t_amp = dof_m_t_amp(dof_m_dose ~= 0);
dof_m_dose = dof_m_dose(dof_m_dose ~= 0);

disp(length(dof_f_dose));
disp(length(dof_f_deltaQT));

dof_f_deltaQT = dof_f_deltaQT(dof_f_dose ~= 0);
dof_f_t_amp = dof_f_t_amp(dof_f_dose ~= 0);
dof_f_dose = dof_f_dose(dof_f_dose ~= 0);

% Remove NaNs

dof_f_dose(find(isnan(dof_f_t_amp))) = [];
dof_f_deltaQT(find(isnan(dof_f_t_amp))) = [];
dof_f_t_amp(find(isnan(dof_f_t_amp))) = [];

fig = figure;
ax = gca;  % Get the current axes handle
ax.XAxis.FontSize = 18;  % Adjust the font size (e.g., 12)
ax.YAxis.FontSize = 18;

% Scatter plot for male group
scatter(dof_m_dose, dof_m_deltaQT, 'Color', [0 0 0.5], 'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2); % 'b' is the color blue
hold on; % Hold on to plot on the same figure

slope = polyfit(dof_m_dose, dof_m_deltaQT, 1); % This finds both slope and intercept
slope = slope(1); % This keeps only the slope
yBestFit = slope * dof_m_dose;
stdDev = std(dof_m_deltaQT);
n = length(dof_m_deltaQT);
stdErr = stdDev/sqrt(n);
upperBound = yBestFit + 1.96*stdErr;
lowerBound = yBestFit - 1.96*stdErr;
plot(dof_m_dose, yBestFit, 'Color', [0 0 0.5], 'LineStyle', '--', 'LineWidth', 3); % Plot line of best fit
fill([dof_m_dose; flipud(dof_m_dose)], [upperBound; flipud(lowerBound)], [0 0 0.5], 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% Scatter plot for female group
scatter(dof_f_dose, dof_f_deltaQT, 'r', 'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2); % 'r' is the color red

slope = polyfit(dof_f_dose, dof_f_deltaQT, 1); % This finds both slope and intercept
slope = slope(1); % This keeps only the slope
yBestFit = slope * dof_f_dose;
stdDev = std(dof_f_deltaQT);
n = length(dof_f_deltaQT);
stdErr = stdDev/sqrt(n);
upperBound = yBestFit + 1.96*stdErr;
lowerBound = yBestFit - 1.96*stdErr;
plot(dof_f_dose, yBestFit, 'Color', [0.3567 0.8118 0.9569], 'LineStyle', '--', 'LineWidth', 3); % Plot line of best fit
fill([dof_f_dose; flipud(dof_f_dose)], [upperBound; flipud(lowerBound)], [0.3567 0.8118 0.9569], 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% Add labels and legend
xlabel('Dofetilide Concentration (\muM)', 'FontSize', 12);
ylabel('\Delta QT (ms)', 'FontSize', 12);
legend('Male', 'Male Avg.', 'Female', 'Female Avg.', 'FontSize', 12);
ylim([-50, 150])
%title('Effect of Dofetilide on QT interval (ms)', 'FontSize', 18);
hold off; % Release the figure

saveas(fig, "Clinical_Dofetilide_on_QT.png");

fig2 = figure;
ax = gca;  % Get the current axes handle
ax.XAxis.FontSize = 12;  % Adjust the font size (e.g., 12)
ax.YAxis.FontSize = 12;

% Scatter plot for male group
scatter(dof_m_dose, dof_m_t_amp, 'Color', [0 0 0.5], 'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2); % 'b' is the color blue
hold on; % Hold on to plot on the same figure

slope = polyfit(dof_m_dose, dof_m_t_amp, 1); % This finds both slope and intercept
slope = slope(1); % This keeps only the slope
yBestFit = slope * dof_m_dose;
stdDev = std(dof_m_t_amp);
n = length(dof_m_t_amp);
stdErr = stdDev/sqrt(n);
upperBound = yBestFit + 1.96*stdErr;
lowerBound = yBestFit - 1.96*stdErr;
plot(dof_m_dose, yBestFit, 'Color', [0 0 0.5], 'LineStyle', '--', 'LineWidth', 3); % Plot line of best fit
fill([dof_m_dose; flipud(dof_m_dose)], [upperBound; flipud(lowerBound)], [0 0 0.5], 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% Scatter plot for female group
scatter(dof_f_dose, dof_f_t_amp, 'r', 'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2); % 'r' is the color red

slope = polyfit(dof_f_dose, dof_f_t_amp, 1); % This finds both slope and intercept
slope = slope(1); % This keeps only the slope
yBestFit = slope * dof_f_dose;
stdDev = std(dof_f_t_amp);
n = length(dof_f_t_amp);
stdErr = stdDev/sqrt(n);
upperBound = yBestFit + 1.96*stdErr;
lowerBound = yBestFit - 1.96*stdErr;
plot(dof_f_dose, yBestFit, 'Color', [0.3567 0.8118 0.9569], 'LineStyle', '--', 'LineWidth', 3); % Plot line of best fit
fill([dof_f_dose; flipud(dof_f_dose)], [upperBound; flipud(lowerBound)], [0.3567 0.8118 0.9569], 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% Add labels and legend
xlabel('Dofetilide Concentration (\muM)', 'FontSize', 18);
ylabel('\Delta T-wave Amp. (mV)', 'FontSize', 18);
ylim([-300, 300])
legend('Male', 'Male Avg.', 'Female', 'Female Avg.', 'FontSize', 18);
%title('Effect of Dofetilide on T-wave amplitude (mV)', 'FontSize', 18);
hold off; % Release the figure

saveas(fig2, "Clinical_Dofetilide_on_Twave_Amp.png");

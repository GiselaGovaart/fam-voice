function plot_ERP_proc_withSD_pilot(DIR)
% Vizualization ERPs with standard diff to check whether the basline
% correction induces artifacts


%% Load datasets
% load the necessary datasets

addpath(genpath(DIR.EEGLAB_PATH));
cd(DIR.grandaverage);

GA_dev12 = pop_loadset('ga_101-102.set');
GA_dev3 = pop_loadset('ga_103.set');
GA_dev4 = pop_loadset('ga_104.set');
GA_stan12 = pop_loadset('ga_231-232.set');
GA_stan3 = pop_loadset('ga_233.set');
GA_stan4 = pop_loadset('ga_234.set');

GA_devall = pop_mergeset(GA_dev12, GA_dev3);
GA_devall = pop_mergeset(GA_devall, GA_dev4);

GA_stanall = pop_mergeset(GA_stan12, GA_stan3);
GA_stanall = pop_mergeset(GA_stanall, GA_stan4);

% remove EEGlab path again to be able to run the plot code
rmpath(genpath(DIR.EEGLAB_PATH)); 

plot_erp({ ...
    {GA_devall}, ...
    {GA_stanall}}, ...
    'Fz', ...
    'plotdiff', 0, ...
    'plotstd', 'fill', ...
    'permute', 1000, ...  % funktioniert gerade noch nicht 
    'avgmode', 'auto', ... 
    'labels', {'deviant', 'standard'} ...
    );

exportgraphics(gcf, strcat(DIR.grandaverage, ...
    'AllSpeakers_Fz_SD.jpeg'), ...
    'Resolution', 300);


end

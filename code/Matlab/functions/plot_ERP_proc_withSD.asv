function plot_ERP_proc_withSD(DIR)
% Vizualization ERPs with standard diff to check whether the basline
% correction induces artifacts


%% ACQ
% load the necessary datasets

addpath(genpath(DIR.EEGLAB_PATH));
cd(DIR.grandaverage);

% Make GAs for ACQ:
GA_dev12_fam = pop_loadset('ga_fam_S12_Dev.set');
GA_dev12_unfam = pop_loadset('ga_unfam_S12_Dev.set');
GA_dev4_fam = pop_loadset('ga_fam_S4_Dev.set');
GA_dev4_unfam = pop_loadset('ga_unfam_S4_Dev.set');

GA_dev_all = pop_mergeset(GA_dev12_fam, GA_dev12_unfam);
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev4_fam);
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev4_unfam); 

GA_stan12_fam = pop_loadset('ga_fam_S12_Stan.set');
GA_stan12_unfam = pop_loadset('ga_unfam_S12_Stan.set');
GA_stan4_fam = pop_loadset('ga_fam_S4_Stan.set');
GA_stan4_unfam = pop_loadset('ga_unfam_S4_Stan.set');

GA_stan_all = pop_mergeset(GA_stan12_fam, GA_stan12_unfam);
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan4_fam);
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan4_unfam); 


% remove EEGlab path again to be able to run the plot code
rmpath(genpath(DIR.EEGLAB_PATH)); 

plot_erp({ ...
    {GA_dev_all}, ...
    {GA_stan_all}}, ...
    'Fz', ...
    'plotdiff', 0, ...
    'plotstd', 'fill', ...
    'permute', 1000, ...  % funktioniert gerade noch nicht 
    'avgmode', 'auto', ... 
    'labels', {'deviant', 'standard'} ...
    );

exportgraphics(gcf, strcat(DIR.plotsQA, ...
    ['ERP_ACQ_Fz_SD.jpeg']), ...
    'Resolution', 300);


%% REC
% load the necessary datasets

addpath(genpath(DIR.EEGLAB_PATH));
cd(DIR.grandaverage);

% Make GAs for RQ:
GA_dev12_fam = pop_loadset('ga_fam_S12_Dev.set');
GA_dev12_unfam = pop_loadset('ga_unfam_S12_Dev.set');
GA_dev4_unfam = pop_loadset('ga_unfam_S4_Dev.set');
GA_dev3_unfam = pop_loadset('ga_unfam_S3_Dev.set');

GA_dev_all = pop_mergeset(GA_dev12_fam, GA_dev12_unfam);
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev4_unfam);
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev3_unfam); 

GA_stan12_fam = pop_loadset('ga_fam_S12_Stan.set');
GA_stan12_unfam = pop_loadset('ga_unfam_S12_Stan.set');
GA_stan4_unfam = pop_loadset('ga_unfam_S4_Stan.set');
GA_stan3_unfam = pop_loadset('ga_unfam_S3_Stan.set');

GA_stan_all = pop_mergeset(GA_stan12_fam, GA_stan12_unfam);
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan4_unfam);
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan3_unfam);

% remove EEGlab path again to be able to run the plot code
rmpath(genpath(DIR.EEGLAB_PATH)); 

plot_erp({ ...
    {GA_dev_all}, ...
    {GA_stan_all}}, ...
    'Fz', ...
    'plotdiff', 0, ...
    'plotstd', 'fill', ...
    'permute', 1000, ...  % funktioniert gerade noch nicht 
    'avgmode', 'auto', ... 
    'labels', {'deviant', 'standard'} ...
    );

exportgraphics(gcf, strcat(DIR.plotsQA, ...
    ['ERP_REC_Fz_SD.jpeg']), ...
    'Resolution', 300);

end

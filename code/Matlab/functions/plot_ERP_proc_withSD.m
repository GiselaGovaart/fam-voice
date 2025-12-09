function plot_ERP_proc_withSD(DIR)
% Vizualization ERPs with standard diff to check whether the basline
% correction induces artifacts

ROI_labels = {'Fz', 'F3', 'F4', 'FC5', 'FC6', 'Cz', 'C3', 'C4', 'F7','F8'};

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

for i = 1:numel(ROI_labels)
    plot_erp({ ...
        {GA_dev_all}, ...
        {GA_stan_all}}, ...
        ROI_labels{i}, ...
        'plotdiff', 1, ...
        'plotstd', 'fill', ...
        'permute', 1000, ...  
        'avgmode', 'across', ...
        'labels', {'deviant', 'standard'} ...
        );

    exportgraphics(gcf, strcat(DIR.plotsQA, ...
        strcat('ERP_ACQ_', ROI_labels(i),'_SD.jpeg')), ...
        'Resolution', 300);
end

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

for i = 1:numel(ROI_labels)
    plot_erp({ ...
        {GA_dev_all}, ...
        {GA_stan_all}}, ...
        ROI_labels{i}, ...
        'plotdiff', 0, ...
        'plotstd', 'fill', ...
        'permute', 1000, ...  % funktioniert gerade noch nicht
        'avgmode', 'auto', ...
        'labels', {'deviant', 'standard'} ...
        );

    exportgraphics(gcf, strcat(DIR.plotsQA, ...
        strcat('ERP_REC_', ROI_labels(i),'_SD.jpeg')), ...
        'Resolution', 300);
end


end

%%
% $Id: example_trgfix.m,v 1.1 2024/09/30 17:29:47 grigu Exp grigu $

dataroot = '/data/dt_transfer/FamVoice/Daten';

subj = '54'
    
datapath = fullfile(dataroot,subj);

eegfile = dir([datapath '/*.vhdr']); 
eegfile = eegfile.name;

logfile = fullfile(datapath,[subj '_logfile.txt']);

EEGin = pop_loadbv(datapath, eegfile);

%%

famvoice_plot_triggers(EEGin);
title(subj);
set(gcf,'Name',subj,'Units','Normalized','Position',[0.08 0.3 0.4 0.4]);

%%
if isfile(logfile)
    EEG = famvoice_fix_bit0(EEGin,logfile);
end

EEG = famvoice_fix_overlap(EEG);

pauses = famvoice_detect_pauses(EEG,10,10);

famvoice_plot_triggers(EEG,pauses,'pause');
title([subj ' fixed']);
set(gcf,'Name',[subj ' fixed'],'Units','Normalized','Position',[0.52,0.3,0.4,0.4]);
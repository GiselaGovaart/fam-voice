function [fig] = famvoice_plot_triggers(EEG, segments, label)
% FAMVOICE_PLOT_TRIGGERS - Display event time series and (optionally) mark 
% indicated segments by shaded areas.
%
% Usage:
%      fig = famvoice_plot_triggers(EEG);
%      fig = famvoice_plot_triggers(EEG, segments, label);
%
% Inputs:
%        EEG   -   [struct] an EEGLAB dataset struct
%   segments   -   [N-by-2 array] 
%      label   -   [char|string] segment label to be shown in the legend
%
% output:
%        fig   -   handle to the created figure

% Copyright (C) 2023 Maren Grigutsch, MPI CBS Leipzig, <grigu@cbs.mpg.de>


%%

if nargin<2
    segments = [];
    label = '';
end


%% Load famVoice triggers and check consistency with EEG event types
[~, trg] = famvoice_check_triggers(EEG);

%% Get event indices and latencies.

iBoundary = find(strcmp({EEG.event.type},'boundary'));
iStimulus = find(ismember({EEG.event.type},trg.stimulus));

% iComment = find(strcmp({EEG.event.code},'Comment'))
iBlockStart = find(strcmp({EEG.event.type},trg.blockStart));
iBlockEnd = find(strcmp({EEG.event.type},trg.blockEnd));

stimTrg = {EEG.event(iStimulus).type};
stimTrgVal = cell2mat(cellfun(@(x) sscanf(x,'S%d'),stimTrg,'UniformOutput',false));

stimLatency = [EEG.event(iStimulus).latency];
startLatency = [EEG.event(iBlockStart).latency];
endLatency = [EEG.event(iBlockEnd).latency];
boundaryLatency = [EEG.event(iBoundary).latency];

%% Display the event time series and mark the beginning and end of blocks by vertical lines.

fig = figure; 
plot((stimLatency-1)/EEG.srate,stimTrgVal,'.');
title(EEG.setname);
xlim([0 EEG.xmax]);
xlabel('Time (s)');
ylabel('Trigger Code');
set(gca,'XMinorTick','on','YMinorTick','on');
grid on;
grid minor;
hold on;
line(repmat((startLatency-1)./EEG.srate,2,1),get(gca,'Ylim'),'Color','g');
line(repmat(  (endLatency-1)./EEG.srate,2,1),get(gca,'Ylim'),'Color','r');
line(repmat((boundaryLatency-1)./EEG.srate,2,1),get(gca,'YLim'),'Color','c',...
    'LineStyle','--','LineWidth',2);

%% Create a legend.

legendLabel = {'stimulus'};
for k=1:numel(iBlockStart)
    if k==1
        legendLabel{end+1} = 'block start';
    else
        legendLabel{end+1} = '';
    end
end
for k=1:numel(iBlockEnd)
    if k==1
        legendLabel{end+1} = 'block end';
    else
        legendLabel{end+1} = '';
    end
end
legendLabel{end+1} = 'boundary';    
legend(legendLabel,'Location','west');


%% Mark segments by shaded areas.

if ~isempty(segments)

    ax = findobj(fig,'Type','Axes');
    yl =  get(ax,'Ylim');
    lgnd = findobj (fig,'Type','legend');
    
    hold on;
    for k = 1:size(segments,1)
       if k==1 
           dsplName = char(label);
       else
           dsplName = '';
           set(lgnd,'AutoUpdate','off');
       end
       patch(([segments(k,[1 2]) segments(k,[2 1])]-1)/EEG.srate,...
           [yl(1) yl(1) yl(2) yl(2)],[1 1 1]*0.8,'facealpha',0.5,'DisplayName',dsplName);
    end

end

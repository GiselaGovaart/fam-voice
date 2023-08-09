function [trg] = famvoice_triggers

% FAMVOICE_TRIGGERS - Returns a structure with the event types used in 
% the FamVoice study.
%
% [ trg ] = famvoice_triggers;
%
% OUTPUT:
%   trg   - [struct] with fields
%      .blockStart   -  type of block start events ('S  1')
%      .blockEnd     -  type of block end events ('S100')
%      .stimulus     -  types of stimulus events (cell array)
%      .stimulusA    -  types of stimulus events in version A of the
%                        experiment
%      .stimulusB    -  types of stimulus events in version B of the
%                        experiment
%      .aux          -  types of auxiliary events (cell array)


% Copyright (C) 2023 Maren Grigutsch, MPI CBS Leipzig, <grigu@cbs.mpg.de>


% stimulus triggers (version A)
expATrigger = [11, 21, ...
           101, 103, 104, ...
           211, 213, 214, ...
           221, 223, 224, ...
           231, 233, 234, ...
           241, 243, 244];
expATrigger = arrayfun(@(x) sprintf('S%3d',x),expATrigger,'UniformOutput',false);

% stimulus triggers (version B)
expBTrigger = [12, 22, ...
              102, 103, 104, ...
              212, 213, 214, ...
              222, 223, 224, ...
              232, 233, 234, ...
              242, 243, 244];

expBTrigger = arrayfun(@(x) sprintf('S%3d',x),expBTrigger,'UniformOutput',false);

% --- Auxiliary triggers / events ---
blockStartTrigger = 'S  1';
blockEndTrigger = 'S100';
auxTrigger = {blockStartTrigger,blockEndTrigger,'boundary'};

% comment = {'actiCAP Data On','actiCAP USB Power Off', 'ControlBox is not connected via USB'};

trg = [];
trg.blockStart = blockStartTrigger;
trg.blockEnd   = blockEndTrigger;
trg.stimulus   = union(expATrigger,expBTrigger);
trg.stimulusA  = expATrigger;
trg.stimulusB  = expBTrigger;
trg.aux        = auxTrigger; 




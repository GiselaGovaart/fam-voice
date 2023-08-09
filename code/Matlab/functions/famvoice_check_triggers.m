function [is_match, trg] = famvoice_check_triggers(EEG)

% FAMVOICE_CHECK_TRIGGERS - Returns true if the events in an EEGLAB
% dataset structure match the triggers used in the FamVoice study, 
% otherwise an error is raised.
%
% Usage:
%      is_match = famvoice_check_triggers(EEG);
%

% See also: famvoice_triggers

% Copyright (C) 2023 Maren Grigutsch, MPI CBS Leipzig, <grigu@cbs.mpg.de>

%%

is_match = false;

% load FamVoice trigger types
trg = famvoice_triggers;

% comments will be ignored
is_comment = strcmp({EEG.event.code},'Comment');

diffA = setdiff({EEG.event(~is_comment).type},[trg.stimulusA,trg.aux]);
diffB = setdiff({EEG.event(~is_comment).type},[trg.stimulusB,trg.aux]);

if ~isempty(diffA) && ~isempty(diffB)
    % unexpectedTrigger = union(diffA,diffB);
    fprintf('Found unexpected events:\n');
    fprintf('  unexpected in version A of the experiment:');
    fprintf(' ''%s''',diffA{:});
    fprintf('\n');
    fprintf('  unexpected in version B of the experiment:');
    fprintf(' ''%s''',diffB{:});
    fprintf('\n');
    error('Unexpected event types.');
else
    is_match = true;
end
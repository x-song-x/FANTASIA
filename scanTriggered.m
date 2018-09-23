function scanTriggered(src,~)
% This function is called by 
%   (1) TrigListener Task callbacks 



global TP
disp(src)

%% Trial State Timing
        TP.D.Trl.TimeStampTriggered =	datestr(now, 'yy/mm/dd HH:MM:SS.FFF'); 
        TP.D.Trl.State =                2; 
        %   -1 =    Stopping,  
        %   0 =     Stopped,
        %   1 =     Started,
        %   2 =     Triggered
    feval(TP.D.Sys.Name,'GUI_Rocker','hTrl_StartTrigStop_Rocker',   'Triggered');

%% Setup NIDAQ
    % Turn AOD & PMT Amplitude accordingly
    feval(TP.D.Sys.Name,...
  	'GUI_AO_6115',[ TP.D.Mon.PMT.CtrlGainValue  TP.D.Mon.Power.AOD_CtrlAmpValue]);
        %           PMT Gain Control            AOD Amp, && StartTrigStop==2

%% MSG LOG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tScanning Triggered\r\n'];
	updateMsg(TP.D.Exp.hLog, msg);
    
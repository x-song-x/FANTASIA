function SetupDispAngle(phandle)
% for updating 'ANGLE PANEL'
% default phandle should be one of:   
%   TP.PI.UI.H0.hAxesAngle
%   TP.UI.H0.hAxesAngle                                

global TP

%% Prepare Parameters

if ~isfield(TP.D.Mky,'Side')
    TP.D.Mky.Side =                             'LEFT';
    % if not recorded, default is 'left' side
end
if ~isfield(TP.D.Exp,'AngleArm')
    TP.D.Exp.AngleArm =                         00;
end

A.MkySide =                                     TP.D.Mky.Side;
A.AngleArmAlpha =                               TP.D.Exp.AngleArm;
A.Transpose =                                   1;

A.Transpose =                                   mod(round(A.Transpose),2);
switch A.Transpose
    case 0; A.LeadingEdge =                     'x';
            A.TrailingEdge =                    'y';
    case 1; A.LeadingEdge =                     'y';
            A.TrailingEdge =                    'x';
    otherwise; errordlg('Transpose error');
end
switch [num2str(A.Transpose) upper(A.MkySide)]
    case '1LEFT';   A.AngleD1MatTheta =         mod(45+A.AngleArmAlpha, 360);
    case '1RIGHT';  A.AngleD1MatTheta =         mod(225+A.AngleArmAlpha, 360);
    case '0LEFT';   A.AngleD1MatTheta =         mod(225+A.AngleArmAlpha, 360);
    case '0RIGHT';  A.AngleD1MatTheta =         mod(45+A.AngleArmAlpha, 360);
    otherwise;  errordlg('leading edge error');
end
A.AngleD2MatTheta =                             A.AngleD1MatTheta + 90;
A.AngleRawImageRot =                            mod(A.AngleD1MatTheta-270, 360);
A.AngleRawImageRotP45 =                         mod(A.AngleRawImageRot+45, 360);
A.AngleMatRotNum90 =                            floor(A.AngleRawImageRotP45/90);
A.AngleImage =                                  A.AngleRawImageRot - 90*A.AngleMatRotNum90;

TP.D.Exp.AngleImage =                           A.AngleImage;     
TP.D.Vol.ImageTranspose =                       A.Transpose;
TP.D.Vol.ImageRot90Num =                        A.AngleMatRotNum90;

ColorTrans =    [.5 .5 .5];
ColorScan =     [0  .5  0];
AxisLength =    0.85;

%% Prepare UI

la = 1;
sa = 0.95;
set(phandle,	'NextPlot',             'replace');

%% Base X & Y Translation
plot(   [-sa+0.15 la], [0 0],...
                'Parent',               phandle,...
                'Color',                ColorTrans,...
                'LineWidth',            2);                 % Axis: X Trans
set(phandle,    'Color',                [0 0 0]);        
set(phandle,    'NextPlot',             'add');    
plot(   [0 0], [-sa+0.15 la],...
                'Parent',               phandle,...
                'Color',                ColorTrans,...
                'LineWidth',            2);                 % Axis: Y Trans  
text(   0, -la, '\leftarrow X (translation) \rightarrow',...
                'Parent',               phandle,...
                'FontSize',             10,...
                'HorizontalAlignment',  'Center',...
                'VerticalAlignment',    'Bottom',...
                'Color',                ColorTrans);        % Text: 'X Translation' 
text(   -la, 0, '\leftarrow Y (translation) \rightarrow',...
                'Parent',               phandle,...
                'FontSize',             10,...
                'HorizontalAlignment',  'Center',...
                'VerticalAlignment',    'Top',...
                'Color',                ColorTrans,...
                'Rotation',             90);                % Text: 'Y Translation' 
            
%% x & y Scan 
plot(   [0 cos(A.AngleD1MatTheta /180*pi)*AxisLength],...
        [0 sin(A.AngleD1MatTheta /180*pi)*AxisLength],...
                'Parent',               phandle,...            
                'Color',                ColorScan,...
                'LineWidth',            2);                 % Axis: Leading
plot(   [0 cos(A.AngleD2MatTheta /180*pi)*AxisLength],...
        [0 sin(A.AngleD2MatTheta /180*pi)*AxisLength],...
                'Parent',               phandle,...
                'Color',                ColorScan,...
                'LineWidth',            2);                 % Axis: Trailing
text(   cos(A.AngleD1MatTheta /180*pi)*AxisLength,...
        sin(A.AngleD1MatTheta /180*pi)*AxisLength,...
        {A.LeadingEdge, '(scan)'},...
                'Parent',               phandle,...
                'FontName',             'Cambria Math',...
                'FontSize',             12,...
                'FontAngle',            'Italic',...
                'HorizontalAlignment',  'Right',...
                'VerticalAlignment',    'Bottom',...
                'Color',                ColorScan,...
                'Rotation',             A.AngleD1MatTheta);	% Text: Leading (scan)
text(   cos(A.AngleD2MatTheta /180*pi)*AxisLength,...
        sin(A.AngleD2MatTheta /180*pi)*AxisLength,...
        {A.TrailingEdge, '(scan)'},...
                'Parent',               phandle,...
                'FontName',             'Cambria Math',...
                'FontSize',             12,...
                'FontAngle',            'Italic',...
                'HorizontalAlignment',  'Right',...
                'VerticalAlignment',    'Bottom',...
                'Color',                ColorScan,...
                'Rotation',             A.AngleD2MatTheta);	% Text: Leading (scan)

%% 'image angle'
text(   0, 0, ...
        {['IMAGE', A.Transpose*''''], 'PANEL'},...
                'Parent',               phandle,...
                'FontSize',             12,...
                'HorizontalAlignment',	'Center',...
                'VerticalAlignment',    'Middle',...
                'BackgroundColor',      ColorScan,...
                'Margin',               10,...
                'Rotation',             A.AngleImage);
set(phandle, 'Ylim', [-1 1], 'Xlim', [-1 1]);

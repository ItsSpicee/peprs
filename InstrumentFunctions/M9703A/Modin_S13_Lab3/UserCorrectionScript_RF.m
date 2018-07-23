%This code is to be used to perform single channel IF Mag/Phase
%baseband corrections on MD1 digitizer via 89600 HW extension.  The following
%user variables can be configured for instrument addresses and specific freq
%response correction parameters
clear all;

pathDesktop = winqueryreg('HKEY_CURRENT_USER', 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'Desktop');


%% User variables
%in dBm, pick an input power where mag response doesn't flip signs and doesn't exceed quad input level
inputFSRdBm = -10.0; 
freqSpan = 250e6; %correction span
freqInc = 5e6; %correction step size
rfcenterFreq = 3.35e9;
ifcenterFreq = 350e6;
numavgs = 3;
vsaSpan = 300e6;%for appropriate 89600 span, should be wider since also used for IF BW filter setting
MXG_IPAddress = 'a-n5172b-20064.soco.agilent.com';
vsaSetupFile = horzcat(pathDesktop,'\S800 2013\magtest.setx');
calFile = horzcat(pathDesktop,'\S800 2013\UserCal\stpTone.cal');

%% Setup measurement parameters

%freqStart and freqStop will be the range for MXG
freqStart = rfcenterFreq-freqSpan/2
freqStop = rfcenterFreq+freqSpan/2

inputFSRV = sqrt(10^(inputFSRdBm/10)/1000*50);%calculate input voltage
freqSteps = round((freqSpan)/freqInc+1) %compute how many steps

% Connect to 89600 VSA
disp('Connecting to and/or starting 89600 VSA software...');
asmPath = 'C:\Program Files\Agilent\89600 Software 17.0\89600 VSA Software\Interfaces_v3.5\';
asmName = 'Agilent.SA.Vsa.Interfaces.dll';
asm = NET.addAssembly(strcat(asmPath, asmName));
import Agilent.SA.Vsa.*;

% Attach to a running instance of VSA. If there no running instance, 
% create one.
vsaApp = ApplicationFactory.Create();
if (isempty(vsaApp))
    wasVsaRunning = false;
    vsaApp = ApplicationFactory.Create(true, '', '', -1);
else
    wasVsaRunning = true;
end

% Make VSA visible
vsaApp.IsVisible = true;

% Label analyzer display
vsaApp.Title = 'Stepped Tone Correction';

% Recall preconfigured setup - ensure connection to proper analyzer in setup
vsaApp.RecallSetup(vsaSetupFile);

% Get interfaces to major items
vsaMeas = vsaApp.Measurements.SelectedItem;
vsaDisp = vsaApp.Display;
vsaFreq = vsaMeas.Frequency;
vsaTrace0 = vsaDisp.Traces.Item(0);
vsaInputAnalog = vsaMeas.Input.Analog;
vsaCorr = vsaApp.Measurements.SelectedItem.InputCorrections.Item(0);
vsaConvCorr = vsaApp.Measurements.SelectedItem.Corrections.Item(0);

% Set input range to 1V FSR
vsaInputAnalog.Range = 0.5; %Range is in V pk

%Connect to MXG
ttext = sprintf('Connecting to MXG at address: %s\n',MXG_IPAddress);
disp(ttext);
t=tcpip(MXG_IPAddress, 5025);
t.OutputBufferSize=1*1024*1024;
t.InputBufferSize=1*1024*1024;
fopen(t);

% Set frequency converter settings and VSA span
vsaConvCorr.ExternalConverterRFCenter = rfcenterFreq;
vsaConvCorr.ExternalConverterIFCenter = ifcenterFreq;
vsaConvCorr.ExternalConverterIFBandwidth = vsaSpan;
vsaConvCorr.IsExternalConverterEnabled = true;
vsaFreq.Span = vsaSpan;


%MXG - load flatness correction and set to start frequency at 
fprintf(t, ':OUTPut OFF\n');
fprintf(t, '*RST;*CLS\n');
% fprintf(t, ':CORR:FLATness:PRES\n'); %preset flatness correction table
% fprintf(t, ':CORR:FLATness:LOAD "FLATCORAL"\n'); %load flatness correction
% fprintf(t, ':CORR ON\n');
fprintf(t, '%s',horzcat(':FREQ:CW ',int2str(freqStart),'\n'));
fprintf(t, horzcat(':POW ',num2str(inputFSRdBm),' dBm\n'));

%initialize array to hold mag response
amplitude = zeros(freqSteps,1);

% set for single measurement
vsaMeas.IsContinuous = false;

% calibrate digitizer hardware
vsaApp.IsMessageEnabled = true;
disp('Performing full self-calibration of M9703A via 89600 VSA');
h = msgbox('Calibration in process...be back in 2 min');
vsaApp.Measurements.SelectedItem.SelectedAnalyzer.Calibration.Calibrate();
if exist('h', 'var')
	delete(h);
	clear('h');
end

fprintf(t, ':OUTPut ON\n'); %now after digitizer self-cal we turn on the MXG output
disp('');
disp('-----------------------------');
disp('Beginning measurement loop...');
for k=1:freqSteps
    mxgFreq = freqStart+freqInc*(k-1);
    fprintf(t, '%s',horzcat(':FREQ:CW ',num2str(mxgFreq),'\n'));
    vsaMeas.Restart;
    for j=1:numavgs
        vsaMeas.Resume;
        % wait for measdone, but don't bother it too often
        % Set timeout to 5 seconds
        bMeasDone = 0;
        t0=clock;
        vsaMeasStatus = vsaMeas.Status;
        while(bMeasDone==0 && etime(clock,t0)<=5)
            pause(.1);
            bMeasDone =  vsaMeasStatus.Value.HasFlag(StatusBits.MeasurementDone);
        end
        t1=clock;
        % check if meas was stuck
        if bMeasDone == 0
            error('Measurement failed to complete');
        end

    end
    vsaTrace0.Markers.SelectedItem.MoveTo(MarkerMoveType.Peak);        
    amplitude(k,1) = vsaTrace0.Markers.SelectedItem.Y;
end

%% Hilbert transform to approximate phase from magnitude
H = amplitude;
H2 = [flipud(conj(H(2:end)));H];
X = abs(H2);
myH = hilbert((log(X)));
phase2sd = -imag(myH);


figure(1)
s(1) = subplot(211);
% hold off
plot(H2)
s(2) = subplot(212);
% hold off
plot(phase2sd,'r') %plot in red
title (s(1),'Measured Double-sided Magnitude Response');
ylabel (s(1),'dBm');
title (s(2),'Computed Double-sided Phase Response');
ylabel (s(2),'Radians');

%Go back to single sided spectrum
phase1sd = phase2sd(round(length(phase2sd)/2):end);

%% Compute results and write output

amplitudeV = sqrt(10.^(amplitude/10)/1000*50);%magnitude response converted to V
corData = (amplitudeV/inputFSRV).*(cos(phase1sd)+1i*sin(phase1sd));

corStartFreq = -(freqSpan/2); %symmetric around VSA CF or IF CF if using Converter

%Open output cal file for writing
disp('Writing cal file output...');
fwid = fopen(calFile,'w');

%Print out header to file
fprintf(fwid,'FileFormat UserCal-1.0\r\n');
fprintf(fwid,'Trace Data\r\n');
fprintf(fwid,'YComplex 1\r\n');
fprintf(fwid,'YFormat RI\r\n');
fprintf(fwid,'XDelta %d\r\n',freqInc);
fprintf(fwid,'XStart %d\r\n',corStartFreq);
fprintf(fwid,'Y\r\n');

for corFileLine = 1:size(corData)
    fprintf(fwid,'%f %f\r\n',real(corData(corFileLine)),imag(corData(corFileLine)));
end

vsaCorr.IsIFExternalCorrectionEnabled = true;
vsaCorr.IFExternalCalibrationFile = calFile;

%% Clean up
% Delete objects
vsaApp.delete;
vsaDisp.delete;
vsaFreq.delete;
vsaInputAnalog.delete;
vsaMeas.delete;
vsaMeasStatus.delete;
vsaTrace0.delete;
fclose(t);


% Clear variables from workspace
clear vsaApp vsaDisp vsaFreq vsaInputAnalog vsaMeas vsaMeasStatus vsaTrace0 vsaTrace1;
clear asm asmName asmPath;
clear bMeasDone t0 value wasVsaRunning xData yData;
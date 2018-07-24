function driver = iqdownload_M3202A(arbConfig, fs, data, marker1, marker2, segmNum, keepOpen, channelMapping, sequence)
% download an IQ waveform to the M320xA
% This routine is NOT intended to be called directly from a user script
% It should only be called via iqdownload()
%
% Guy McBride, Keysight Technologies 2017
%
% Disclaimer of Warranties: THIS SOFTWARE HAS NOT COMPLETED KEYSIGHT'S FULL
% QUALITY ASSURANCE PROGRAM AND MAY HAVE ERRORS OR DEFECTS. KEYSIGHT MAKES 
% NO EXPRESS OR IMPLIED WARRANTY OF ANY KIND WITH RESPECT TO THE SOFTWARE,
% AND SPECIFICALLY DISCLAIMS THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
% FITNESS FOR A PARTICULAR PURPOSE.
% THIS SOFTWARE MAY ONLY BE USED IN CONJUNCTION WITH KEYSIGHT INSTRUMENTS. 

    driver = [];
    if (~isempty(sequence))
        errordlg('Sequence mode is not yet implemented for the M3202A');
        return;
    end
    try
        NET.addAssembly(fullfile(getenv('KEYSIGHT_SD1_LIBRARY_PATH'), 'VisualStudio.NET\KeysightSD1.dll'));
        driver = KeysightSD1.SD_AOU();
        driver.open('M3202A', 1, arbConfig.pxieSlot);
    catch e
        errordlg({'Can''t open N3202A device driver (SD1.SD_AOU) at slot :' arbConfig.pxieSlot});
        return;
    end
    for ch = find(channelMapping(:,1))'
        gen_arb_M320xA(arbConfig, driver, ch, real(data), marker1, fs, segmNum);
    end
    for ch = find(channelMapping(:,2))'
        gen_arb_M320xA(arbConfig, driver, ch, imag(data), marker2, fs, segmNum);
    end
    if (~exist('keepOpen', 'var') || keepOpen == 0)
        driver.close();
    end
end



function gen_arb_M320xA(arbConfig, driver, chan, data, marker, fs, segm_num)
    chan = chan - 1;
    if (isfield(arbConfig,'amplitude'))
        driver.channelAmplitude(chan, arbConfig.amplitude(chan));
    else
        driver.channelAmplitude(chan, 0.5);
    end
    driver.channelWaveShape(chan, KeysightSD1.SD_Waveshapes.AOU_AWG);
    driver.AWG(chan, 0, 0, 0, 0, KeysightSD1.SD_WaveformTypes.WAVE_ANALOG, data);
 end



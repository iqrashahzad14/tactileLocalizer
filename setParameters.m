function cfg = setParameters

    % AUDITORY LOCALIZER-TACTILE LOCALIZER
    
    
    %%version2 ISI=0.5


    % Initialize the parameters and general configuration variables
    cfg = struct();
    cfg.subject.askGrpSess = [false true];% this stops the GUI input for subject group. comment it if you want to ask for subject group

    % by default the data will be stored in an output folder created where the
    % setParamters.m file is
    % change that if you want the data to be saved somewhere else
    cfg.dir.output = fullfile( ...
                              fileparts(mfilename('fullpath')), 'output');

    %% Debug mode settings

    cfg.debug.do = false; % To test the script out of the scanner, skip PTB sync
    cfg.debug.smallWin = false; % To test on a part of the screen, change to 1
    cfg.debug.transpWin = false; % To test with trasparent full size screen

    cfg.verbose = 1;
    cfg.skipSyncTests = 1;

%     cfg.audio.devIdx = 3; % 5 %11

    %% Engine parameters

    cfg.testingDevice = 'mri';
    cfg.eyeTracker.do = false;
    cfg.audio.do = true;

    cfg = setMonitor(cfg);

    % Keyboards
    cfg = setKeyboards(cfg);

    % MRI settings

    cfg = setMRI(cfg);
    cfg.suffix.acquisition = ''; %'0p75mmEv';

    cfg.pacedByTriggers.do = false;

    %% Experiment Design

    %     cfg.design.motionType = 'translation';
    %     cfg.design.motionType = 'radial';
    cfg.design.motionType = 'translation';
    cfg.design.names = {'motion'; 'static'};
    % 0: L--R--L; 180: R--L--R; 270: UDU; 90: DUD
    cfg.design.motionDirections = [180 90];%[0 180 270 90]; %[0 180]
    cfg.design.nbRepetitions = 10;
    cfg.design.nbEventsPerBlock = 16;%6

    %% Timing

    % FOR 7T: if you want to create localizers on the fly, the following must be
    % multiples of the scanner sequence TR
    %
    % IBI
    % block length = (cfg.eventDuration + cfg.ISI) * cfg.design.nbEventsPerBlock

    % for info: not actually used since "defined" by the sound duration
    %     cfg.timing.eventDuration = 0.850; % second

    % Time between blocs in secs
    cfg.timing.IBI = [5.8691    5.5432    6.4765    6.6958    5.0225    6.5777    5.6404    6.0738    5.9374    6.5624    5.4567    5.2934    5.0717    6.1504  5.8641    6.9503    5.1053    6.7020    5.7358    0  ];
    %r = a + (b-a).*rand(N,1); r = 5 + (7-5)*rand(1,19);
    %[5.73166537163980,5.42356704673122,5.80173768922465,5.07472657546192,6.35223601592911,5.82050495633080,6.83095731080948,5.33448611547333,5.19869196955382,6.62783897173142,5.39512903081210,5.76590866233150,6.18731514068680,5.62345174146246,6.98129781243476,6.86631244446354,6.50872737146921,5.97337227485308,6.38788903807745]
    % Time between events in secs
    cfg.timing.ISI = 2;
    % Number of seconds before the motion stimuli are presented
    cfg.timing.onsetDelay = 5.25;
    % Number of seconds after the end all the stimuli before ending the run
    cfg.timing.endDelay = 14;

    % reexpress those in terms of number repetition time
    if cfg.pacedByTriggers.do

        cfg.pacedByTriggers.quietMode = true;
        cfg.pacedByTriggers.nbTriggers = 1;

        cfg.timing.eventDuration = cfg.mri.repetitionTime / 2 - 0.04; % second

        % Time between blocs in secs
        cfg.timing.IBI = 0;
        % Time between events in secs
        cfg.timing.ISI = 0;
        % Number of seconds before the motion stimuli are presented
        cfg.timing.onsetDelay = 0;
        % Number of seconds after the end all the stimuli before ending the run
        cfg.timing.endDelay = 2;
    end

    %% Auditory Stimulation

    cfg.audio.channels = 1;

    %% Task(s)

    cfg.task.name = 'tactile localizer2';

    % Instruction
    cfg.task.instruction = 'Detect the repeated stimulus';

    % Fixation cross (in pixels)
    cfg.fixation.type = 'cross';
    cfg.fixation.colorTarget = cfg.color.white;
    cfg.fixation.color = cfg.color.white;
    cfg.fixation.width = .5;
    cfg.fixation.lineWidthPix = 3;
    cfg.fixation.xDisplacement = 0;
    cfg.fixation.yDisplacement = 0;

    cfg.target.maxNbPerBlock = 2;
    cfg.target.duration = 0.5; % In secs

    cfg.extraColumns = {'direction', 'soundTarget', 'fixationTarget', 'event', 'block', 'keyName'};

end

function cfg = setMonitor(cfg)
    % text size
    cfg.text.size = 48;

    % Monitor parameters for PTB
    cfg.color.white = [255 255 255];
    cfg.color.black = [0 0 0];
    cfg.color.red = [255 0 0];
    cfg.color.grey = mean([cfg.color.black; cfg.color.white]);
    cfg.color.background = cfg.color.grey;
    cfg.text.color = cfg.color.white;

    % Monitor parameters
    cfg.screen.monitorWidth = 50; % in cm
    cfg.screen.monitorDistance = 40; % distance from the screen in cm

    if strcmpi(cfg.testingDevice, 'mri')
        cfg.screen.monitorWidth = 69.8; %25;
        cfg.screen.monitorDistance = 170; %95;
    end
end

function cfg = setKeyboards(cfg)
    cfg.keyboard.escapeKey = 'ESCAPE';
    cfg.keyboard.responseKey = { 'a', 'c', 'b', 'd'}; % dnze rgyb
    cfg.keyboard.keyboard = [];
    cfg.keyboard.responseBox = [];

    if strcmpi(cfg.testingDevice, 'mri')
        cfg.keyboard.keyboard = [];
        cfg.keyboard.responseBox = [];
    end
end

function cfg = setMRI(cfg)
    % letter sent by the trigger to sync stimulation and volume acquisition
    cfg.mri.triggerKey = 's';
    cfg.mri.triggerNb = 1;

    cfg.mri.repetitionTime = 1.75;

    cfg.bids.MRI.Instructions = 'Detected the repeated stimulus';
    cfg.bids.MRI.TaskDescription = [];
    cfg.bids.mri.SliceTiming = [0, 0.9051, 0.0603, 0.9655, 0.1206, 1.0258, 0.181, ...
                              1.0862, 0.2413, 1.1465, 0.3017, 1.2069, 0.362, ...
                              1.2672, 0.4224, 1.3275, 0.4827, 1.3879, 0.5431, ...
                              1.4482, 0.6034, 1.5086, 0.6638, 1.5689, 0.7241, ...
                              1.6293, 0.7844, 1.6896, 0.8448, 0, 0.9051, 0.0603, ...
                              0.9655, 0.1206, 1.0258, 0.181, 1.0862, 0.2413, ...
                              1.1465, 0.3017, 1.2069, 0.362, 1.2672, 0.4224, ...
                              1.3275, 0.4827, 1.3879, 0.5431, 1.4482, 0.6034, ...
                              1.5086, 0.6638, 1.5689, 0.7241, 1.6293, 0.7844, ...
                              1.6896, 0.8448];

end

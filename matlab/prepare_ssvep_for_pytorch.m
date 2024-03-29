%{
Seonung Moon
2024-01-11 ~
Purpose: Preprocess dataset from the paper for easier analysis in PyTorch. 
         This script processes and stores the data and labels for low, mid, 
         and high frequency bands separately.
%}

clc
clear
close all

% Define constants for paths and file names
DATA_DIRECTORY = "YOUR/DATA/PATH"; % Replace YOUR/DATA/PATH with the actual path where your data is stored
SAVE_DIRECTORY = "YOUR/SAVE/PATH"; % Replace YOUR/SAVE/PATH with the path where you want to save processed data

% Define the number of days, number of subjects, number of groups, and duration per trial (in seconds)
days = 2;
subjectNumber = 30;
groupNumber = 3;
cntName = ["cnt_LOW(1)", "cnt_LOW(2)"; "cnt_MID(1)", "cnt_MID(2)"; "cnt_HIGH(1)", "cnt_HIGH(2)"];
mrkName = ["mrk_LOW(1)", "mrk_LOW(2)"; "mrk_MID(1)", "mrk_MID(2)"; "mrk_HIGH(1)", "mrk_HIGH(2)"];
trialTime = 6;

% Initialize matrices to store processed data and labels
lowFrequencyData = zeros(4800, 39, 1200);
midFrequencyData = zeros(4800, 39, 1200);
highFrequencyData = zeros(4800, 39, 1200);
lowLabels = zeros(4800,1);
midLabels = zeros(4800,1);
highLabels = zeros(4800,1);

% Loop over each subject
for subject = 1:subjectNumber
    file1 = DATA_DIRECTORY + "\S" + subject;
    % Loop over each day
    for day = 1:days
        file2 = file1 + "\Day" + day;
        % Process each of the 6 files
        for i = 1:groupNumber
            for l = 1:2
                cntFile = file2 + "\" + cntName(i, l);
                mrkFile = file2 + "\" + mrkName(i, l);
                % Load the cnt and mrk files
                load(cntFile)
                load(mrkFile)
                % Load EEG data and remove DC offset
                eegData = cnt.x(:, :);
                for channel = 1:size(eegData, 2)
                    eegData(:, channel) = removeDC(eegData(:, channel));
                end
                % Apply Moon's BandPass filter
                if i == 1
                    eegData = SM_BPF(eegData, cnt.fs, 3, 9); % Low frequency band
                elseif i == 2
                    eegData = SM_BPF(eegData, cnt.fs, 19, 25); % Mid frequency band
                else
                    eegData = SM_BPF(eegData, cnt.fs, 38, 44); % High frequency band
                end

                L = cnt.fs * trialTime; % Total number of samples per trial

                % Segment the data based on event markers
                for j = 1:size(mrk.time, 2)/2 % Half of the markers are for arrow viewing and are skipped
                    startIndex = mrk.time(j*2-1);
                    endIndex = startIndex + L - 1; % Extract 6 seconds of data
                    segment = eegData(startIndex:endIndex, :); % Extract the marked segment
                    for channel = 1:39
                        index = (subject-1)*160 + (day-1)*80 + (l-1)*40 + j;
                        if i == 1
                            lowFrequencyData(index, channel , : ) = segment(:,channel);
                            lowLabels(index) = mrk.event.desc(j*2-1) - 1; % Labels for low frequency
                        elseif i == 2
                            midFrequencyData(index, channel , : ) = segment(:,channel);
                            midLabels(index) = mrk.event.desc(j*2-1) - 1; % Labels for mid frequency
                        else
                            highFrequencyData(index, channel , : ) = segment(:,channel);
                            highLabels(index) = mrk.event.desc(j*2-1) - 1; % Labels for high frequency
                        end
                    end
                end
            end
        end
    end
end

% Save the processed data to .mat files
cd(SAVE_DIRECTORY)
save('SSVEPdataset.mat', 'lowFrequencyData', 'midFrequencyData', 'highFrequencyData', 'lowLabels', 'midLabels', 'highLabels')

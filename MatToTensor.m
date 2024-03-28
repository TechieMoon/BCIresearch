%{
Seonung Moon
2024-01-11 ~
Let's conduct evaluation of the dataset
%}

clc
clear
close all

% 날짜, 피험자 수, 측정 그룹 수, 파일경로, 시도당 시간(초)
days = 2;
subjectNumber = 30;
groupNumber = 3;
directory = "C:\Users\start\Documents\mrk-and-cnt_datasets";
cntName = ["cnt_LOW(1)", "cnt_LOW(2)"; "cnt_MID(1)", "cnt_MID(2)"; "cnt_HIGH(1)", "cnt_HIGH(2)"];
mrkName = ["mrk_LOW(1)", "mrk_LOW(2)"; "mrk_MID(1)", "mrk_MID(2)"; "mrk_HIGH(1)", "mrk_HIGH(2)"];
trialTime = 6;

% 정확도를 저장할 변수
lowFrequencyData = zeros(4800, 39, 1200);
midFrequencyData = zeros(4800, 39, 1200);
highFrequencyData = zeros(4800, 39, 1200);
lowLabels = zeros(4800,1);
midLabels = zeros(4800,1);
highLabels = zeros(4800,1);

% 피험자별로 계산
for subject = 1:subjectNumber
    file1 = directory + "\S" + subject;
    % 날짜별로 계산
    for day = 1:days
        file2 = file1 + "\Day" + day;
        % 각 6개의 파일 모두 계산
        for i = 1:groupNumber
            correctCount = 0;
            for l = 1:2
                cntFile = file2 + "\" + cntName(i, l);
                mrkFile = file2 + "\" + mrkName(i, l);
                % 파일 불러오기
                load(cntFile)
                load(mrkFile)
                % EEG 데이터 로드 후 DC 제거
                eegData = cnt.x(:, :);
                for channel = 1:size(eegData, 2)
                    eegData(:, channel) = removeDC(eegData(:, channel));
                end
                % Moon's BandPassfilter로 필터링 하기
                if i == 1
                    eegData = SM_BPF(eegData, cnt.fs, 3, 9);
                elseif i == 2
                    eegData = SM_BPF(eegData, cnt.fs, 19, 25);
                else
                    eegData = SM_BPF(eegData, cnt.fs, 38, 44);
                end

                L = cnt.fs * trialTime; % total sampleNumber

                % event marker별로 계산
                for j = 1:size(mrk.time, 2)/2 %% 반절은 화살표를 보고 있었으므로 생략
                    startIndex = mrk.time(j*2-1);
                    endIndex = startIndex + L - 1; % 6초 동안의 데이터
                    segment = eegData(startIndex:endIndex, :); % 마킹 되어 있는 부분만 자르기
                    for channel = 1:39
                        index = (subject-1)*160 + (day-1)*80 + (l-1)*40 + j;
                        if i == 1
                            lowFrequencyData(index, channel , : ) = segment(:,channel);
                            lowLabels(index) = mrk.event.desc(j*2-1) - 1;
                        elseif i == 2
                            midFrequencyData(index, channel , : ) = segment(:,channel);
                            midLabels(index) = mrk.event.desc(j*2-1) - 1;
                        else
                            highFrequencyData(index, channel , : ) = segment(:,channel);
                            highLabels(index) = mrk.event.desc(j*2-1) - 1;
                        end
                    end
                end
            end
        end
    end
end
cd 'C:\Users\start\Documents\dataset'
save('SSVEPdataset.mat','lowFrequencyData','midFrequencyData','highFrequencyData','lowLabels','midLabels','highLabels')
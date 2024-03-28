function filtered_data = matrix_bandpass_filter(data_matrix, sampling_rate, low_freq, high_freq)
    % data_matrix: 필터링할 데이터 행렬, 각 열이 하나의 채널임 (2D 배열)
    % sampling_rate: 샘플링 레이트 (Hz)
    % low_freq: 필터의 하한 주파수 (Hz)
    % high_freq: 필터의 상한 주파수 (Hz)

    % 밴드패스 필터 설계
    bp_filter = designfilt('bandpassiir', ...
                           'FilterOrder', 4, ...
                           'HalfPowerFrequency1', low_freq, ...
                           'HalfPowerFrequency2', high_freq, ...
                           'SampleRate', sampling_rate);

    % 데이터의 채널 수
    num_channels = size(data_matrix, 2);

    % 필터링된 데이터를 저장할 행렬 초기화
    filtered_data = zeros(size(data_matrix));

    % 각 채널에 대해 필터 적용
    for ch = 1:num_channels
        filtered_data(:, ch) = filter(bp_filter, data_matrix(:, ch));
    end
end

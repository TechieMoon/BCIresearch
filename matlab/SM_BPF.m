function filtered_data = matrix_bandpass_filter(data_matrix, sampling_rate, low_freq, high_freq)
    % Apply a bandpass filter to a matrix of data, where each column represents a signal channel.
    %
    % Parameters:
    % data_matrix: Matrix of data to be filtered, with each column as a channel (2D array).
    % sampling_rate: Sampling rate of the data in Hz.
    % low_freq: Lower cutoff frequency of the filter in Hz.
    % high_freq: Upper cutoff frequency of the filter in Hz.

    % Design a bandpass filter
    bp_filter = designfilt('bandpassiir', ...
                           'FilterOrder', 4, ...            % Order of the filter
                           'HalfPowerFrequency1', low_freq, ...  % Lower cutoff frequency
                           'HalfPowerFrequency2', high_freq, ... % Upper cutoff frequency
                           'SampleRate', sampling_rate);         % Sampling rate

    % Determine the number of channels in the data
    num_channels = size(data_matrix, 2);

    % Initialize a matrix to hold the filtered data
    filtered_data = zeros(size(data_matrix));

    % Apply the filter to each channel
    for ch = 1:num_channels
        % Filter each column (channel) of the data_matrix
        filtered_data(:, ch) = filter(bp_filter, data_matrix(:, ch));
    end
end

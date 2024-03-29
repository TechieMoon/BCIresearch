% Define a function to remove DC offset
function dataWithoutDC = removeDC(data)
    dataWithoutDC = data - mean(data);
end

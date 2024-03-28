% DC 제거 함수 정의
function dataWithoutDC = removeDC(data)
    dataWithoutDC = data - mean(data);
end
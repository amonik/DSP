
function [dft,dimentions] = discreteFouierTransform(discreteValues,type)
%discreteValues = [1 3 6 8; 9 8 8 2; 5 4 2 3; 6 6 3 3];

dft = discreteValues;
dimentions = type; %can to 1D or 2D DFT. Please type 1 or 2.

[a,b] = size(discreteValues);
syms n k;
if a == b
    %do DFT
    N = length(discreteValues);1
    for n = 1:N
        for k = 1:N
            fsincos(n,k) = cos(2*pi*(n-1)*(k-1)*(1/N)) - 1i*sin(2*pi*(n-1)*(k-1)*(1/N));
        end
    end
    
elseif a < b
    discreteValues = imresize(discreteValues, [b b]);
    %ReadZeroAddRow = cat(1,zeros((b-a),size(discreteValues,2)), discreteValues);
    %discreteValues = ReadZeroAddRow;
    N = length(discreteValues);
    for n = 1:N
        for k = 1:N
            %fk(n,k) = exp((-2*pi*(n-1)*(k-1)*(1/N)));
            fsincos(n,k) = cos(2*pi*(n-1)*(k-1)*(1/N)) - 1i*sin(2*pi*(n-1)*(k-1)*(1/N));
        end
    end
    
elseif a > b
    discreteValues = imresize(discreteValues, [a a]);
    %ReadZeroAddCol = cat(2,zeros(size(discreteValues,2),(b-a)), discreteValues);
    %discreteValues = ReadZeroAddCol;
    N = length(discreteValues);
    for n = 1:N
        for k = 1:N
            %fk(n,k) = exp((-2*pi*(n-1)*(k-1)*(1/N)));
            fsincos(n,k) = cos(2*pi*(n-1)*(k-1)*(1/N)) - 1i*sin(2*pi*(n-1)*(k-1)*(1/N));
        end
    end
    
end

%1D or 2D FFT
switch(type)
    case 1
        dft = fsincos*discreteValues;
    case 2
        dft = fsincos*discreteValues*transpose(fsincos);
end

end





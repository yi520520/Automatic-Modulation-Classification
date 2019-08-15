clear
clc
%% init
j = sqrt(-1);
NTrain = 100000;
L = 100;
EsNoLow = -10;
EsNoHigh = 20;
PhaseOffset_low = -pi/8;
PhaseOffset_high = pi/8;
NClass = 4;
train_data = zeros(NClass * NTrain, L);
train_label = zeros(NClass * NTrain, 1);
%% get train data
% bpsk
disp('bpsk begin');
signal_data = zeros(NTrain, L);
mod = comm.BPSKModulator();
x = constellation(mod);
xN = length(x);
for row = 1:NTrain
    EsNo = (EsNoHigh - EsNoLow)*rand + EsNoLow; % EsNo ~ U(EsNoLow, EsNoHigh)
    P = 10^(EsNo/10);
    PhaseOffset = (PhaseOffset_high - PhaseOffset_low)*rand + PhaseOffset_low;
    for col = 1:L
        s = x(unidrnd(xN));
        signal_data(row, col) = sqrt(P)*exp(j*PhaseOffset)*s + sqrt(1/2)*(randn+j*randn);
    end
end
for row = 1:NTrain
    train_data(row, :) = signal_data(row, :);
    train_label(row, 1) = 0;
end
% qam4
disp('qam4 begin');
signal_data = zeros(NTrain, L);
noise_data = zeros(NTrain, L);
mod = comm.RectangularQAMModulator('ModulationOrder',4,...
        'NormalizationMethod','Average power','AveragePower', 1);
x = constellation(mod);
xN = length(x);
for row = 1:NTrain
    EsNo = (EsNoHigh - EsNoLow)*rand + EsNoLow;
    P = 10^(EsNo/10);
    PhaseOffset = (PhaseOffset_high - PhaseOffset_low)*rand + PhaseOffset_low;
    for col = 1:L
        s = x(unidrnd(xN));
        signal_data(row, col) = sqrt(P)*exp(j*PhaseOffset)*s + sqrt(1/2)*(randn+j*randn);
    end
end
for row = 1:NTrain
    train_data(row + NTrain, :) = signal_data(row, :);
    train_label(row + NTrain, 1) = 1;
end
% psk8
disp('8psk begin');
signal_data = zeros(NTrain, L);
mod = comm.PSKModulator('ModulationOrder',8,'PhaseOffset',0);
x = constellation(mod);
xN = length(x);
for row = 1:NTrain
    EsNo = (EsNoHigh - EsNoLow)*rand + EsNoLow;
    P = 10^(EsNo/10);
    PhaseOffset = (PhaseOffset_high - PhaseOffset_low)*rand + PhaseOffset_low;
    for col = 1:L
        s = x(unidrnd(xN));
        signal_data(row, col) = sqrt(P)*exp(j*PhaseOffset)*s + sqrt(1/2)*(randn+j*randn);
    end
end
for row = 1:NTrain
    train_data(row + 2*NTrain, :) = signal_data(row, :);
    train_label(row + 2*NTrain, 1) = 2;
end
% qam16
disp('qam16 begin');
signal_data = zeros(NTrain, L);
mod = comm.RectangularQAMModulator('ModulationOrder',16,...
        'NormalizationMethod','Average power','AveragePower',1);
x = constellation(mod);
xN = length(x);
for row = 1:NTrain
    EsNo = (EsNoHigh - EsNoLow)*rand + EsNoLow;
    P = 10^(EsNo/10);
    PhaseOffset = (PhaseOffset_high - PhaseOffset_low)*rand + PhaseOffset_low;
    for col = 1:L
        s = x(unidrnd(xN));
        signal_data(row, col) = sqrt(P)*exp(j*PhaseOffset)*s + sqrt(1/2)*(randn+j*randn);
    end
end
for row = 1:NTrain
    train_data(row + 3*NTrain, :) = signal_data(row, :);
    train_label(row + 3*NTrain, 1) = 3;
end

save('./dataset/train_data.mat', 'train_data', '-mat');
save('./dataset/train_label.mat', 'train_label', '-mat');
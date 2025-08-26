

%%%% Práctica 2 %%%%
%clearvars; close all; clc

% List all files in the folder
folder = 'data/set_ICA';
files = dir(folder);



n = 20;
fs = 250;

tiempos = [30 32 32 152 152 152 152];
t_final = sum(tiempos);

% Iterate through the files and read their content
for i = 3:numel(files)
    fileName = files(i).name;
    disp(fileName)

    x = pop_loadset([folder, '/', fileName]).data;
    x = x';
    
    writematrix(x, ['data/csv_ICA/', fileName(1:end-4), '.csv'])
end

for i = 10%:n
    if i ~= 9 && i ~= 11 && i ~=19

        x = pop_loadset(['data/set/P', num2str(i), '_1_prepro.set']).data;
        
        disp(i)
        disp(size(x, 2))
        
        % Subsets:
        % Subset 1 (Calibración 30 s)
        % Subset 2 (Datos después de la prueba > 690 s)
        x = x(:, (fs*30):(fs*t_final));
        
        FM = spectral_bands(x, fs, fs/2, 1:50, fs);

        writematrix(FM, ['data/csv/P', i_name, '.csv'])
    end
end


function [FM] = spectral_bands(m, window, overlap, f, fs)
    for ch = 1:size(m,1)
        x = m(ch,:);
        [s,f,~] = spectrogram(x,window,overlap,f, fs);
        psd = log(abs(s));
        
        %Divide PSD into one matrix per frequency band
        delta(ch,:) = mean(psd(1:4,:)); 
        theta(ch,:) = mean(psd(4:8,:)); 
        alpha(ch,:) = mean(psd(8:12,:)); 
        beta(ch,:) = mean(psd(12:30,:)); 
        gamma(ch,:) = mean(psd(30:50,:)); 
    end 
    FM = [delta; theta; alpha; beta; gamma]';
    %FM = normalize(FM); 
end

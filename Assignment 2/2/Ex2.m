clc
clear

tennisOdds = [1.20 4.50];
footballOdds = [1.80 3.30 4.10];
boxingOdds = [1.50 15.00 2.60];

events = {
    'Tennis', tennisOdds
    'Football', footballOdds
    'Boxing', boxingOdds
    }; 

numEvents = size(events, 1);

% Entropy vector
H = zeros(numEvents, 1);
% Normalized entropy vector
Hnorm = zeros(numEvents, 1);

figure;
tiledlayout(numEvents, 1, "TileSpacing", "compact", "Padding", "compact");

for k = 1:numEvents
    eventName = events{k, 1};
    odds = events{k, 2};
    
    % Create qi
    qi = 1 ./ odds;
    % Create normalized pi
    pi = qi ./ sum(qi);
    
    % Number of outcomes for this sport
    M = numel(pi);
    % Shannon entropy in bits
    H(k) = -sum(pi .* log2(pi));
    % Normalized entropy
    Hnorm(k) = H(k) / log2(M);

    nexttile;
    bar(pi);
    ylim([0 1]);
    grid on;
    title(sprintf('%s pmf (M = %d)', eventName, M));
    xlabel('Outcome');
    ylabel('Probability');
end

results = table(string(events(:,1)), H, Hnorm, ...
    'VariableNames', {'Sport', 'H_bits', 'Hnorm'});
disp(results);

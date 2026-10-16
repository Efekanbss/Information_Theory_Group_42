clc
clear

%% Data
x1 = [20, 80, 40, 80, 20, 60, 20, 20, 80, 80, 60, 80, 40, 20, 80]; 
x2 = [60, 20, 80, 80, 40, 60, 40, 60, 60, 60, 20, 80, 40, 80, 80]; 
x3 = [80, 60, 20, 40, 80, 40, 20, 20, 60, 20, 40, 20, 60, 60, 60]; 

features = [x1', x2', x3'];



c = [0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0];

x1_values = [20, 40, 60, 80];
x2_values = [20, 40, 60, 80];
x3_values = [20, 40, 60, 80];

igr_matrix = zeros(3);


fprintf('Entropy of c: ');
% entropy(c)
entropy = -5/15 * log2(5/15) - 10/15 * log2(10/15);
disp(entropy)


fprintf('Unique values - same for all the features: ')
disp(x1_values)

fprintf('Candidate thresholds: \n');
thresholds = [];
for i = 1:3
    thresholds(i) = (x1_values(i) + x1_values(i+1)) / 2;
end
disp(thresholds)




n = 1;
% loop on features
for x = features
    m = 1;
    % disp("Working on " + x);    

    % loop on thresholds
    for t = thresholds
        
        fprintf('-------------------------- \n')
        disp("Threshold: " + t);
        
    
        c_subset_lower_threshold = [];
        c_subset_higher_threshold = [];
        c_subset_lower_value = [];
        c_subset_higher_value = [];
        for i = 1:length(c)
            if x(i) < t
                c_subset_lower_threshold(end + 1) = i;
                c_subset_lower_value(end + 1) = c(i);
            else
                c_subset_higher_threshold(end + 1) = i;
                c_subset_higher_value(end + 1) = c(i);
            end
        end
        fprintf('Indexes higher than threshold: \n');
        disp(c_subset_higher_threshold)
        disp(c_subset_higher_value)
        fprintf('Indexes lower than threshold: \n');
        disp(c_subset_lower_threshold)
        disp(c_subset_lower_value)
        % entropy: -zeros/length*log2(zero/length) - ones/length*log2(ones/length)
        
        zeros_higher = 0;
        ones_higher = 0;
        for index = c_subset_higher_threshold
            if c(index) == 0
                zeros_higher = zeros_higher + 1;
            else 
                ones_higher = ones_higher + 1; 
            end
        end
        
        zeros_lower = 0;
        ones_lower = 0;
        for index = c_subset_lower_threshold
            if c(index) == 0
                zeros_lower = zeros_lower + 1;
            else 
                ones_lower = ones_lower + 1; 
            end
        end
        
        disp("Higher than threshold - zeros: " + zeros_higher + ", ones: " + ones_higher)
        
        fprintf('Conditioned Entropy of x1 >= t ')
        len = length(c_subset_higher_threshold);
        con_entropy_higher_t = -(zeros_higher / len )*log2(zeros_higher / len) ...
            - (ones_higher / len )*log2(ones_higher / len);
        disp(con_entropy_higher_t)
        
        
        
        disp("Lower than threshold - zeros: "+ zeros_lower + ", ones: " + ones_lower)
        
        
        fprintf('Conditioned Entropy of x1 < t ')
        leng = length(c_subset_lower_threshold);
        con_entropy_lower_t = -(zeros_lower / leng)*log2(zeros_lower/leng) - (ones_lower/leng)*log2(ones_lower/leng);
        disp(con_entropy_lower_t)
        
        weightedEntropy = (len / length(c)) * con_entropy_higher_t + ...
                          (leng / length(c)) * con_entropy_lower_t;
        disp("Weighted conditioned entropy: " + weightedEntropy);
        
        
        
        informationGain = entropy - weightedEntropy;
        disp("Information Gain:             " + informationGain)
        
        
        % len_higher / len_c
        higher_over_c = length(c_subset_higher_threshold)/length(c);
        % len_lower / len_c
        lower_over_c = length(c_subset_lower_threshold)/length(c);
        
        entropyOfSplit = - higher_over_c * log2(higher_over_c) -...
            lower_over_c * log2(lower_over_c);
        
        infoGainRatio = informationGain / entropyOfSplit;
        % disp(infoGainRatio)
        disp("Information Gain Ratio:       " + infoGainRatio) 
        
        
        igr_matrix(m, n) = infoGainRatio
        m = m + 1;
               
    end
    n = n + 1;
    fprintf('-------------------------- \n')
    fprintf('-------------------------- \n')
end

max_igr = max(max(igr_matrix));
disp("Max value in IGR: " + max_igr)

sec_max_igr = igr_matrix(:, [1,3]);
disp("Second max value in IGR: " + max(max(sec_max_igr)))

third_max_igr = igr_matrix(:, 3);
disp("Third max value in IGR: " + max(max(third_max_igr)))

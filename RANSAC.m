function [model] = ransac(data, fitFun, distFun, sampleSize, maxDistance)
    x = data(:, 1);
    y = data(:, 2);

    num_y = length(y);
    threshP = num_y * 0.8;  % 65% of samples to fit

    model = [];
    error = [];
    i = 0;
    while i < 1000
        sample.idx = randperm(num_y, sampleSize);
        sample.idx = sort(sample.idx);
        
        data_tmp= [x(sample.idx), y(sample.idx)];
        param = fitFun(data_tmp);
        
        inlier_num = 0;
        for p = 1: num_y
            if p ~= sample.idx
                if distFun(param, data(p,:)) <= maxDistance
                    inlier_num = inlier_num + 1;
                end
            end
        end
        
        if inlier_num > threshP      
            for p =1: num_y
                err_tmp(p) = distFun(param, data(p,:));
            end
            err_tmp = mean(err_tmp(:));
            
            model = [model; param];
            error = [error; err_tmp];
        end
        
        i = i + 1;
    end
    
    [~,best_index] = min(error);
    model = model(best_index,:);
end


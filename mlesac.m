function bestModel = mlesac(data, fitFun, distFun, sampleSize, maxDistance)
    threshold = maxDistance;
    numPts    = size(data, 1);
    i  = int32(1);
    maxTrials = int32(1000);
    bestDis   = threshold * numPts;
    confidence = 99;

    while i <= maxTrials
        indices = randperm(numPts, sampleSize);
        samplePoints = data(indices, :, :);
        param = fitFun(samplePoints);
        
        [model, dis, Dis] = evaluateModel(distFun, param, data, threshold);

        if Dis < bestDis
            bestDis = Dis;
            bestModel = model;
            inlierNum = sum(dis < threshold);
            num = computeLoopNumber(sampleSize, confidence, numPts, inlierNum);
            maxTrials = min(maxTrials, num);
        end
        i = i + 1;
    end
end

function [modelOut, distances, sumDistances] = evaluateModel(evalFunc, modelIn, data, threshold)
    dis = evalFunc(modelIn, data);
    dis(dis > threshold) = threshold;
    accDis = sum(dis);
    if iscell(modelIn)
        [sumDistances, minIdx] = min(accDis);
        distances = dis(:, minIdx);
        modelOut = modelIn{minIdx(1)};
    else
        distances = dis;
        modelOut = modelIn;
        sumDistances = accDis;
    end
end

function N = computeLoopNumber(sampleSize, confidence, pointNum, inlierNum)
    inlierProbability = (inlierNum/pointNum)^sampleSize;
    
    if inlierProbability < eps(class(inlierNum))
        N = intmax('int32');
    else
        conf = 0.01 * confidence;
        num  = log10(1 - conf);
        den  = log10(1 - inlierProbability);
        N    = int32(ceil(num/den));
    end 
end
function clearPlots(particlePlots,landmarkPlots)
    if exist('particlePlots')
        for i=1:length(particlePlots)
            delete(particlePlots(i).particles);
            delete(particlePlots(i).gaussian);
        end
    end
    
    if exist('landmarkPlots')
        for i=1:length(particlePlots)
            delete(landmarkPlots(i).landmark);
            delete(landmarkPlots(i).marker);
        end
    end
end
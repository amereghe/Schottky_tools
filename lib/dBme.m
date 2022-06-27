function yOut=dBme(yIn)
    yOut=10*log10((abs(yIn)/size(yIn,1)).^2./50*1E3);
end

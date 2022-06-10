function yy=GenerateDeltas(tt,yy,t0,AA)
    dt=tt(2)-tt(1);                 % time resolution [s]
    indices=round((t0-tt(1))/dt);
    yy(indices)=AA;
end

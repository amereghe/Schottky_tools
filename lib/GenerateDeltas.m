function yy=GenerateDeltas(tt,yy,t0,AA,AM)
    if ( ~exist('AM','var') ), AM=missing(); end
    dt=tt(2)-tt(1);                 % time resolution [s]
    indices=round((t0-tt(1))/dt);
    mySig=AA;
    if ( ~ismissing(AM) ), mySig=mySig.*AM; end
    yy(indices)=mySig;
end

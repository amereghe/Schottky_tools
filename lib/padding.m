function [T,F] = padding(T,F,lu1,lu2,LU1,LU2)

%PADDING adds zeros in order to obtain matrices
%   here we store different signals to make comparisons between them but
%   this is only to be used to visualize three different signals

T(1:length(lu1),2)=lu1;
T(1:length(lu2),3)=lu2;
F(1:length(LU1),2)=LU1;
F(1:length(LU2),3)=LU2;

end

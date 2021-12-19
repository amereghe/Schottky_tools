function [T,F] = padding(T,F,lu1,lu2,LU1,LU2)

%PADDING adds zeros in order to obtain matrices
%   here we store different signals to make comparisons between them but
%   this is only to be used to visualize three different signals

% T(1:length(lu1),2)=lu1;
% T(1:length(lu2),3)=lu2;
% F(1:length(LU1),2)=LU1;
% F(1:length(LU2),3)=LU2;

if ( size(t1,2)>size(t1,1) )
      T=t1'; % transpose array/matrix
   else
      T=t1;
   end
   if ( size(f1,2)>size(f1,1) )
      F=f1'; % transpose array/matrix
   else
      F=f1;
   end
   if ( size(t2,2)>size(t2,1) )
      T(1:length(t2),size(T,2)+1)=t2'; % transpose array/matrix
   else
      T(1:length(t2),size(T,2)+1)=t2;
   end
   if ( size(f2,2)>size(f2,1) )
      F(1:length(f2),size(F,2)+1)=f2'; % transpose array/matrix
   else
      F(1:length(f2),size(F,2)+1)=f2;
   end
   
end

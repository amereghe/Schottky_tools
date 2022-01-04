function Out = padding(In1,In2)
% padding                 function to pad an array into a matrix
%
% The array is first re-arranged such that the largest dimension is 
%   coincident with rows.
% Padded array and rows of the matrix can be different in size
    Out=CheckDim(In1);
    Out(1:length(In2),size(Out,2)+1)=CheckDim(In2); 
end

function Out=CheckDim(In)
% CheckDim       returns the input array with the largest dimension coincident with rows
    if ( size(In,2)>size(In,1) )
      Out=In'; % transpose array/matrix
    else
      Out=In;
    end
end
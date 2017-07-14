function [result] = stitch(leftI,rightI,overlap)

% 
% stitch together two grayscale images with a specified overlap
%
% leftI : the left image of size (H x W1)  
% rightI : the right image of size (H x W2)
% overlap : the width of the overlapping region.
%
% result : an image of size H x (W1+W2-overlap)
%
if (size(leftI,1)~=size(rightI,1)) % make sure the images have compatible heights
  error('left and right image heights are not compatible');
end

overlapLeft = leftI(:,(size(leftI,2)-overlap+1):size(leftI,2));
overlapRight = rightI(:,1:overlap);
matr = double(abs(overlapLeft - overlapRight));
path = shortest_path(matr);
sz = (size(leftI,2) + size(rightI,2) - overlap);
result = zeros(size(rightI,1),sz);
for i = 1:size(result,1)
    k = path(i);
    for j = 1:size(result,2)
        if j >= ((size(leftI,2)-overlap) + path(i))
            result(i,j) = rightI(i,k);
            k = k+1; 
        else
            result(i,j) = leftI(i,j);
        end;
    end;
end;

end
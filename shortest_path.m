function [path] = shortest_path(costs)

%
% given a 2D array of costs, compute the minimum cost vertical path
% from top to bottom which, at each step, either goes straight or
% one pixel to the left or right.
%
% costs:  a HxW array of costs
%
% path: a Hx1 vector containing the indices (values in 1...W) for 
%       each step along the path
%
%
%
[H, W] = size(costs);
val = padarray(costs, [0 1], 999);

%matrix with the pointer of previous path of 
original = nan(H, W);

for  i = 2:H
    for j = 2:W+1
        [m, ind] = min([val(i-1,j-1), val(i-1,j), val(i-1,j+1)]);
        val(i,j) = m + val(i,j);
        original(i,j-1) = (j+ind-3);
    end
end

%find the minimum total path cost and it's index
[mat, index] = min(val(H,:));

% initialize path
path = nan(H,1);

idx = index - 1;
for h = H:-1:1
    path(h) = idx;
    idx = original(h, idx);
end
function output = synth_quilt(tindex,tile_vec,tilesize,overlap)
%
% synthesize an output image given a set of tile indices
% where the tiles overlap, stitch the images together
% by finding an optimal seam between them
%
%  tindex : array containing the tile indices to use
%  tile_vec : array containing the tiles
%  tilesize : the size of the tiles  (should be sqrt of the size of the tile vectors)
%  overlap : overlap amount between tiles
%
%  output : the output image

if (tilesize ~= sqrt(size(tile_vec,1)))
  error('tilesize does not match the size of vectors in tile_vec');
end


width = tilesize-overlap;  
outputsize = size(tindex)*width+overlap;
output = zeros(outputsize(1),outputsize(2));
[h,w] = size(tindex);
temp = zeros(h*tilesize, outputsize(2));

for i = 1:size(tindex,1)
    
  for j = 1:size(tindex,2)-1
      
     offset = (i-1)*width;

     if(j == 1)   
        image1 = tile_vec(:,tindex(i,j));
        image1 = reshape(image1,tilesize,tilesize);
     else
        image1 = temp((1:tilesize)+((i-1)*tilesize), 1:(width*j)+overlap);
     end
     
     image2 = tile_vec(:,tindex(i,j+1));
     image2 = reshape(image2,tilesize,tilesize);
     tile_image = stitch(image1, image2, overlap);
     temp((1:tilesize)+((i-1)*tilesize),1:size(tile_image,2)) = tile_image;
  end
  
end

temp1 = temp';

output = output';
for i = 1:size(tindex,1)-1
    
 if(i ~= 1)
    image1 = output(:, 1:((tilesize*i)-(i-1)*overlap));
 else
     image1 = temp1(:, 1:((tilesize*i)-(i-1)*overlap));
 end
 image2 = temp1(:,(tilesize*i)+1:tilesize*(i+1));
 tile_image = stitch(image1, image2, overlap);
 output(1:size(tile_image,1),1:size(tile_image,2)) = tile_image;
 
end

output = output';
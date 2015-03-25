clear all; hold off;
load('som_wts_1.mat');
load('som_labels_1.mat');
lattice_im = zeros(20,16*10);
for r = 1 : 10
    row_im = zeros(20,16)
    for c = 1: 10
        img = reshape( w(r,c,:), 20 ,16);
        if ( c== 1)
            row_im = img;
            continue;
        end
        row_im = horzcat(row_im, img);
    end
    if(r==1)
        lattice_im = row_im;
        continue;
    end
    lattice_im = vertcat(lattice_im, row_im);
end
imshow(lattice_im);
clear all; hold off;
load('SOM_database.mat');
% Attributes of SOM_database.mat:
% train_data: training data, 320x225 matrix 
% train_classlabel: the labels of the training data, 1x225 vector 
% train_classcount: no of training images for each alphabet 
% test_data: test data, 320x90 matrix 
% test_classlabel: the labels of the testing data, 1x90 vector 
% test_classcount: no of test images for each alphabet
%% Training data images.  There are 225 images.
%  Show in a 15x15 image matrix since 15 * 15 == 225.
%  Each image is 20x16 pixels.
train_data_images_count = size(train_data,2);
im_vert_pixels = 20;
im_horz_pixels = 16;
len_of_disp_matrix_in_images = 15; %15x15 matrix to hold all images.
disp_matrix_train_dataset = zeros(im_vert_pixels * len_of_disp_matrix_in_images, im_horz_pixels * len_of_disp_matrix_in_images);
topLeftX = 1; topLeftY = 1; % init.
for i = 1 : train_data_images_count
   an_img = reshape(train_data(:,i),20,16);
   disp_matrix_train_dataset(topLeftY : topLeftY + im_vert_pixels - 1, topLeftX : topLeftX + im_horz_pixels - 1) = an_img;
   topLeftX = topLeftX + im_horz_pixels;
   if (topLeftX > len_of_disp_matrix_in_images * im_horz_pixels)
       topLeftX = 1; % reset
       topLeftY = topLeftY + im_vert_pixels; % next row of images
   end
end
%% Show test data images. There are 90 images.
%  Show in a 10x10 image matrix since 10 * 10 == 100 > 90 images.
%  Each image is 20x16 pixels.
test_data_images_count = size(test_data,2);
im_vert_pixels = 20;
im_horz_pixels = 16;
len_of_disp_matrix_in_images = 10; %10x10 matrix to hold all images.
disp_matrix_test_dataset = zeros(im_vert_pixels * len_of_disp_matrix_in_images, im_horz_pixels * len_of_disp_matrix_in_images);
topLeftX = 1; topLeftY = 1; % init.
for i = 1 : test_data_images_count
   an_img = reshape(test_data(:,i),20,16);
   disp_matrix_test_dataset(topLeftY : topLeftY + im_vert_pixels - 1, topLeftX : topLeftX + im_horz_pixels - 1) = an_img;
   topLeftX = topLeftX + im_horz_pixels;
   if (topLeftX > len_of_disp_matrix_in_images * im_horz_pixels)
       topLeftX = 1; % reset
       topLeftY = topLeftY + im_vert_pixels; % next row of images
   end
end
%% Plot
figure;
imshow(disp_matrix_train_dataset);
title('Train Data');
figure;
imshow(disp_matrix_test_dataset);
title('Test Data');
%% Additional comments
%   You may view the image of a single handwritten character using the code below:
%     tmp=reshape(train_data(:,2),20,16);
%     imshow(tmp);

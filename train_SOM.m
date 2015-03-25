clear all; hold off;
%% Load data
load SOM_database.mat;
% Attributes:
% train_data: training data, 320x225 matrix 
% train_classlabel: the labels of the training data, 1x225 vector 
% train_classcount: no of training images for each alphabet 
% test_data: test data, 320x90 matrix 
% test_classlabel: the labels of the testing data, 1x90 vector 
% test_classcount: no of test images for each alphabet

% You may view an alphabet using the code below:
%tmp=reshape(train_data(:,2),20,16);
%imshow(train_data);

%% Variables concerning data set
img_size = [20 16];
% Have 10 x 10 neurons. Each neuron will have a 20 x 16 weight matrix.
% This weight matrix is reshaped to a 320 x 1 weight vector for
% convenience.
lattice_num_rows = 10; lattice_num_cols = 10;
min_val_in_train_data = min(train_data(:));
max_val_in_train_data = max(train_data(:));
% Number of images in training data set:
num_training_input_vector = size(train_data,2);
%% SOM Training

% No. of training iterations:
num_iterations = 1000;
% Learning rate:
learning_rate_0 = 0.1;
learning_rate = @(iter) learning_rate_0 * exp(-iter / num_iterations);
% Sigma of neighbourhood function:
sigma_0 = norm([lattice_num_rows, lattice_num_cols],2) / 2;
tau_1 = num_iterations / log(sigma_0);
sigma = @(iter) sigma_0 * exp (-iter / tau_1);
% Neighbourhood function:
% r1, c1, r2, c2 means row of neuron 1, col of neuron 1, row of neuron 2,
% col of neuron 2 respectively.
neighbourhood_func =  @(r1, c1, r2, c2, iter) exp( -(norm([r1 c1] - [r2 c2],2)^2) / (2 * sigma(iter)^2) );

% 1. Randomly initialize weights with upper and lower bounds taken from
%       train_data.
rng(1);
w = rand(lattice_num_rows, lattice_num_cols, img_size(1) * img_size(2));
w = w * (max_val_in_train_data - min_val_in_train_data) + min_val_in_train_data;

for iter = 1 : num_iterations
    fprintf('Now at iteration %d out of %d.\n', iter, num_iterations);
    for img_idx = randperm(num_training_input_vector)
        % 2. Choose an image from train_data.
        img = train_data(:,img_idx);
        % 3. Determine winner neuron. Winner neuron is neuron that is
        % closest to training image.
        winner_r = -1; winner_c = -1; %init.
        min_dist = inf; % init
        for r = 1 : lattice_num_rows
            for c = 1: lattice_num_cols
                dist = norm(shiftdim(w(r,c,:))-img,2);
                if (dist < min_dist)
                    min_dist = dist;
                    winner_r = r; winner_c = c;
                end
            end
        end % END finding winner neuron.
        % 4. Update all weight vectors in lattice using neighbourhood func.
        for r = 1 : lattice_num_rows
            for c = 1: lattice_num_cols
                w(r,c,:) = w(r,c,:) + learning_rate(iter) * neighbourhood_func(r,c,winner_r,winner_c,iter) * (shiftdim(img,-2) - w(r,c,:));
            end
        end % END updating neighbouring neurons.
    end % END foreach image in train_data.
end % END iterations.

% Label the neurons (in the lattice).  A neuron is labelled with the label of 
% the input vector in the training set closest to it.
neuron_labels = cell(lattice_num_rows, lattice_num_cols);
for r = 1 : lattice_num_rows
    for c = 1: lattice_num_cols
        closest_img_idx = -1;
        min_dist = inf;
        for img_idx = 1 : num_training_input_vector
            img = train_data(:,img_idx);
            dist = norm(img - shiftdim(w(r,c,:)), 2);
            if (dist < min_dist)
                closest_img_idx = img_idx;
                min_dist = dist;
            end
        end % END Found input vector in train_data that is closest to w(r,c,:).
        closest_label = train_classlabel(closest_img_idx);
        neuron_labels(r,c) = closest_label;
    end
end % END finished labelling.

%% Print out labels of SOM.
display(neuron_labels);


























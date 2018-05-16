function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Part 1

% Input to first hidden layer.
a1  = [ones(m,1) X];  % Add bias
z2  = a1*Theta1';     % Compute
a2  = sigmoid(z2);

% Add bias
a2  = [ones(m,1) a2];% Add bias
z3  = a2*Theta2';% Compute
a3  = sigmoid(z3); 
h   = a3; 

% Y matrix
y_matrix  = eye(num_labels)(y,:); 

% Cost matrix
cost_matrix = -y_matrix.*log(h)-(1-y_matrix).*log(1-h);

% Sum everything
J = sum(cost_matrix(:))/m;

t1 = Theta1(:,2:end);
t2 = Theta2(:,2:end);
theta1_squared = t1.*t1; 
theta2_squared = t2.*t2; 
reg = lambda/2/m*(sum(theta1_squared(:))+sum(theta2_squared(:)));

J += reg;

% Part 2 

% d1c = zeros(rows(Theta1),columns(Theta1)-1);
% d2c = zeros(rows(Theta2),columns(Theta2)-1);

for t = 1:m
    % Forward propagation
    a1  = [1 X(t,:)];   % Add bias
    z2  = a1*Theta1';   % Compute
    a2  = sigmoid(z2);
    a2  = [1 a2];       % Add bias
    z3  = a2*Theta2';   % Compute
    a3  = sigmoid(z3); 

    % Output layer
    s3 = a3 - y_matrix(t,:);

    % Hidden layer
    s2 = (Theta2(:,2:end)'*s3'.*sigmoidGradient(z2)')'; 

    % Accumulate gradient 
    d2 = s3'*a2; 
    d1 = s2'*a1; 

    Theta1_grad += d1; 
    Theta2_grad += d2; 
end

Theta1_grad /= m;
Theta2_grad /= m;

reg1 = Theta1;
reg1(:,1) = 0;
reg1 *= lambda/m;
Theta1_grad += reg1;

reg2 = Theta2;
reg2(:,1) = 0;
reg2 *= lambda/m;
Theta2_grad += reg2;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end

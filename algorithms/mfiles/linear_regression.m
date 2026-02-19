function [epoch_vec, loss_hist, y_pred] = linear_regression(sample_count, learning_rate, epochs)
% Linear regression via gradient descent on a synthetic dataset.
% Returns epoch indices, loss history, and final predictions.

if nargin < 1, sample_count = 50; endif
if nargin < 2, learning_rate = 0.01; endif
if nargin < 3, epochs = 500; endif

% ground truth line: y = m*x + b with noise
m_true = -4;
b_true = 3.25;
x = linspace(-5, 5, sample_count)';
noise = 0.5 * randn(sample_count, 1);
y = m_true .* x + b_true + noise;

% parameters to learn
m = 0;
b = 0;

loss_hist = zeros(epochs, 1);
epoch_vec = (1:epochs)';

for i = 1:epochs
  y_hat = m .* x + b;
  err = y_hat - y;
  loss = mean(err .^ 2);
  loss_hist(i) = loss;

  % gradients
  dm = (2 / sample_count) * sum(err .* x);
  db = (2 / sample_count) * sum(err);

  % update
  m = m - learning_rate * dm;
  b = b - learning_rate * db;
endfor

% final prediction
y_pred = m .* x + b;

endfunction

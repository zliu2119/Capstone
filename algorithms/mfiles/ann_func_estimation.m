function [x, y_pred, y_true, loss_curve] = ann_func_estimation(sample_count, noise, epochs)
% Non-interactive ANN function estimation entrypoint.
% Uses NNET-style helpers when available; otherwise raises a clear error so
% the Python wrapper can fall back to its local implementation.

if nargin < 1, sample_count = 100; endif
if nargin < 2, noise = 0.1; endif
if nargin < 3, epochs = 200; endif

sample_count = max(20, round(sample_count));
noise = max(0, noise);
epochs = max(10, round(epochs));

x = linspace(0, 1, sample_count)';
y_true = sin(2*pi*x) + noise * randn(sample_count, 1);
loss_curve = zeros(epochs, 1);

if exist('mlp', 'file') ~= 2 || exist('netopt', 'file') ~= 2 || exist('mlpfwd', 'file') ~= 2
  error('ann_func_estimation:MissingDependency', ...
    'Missing ANN toolbox functions (mlp/netopt/mlpfwd).');
endif

hnode = max(8, min(64, floor(sample_count / 4)));
net = mlp(1, hnode, 1, 'linear');
options = zeros(1, 18);
options(1) = 0;
options(14) = epochs;
[net, options] = netopt(net, options, x, y_true, 'scg');
y_pred = mlpfwd(net, x);

% `netopt` does not guarantee per-epoch history here; provide final loss.
final_mse = mean((y_pred - y_true) .^ 2);
loss_curve(:) = final_mse;
endfunction

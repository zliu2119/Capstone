function [epoch_vec, metric, accuracy] = ann_hdb_classification(epochs, learning_rate)
% Non-interactive ANN HDB classification entrypoint.
% Depends on external ANN helpers and dataset file; emits explicit errors
% when unavailable so Python can perform fallback inference.

if nargin < 1, epochs = 300; endif
if nargin < 2, learning_rate = 0.01; endif

epochs = max(20, round(epochs));
learning_rate = min(1.0, max(1e-4, learning_rate));

if exist('mlp', 'file') ~= 2 || exist('netopt', 'file') ~= 2 || exist('mlpfwd', 'file') ~= 2
  error('ann_hdb_classification:MissingDependency', ...
    'Missing ANN toolbox functions (mlp/netopt/mlpfwd).');
endif
base_dir = fileparts(mfilename('fullpath'));
data_file = fullfile(base_dir, 'resale18cc_norm.csv');
if exist(data_file, 'file') ~= 2
  error('ann_hdb_classification:MissingDataset', ...
    'Missing dataset file resale18cc_norm.csv.');
endif

X = csvread(data_file);
[M, ~] = size(X);
TRP = round(0.8 * M);
feature = X(1:TRP, 1:5);
label = X(1:TRP, 7:9);
[~, nin] = size(feature);
nout = 3;

net = mlp(nin, 16, nout, 'logistic');
options = zeros(1, 18);
options(1) = 0;
options(14) = epochs;
options(17) = learning_rate;
[net, options] = netopt(net, options, feature, label, 'scg');

x2 = X(TRP+1:M, 1:5);
y2 = X(TRP+1:M, 7:9);
y = mlpfwd(net, x2);
[~, mxind] = max(y');
[~, mxind2] = max(y2');
accuracy = sum(double(mxind == mxind2)) / max(1, (M - TRP));

epoch_vec = (1:epochs)';
final_mse = mean((y(:) - y2(:)) .^ 2);
metric = zeros(epochs, 1) + final_mse;
endfunction

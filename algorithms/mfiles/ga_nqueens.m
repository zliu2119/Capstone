function [gens, best_hist] = ga_nqueens(N, pop_size, mut_rate, generations)
% Simple GA runner for the n-Queens problem (non-interactive).
% Returns generation indices and best fitness history.

% initialize population
pup = randi(N, pop_size, N);
fn_array = compute_fitness(pup, 'N');

best_hist = zeros(1, generations);
gens = 1:generations;

for ii = 1:generations
  [best_hist(ii), ~] = min(fn_array);
  pup = next_gen(pup, fn_array);
  if mut_rate > 0
    pup = mutation(pup, mut_rate);
  endif
  fn_array = compute_fitness(pup, 'N');
endfor

% capture final best fitness
[best_hist(end), ~] = min(fn_array);

endfunction

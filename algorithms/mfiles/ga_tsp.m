function [gens, best_hist] = ga_tsp(city_count, pop_size, mut_rate, generations)
% Simple GA runner for Traveling Salesman (non-interactive).
% Generates random cities and returns best distance history.

% build symmetric distance matrix from random coordinates
coords = rand(city_count, 2) * 100;
rdata = zeros(city_count, city_count);
for i = 1:city_count
  for j = i+1:city_count
    d = norm(coords(i,:) - coords(j,:));
    rdata(i,j) = d;
    rdata(j,i) = d;
  endfor
endfor

pup = build_pup_tsm(city_count, pop_size);
fn_array = fitness_tsm1(pup, rdata);

best_hist = zeros(1, generations);
gens = 1:generations;

for ii = 1:generations
  [best_hist(ii), ~] = min(fn_array);
  pup = tsm_next_gen(pup, fn_array);
  if mut_rate ~= 0
    pup = tsm_mutation(pup, mut_rate);
  endif
  fn_array = fitness_tsm1(pup, rdata);
endfor

[best_hist(end), ~] = min(fn_array);

endfunction

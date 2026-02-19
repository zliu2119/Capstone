%
%
%

n = 50;
 x = sort (rand (n,1) * 5 - 1);
 
 y = 1 + 0.05 * x1 + 0.1 * randn (size (x));
 F = [ones(n, 1), x ];
 [p, e_var, r, p_var, fit_var] = LinearRegression (F, y);
 yFit = F * p;

 figure ()
 plot(x, y, '+b', x, yFit, '-g',...
      x, yFit + 1.96 * sqrt (e_var), '--r',...
      x, yFit + 1.96 * sqrt (fit_var), '--k',...
      x, yFit - 1.96 * sqrt (e_var), '--r',...
      x, yFit - 1.96 * sqrt (fit_var), '--k')
 title ('straight line fit by linear regression')
 legend ('data','fit','+/-95% y values','+/- 95% fitted values','location','northwest')
 grid on
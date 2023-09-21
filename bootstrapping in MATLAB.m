% From our linear model, we want to bootstrap the confidence intervals of the coefficient of our linear models (see the regression file in this repository)

% First I'll read in the data. I read in each of the groups' (exp status column) re78 data as two
% separate vectors
% 0 or non participants = Lalonde;
% 1 or NSW participants = Lalonde1; 

% The x axis will be 0 and 1, for each group
x = [0,1]

% The y axis values are the means of the two groups
y = [mean(grp_0), mean(grp_1)]

% This plot will show the means, also the poly functions below won't allow
% for x and y to be vectors of different dimensions. So, y means across x seem 
% like a good measure to work with

n = 1; % degree(s) of x
% because it's a linear relationship, x is only a ONE degree polynomial
% hence "1"

p = polyfit(x, y, n);
% polyfit returns [p,S] the least squares polynotmial coefficient (i.e. the slope; p) and the error estimation (i.e. the y intercept; S)
% To call for the value of the slope, i.e. the coefficient for the treatment variable slope = p(1);
% This coefficient fits nicely with my earlier R linear regression output

% n per sample, matching the data given
n_samp0 = 260;
n_samp1 = 185;

n_reps = 5000; % number of reps

bootslopes = zeros(n_reps,1); % a place to store the bootstrapped slope values

for i = 1:n_reps
    x1 = randsample(grp_0, n_samp0, true); % replicate the no treatment data with replacement
    x2 = randsample(grp_1, n_samp1, true); % replicate the treatment data with replacement

    bootmean = [mean(x1) mean(x2)];
    p = polyfit(x, bootmean, 1);
    bootslopes(i) = p(1); % the bootstrapped slopes are stored here
    bootf = polyval(p,x); % this gives me the predicted y values, based on the 
    % best model for the bootstrapped sample
    hh = plot(x,bootf,'-', 'color', 'r');
    % Now I'm plotting the bootstrapped slopes and y intercepts against the
    % data and the linear model I came up with for it
    hh.Color(4) = 0.01;
    %        ^ The default hh line handle created doesn't have a fourth property by
    % default, but MATLAB will read it as the opacity.
    % Setting it to 0.01 will make each line cuper light, so I can see where 
    % they stack up on top of each other, which lines are most common
    % (In the console, where it says "hh = line with properties:
    % note the next line, "Color" by default only has three properties, i.e.
    % three values in its brackets)
    
    % drawnow % draws the plot in real time rather than waiting for the code
    % to run completely and then display the figure
    hold on % instead of doing something with (i) in the loop, I can just
    % use "hold" to keep the outputs of each iteration of the loop in the figure
end

x = [0,1]
y = [mean(grp_0), mean(grp_1)]
plot(x, y,'color', 'black')

hold off

histogram(bootslopes, 'FaceColor', 'r')
xline(quantile(bootslopes, [.975]),'--k');
xline(quantile(bootslopes, [.025]),'--k');

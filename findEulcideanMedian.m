function   median  =  findEulcideanMedian (f, w)

%  f is a matrix of size k^2 x S^2, where k^2 is the size
%  of the patch, and S^2 is the number of neighbors
%
%  w is the weight vector of size S^2 X 1
%
%  median = arg min_f  \sum_j w(j) || f(:, j) - g(:) ||_2
%
%  median is found using the IRLS alogrithm
%
%  Reference:
% "Iteratively Reweighted Algorithms for Compressive Sensing",
%  Rick Chartrand and Wotao Yin

% initialization using Euclidean mean
f_old = (f * w) / sum(w);
n    = length(w);
eps  = 1;

% loop
while eps > 1e-4
    gamma = 1./sqrt( sum((f_old * ones(1,n) - f).^2,1)  ...
        + eps^2 * ones(1,n) );
    ww       = gamma' .* w;
    f_new    = (f * ww) / sum(ww);
    if norm(f_new - f_old) < sqrt(eps) / 100
        eps = eps/10;
    end
    f_old = f_new;
    
end

% Euclidean median
median = f_new;



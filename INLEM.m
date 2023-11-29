function  imgDenoised  =   INLEM(imgNoisy, h, P, S)

% Image denoising using Improved Non-Local Euclidean Medians (INLEM)
%
% ImgNoisy : noisy image
% h        : Gaussian width
% P        : half-size of patch (e.g., P = 3)
% S        : half-search window (e.g., S = 10)
%
% imgDenoised : image denoised using INLEM
%
% Reference:
% Z. Sun and S. Chen. "Analysis of Non-Local Euclidean Medians and Its Improvement", IEEE Signal Processing Letters, vol.20, no.4, 2013.



%
% The code is modified from: K. N. Chaudhury, A. Singer, "Non-Local Euclidean Medians", IEEE Signal Processing Letters, vol. 19, no. 11, 2012.



[m, n] = size(imgNoisy);

N  = 2*P + 1;




imgPad  = padarray(imgNoisy, [P P], 'symmetric');

imgDenoised = zeros(m,n);

fprintf('Looping over pixels ...\n');

for i = 1 : m
    waitbar(i/m);
    ii = i + P;
    for j = 1 : n
        jj = j + P;
        
        patchRef = imgPad(ii - P : ii + P, jj - P : jj + P); %% %#ok<PFBNS>
        
        pmin = max(i - S, 1) + P;
        qmin = max(j - S, 1) + P;
        pmax = min(i + S, m) + P;
        qmax = min(j + S, n) + P;
        
        s1 = pmax - pmin + 1;
        s2 = qmax - qmin + 1;
        
        w  =  zeros(s1, s2);
        neighborPatches =  zeros(s1, s2, N^2);
        
        u = 0;
        for p = pmin : pmax
            u = u + 1;
            v = 0;
            for q = qmin : qmax
                v = v + 1;
                patchCurrent = imgPad(p - P : p + P, q - P : q + P);
                
%                 d2 = sum(sum( (patchRef .* kernel - patchCurrent .* kernel) ...
%                     .* (patchRef .* kernel - patchCurrent .* kernel) ));
                
                d2 = sum(sum( (patchRef - patchCurrent) ...
                .* (patchRef - patchCurrent) ));
                
                

                 w(u, v)  =  exp(- sqrt(d2) /4/ h);
                
                
                
                          neighborPatches(u, v, :) = reshape(patchCurrent, [N^2  1]);
            end
        end
        
        w  =  reshape(w, [s1*s2  1]);
        f       =  reshape(neighborPatches, [s1*s2   N^2])';
        median  =  findEulcideanMedian(f, w);        % Euclidean median
        patch_est  = reshape(median, [N N]);
        imgDenoised(i, j) = patch_est(P + 1, P + 1); % assign center pixel      
                
                
                
                
%                 neighborPatches(u, v, :) = reshape(patchCurrent .* kernel, [N^2  1]);
%             end
%         end
%         
%         w  =  reshape(w, [s1*s2  1]);
%         f       =  reshape(neighborPatches, [s1*s2   N^2])';
%         median  =  findEulcideanMedian(f, w);        % Euclidean median
%         patch_est  = reshape(median, [N N]) ./ kernel;
%         imgDenoised(i, j) = patch_est(P + 1, P + 1); % assign center pixel


    end
end

clear
warning off; 

ima=imread('testpat1.png');
if length(size(ima))>2
    ima=rgb2gray(ima);
end
ima=imresize(ima,[256 256]);


sumpoints=256*256;

ima=double(ima);

gausigma=50

gima=ima+gausigma*randn(size(ima));
rima=uint8(gima);

rima=double(rima);
In_MSE=sum(sum((rima-ima).*(rima-ima)))/(sumpoints);
In_PSNR=10*log10(255^2/In_MSE)

In_ssim=ssim(rima, ima);

% NLMED1  (Ours: 借助Kunal的程序实现更有说服力  h2=4h，不加权，论文实际采用)

[fima]=INLEM(rima, gausigma, 3, 10);
%

fima=double(fima);
NLMED1_MSE=sum(sum((fima-ima).*(fima-ima)))/sumpoints;
NLMED1_PSNR=10*log10(255^2/NLMED1_MSE)

NLMED1_ssim=ssim(fima, ima)



    



warning on;
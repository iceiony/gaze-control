% aproximate one dimensional results with RBF network 
clear all;
close all;

UNIT_COUNT = 50;
NOISE = 1;

fig = figure();

T = peaks(25);
%add noise 
T = T + rand(size(T)) * NOISE;
subplot(1,2,1);
surf(T);
colormap(jet);
title('target (25*25 points)');

[x,y] = meshgrid(1:size(T,1),1:size(T,2));
X = [y(:) x(:)];

% train the gaussians weights
[idx,mu,~,d] = kmeans(X,UNIT_COUNT);
sigma = var(d).^(1/9);

for j=1:size(mu,1)
    mu_all = repmat(mu(j,:),length(X),1);
    distance = sum((X' - mu_all').^2);
    phi(j,:) = exp(- distance' / (2*sigma(j).^2));
end

phi = phi';
phi = [ones(size(phi,1),1) phi];

%train output layer weigts 
V = pinv(phi) * T(:);

%plot the output for another input set
[x,y] = meshgrid(1:0.5:size(T,1),1:0.5:size(T,2));
X = [y(:) x(:)];

phi = [];

for j=1:size(mu,1)
    mu_all = repmat(mu(j,:),length(X),1);
    distance = sum((X' - mu_all').^2);
    phi(j,:) = exp(- distance' / (2*sigma(j).^2));
end

phi = phi';
phi = [ones(size(phi,1),1) phi];

Y = phi * V;
Y =  reshape(Y,size(x,1),size(y,1)) ;

subplot(1,2,2);
surf(Y);
colormap(jet);
title(sprintf('output (%d hidden units)',length(mu)));
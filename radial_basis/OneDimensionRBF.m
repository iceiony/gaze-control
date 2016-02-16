% aproximate one dimensional results with RBF network 
clear all;
close all;

UNIT_COUNT = 8;
NOISE = 0.5;

fig = figure();

X = -1:.1:1;
T = [-.9602 -.5770 -.0729  .3771  .6405  .6600  .4609 ...
      .1336 -.2013 -.4344 -.5000 -.3930 -.1647  .0988 ...
      .3072  .3960  .3449  .1816 -.0312 -.2189 -.3201];

%add noise
T = T + rand(1,length(T))*NOISE;
  
X = X';
T = T';

plot(X,T,'*');
hold on;

%train the gaussians weights
[idx,mu,~,distance] = kmeans(X,UNIT_COUNT);
sigma = var(distance).^(1/9);

for j=1:size(mu,1)
    phi(j,:) = exp(- (X-mu(j)).^2 / (2*sigma(j).^2));
end
phi = phi';
phi = [ones(size(phi,1),1) phi];

%train output layer weigts 
% omg = phi'*phi ;
% V = pinv(omg + 0.2 * eye(size(omg)) ) * phi' * T ; %regularisation
V = pinv(phi) * T;

%plot the output for another set of input
X = -1:.0125:1;
phi = [];
for j=1:size(mu,1)
    phi(j,:) = exp(- (X-mu(j)).^2 / (2*sigma(j).^2));
end
phi = phi';
phi = [ones(size(phi,1),1) phi];

Y =  phi * V ;

plot(X,Y,'r');

title(sprintf('%d hidden units',length(mu)));
legend('data points','network fit');
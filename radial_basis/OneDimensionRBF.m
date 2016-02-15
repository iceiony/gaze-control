% aproximate one dimensional results with RBF network 
clear all;
close all;

fig = figure();

X = -1:.1:1;
T = [-.9602 -.5770 -.0729  .3771  .6405  .6600  .4609 ...
      .1336 -.2013 -.4344 -.5000 -.3930 -.1647  .0988 ...
      .3072  .3960  .3449  .1816 -.0312 -.2189 -.3201];
X = X';
T = T';

% T = T - min(T) + 1;
  
plot(X,T,'*');
hold on;

%train the gaussians weights
[idx,mu,~,d] = kmeans(X,3 );
sigma = sqrt(var(d));

for j=1:size(mu,1)
    phi(j,:) = exp(- (X-mu(j)).^2 / (2*sigma(j).^2));
end
phi = phi';
phi = [ones(size(phi,1),1) phi];

%train output layer weigts 
% omg = phi'*phi ;
% V = pinv(omg + 0.2 * eye(size(omg)) ) * phi' * T ; 
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

xlabel('3 belief points');
legend('data points','network fit');
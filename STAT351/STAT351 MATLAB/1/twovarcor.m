function twovarcor(inputArg1,inputArg2)
%Generate correlated two variableswith normal distributions; 1- Plot data;
mu1    = 0;
sigma1 = 0.5;
mu2    = 0;
sigma2 = 0.5;
a3     = 0;
b3     = 1;
n = inputArg1;
Rho = [1.0  0.1  0.5;
0.1 1.0  -0.8;
0.5 -0.8  1.0];
Z = mvnrnd([0 0 0], Rho, n);
%1

figure(8);
 plot(Z(:,1), Z(:,2),'*');
xlim([-3.5 3.5]);
 ylim([-3.5 3.5]);
ylabel('Y value');
 xlabel('X value');
figure(9);
 plot(Z(:,1), Z(:,3),'*');
xlim([-3.5 3.5]);
 ylim([-3.5 3.5]);
ylabel('Y value');
 xlabel('X value');
figure(10);
 plot(Z(:,2), Z(:,3),'*');
xlim([-3.5 3.5]);
 ylim([-3.5 3.5]);
ylabel('Y value');
 xlabel('X value');
figure(11);
 plot(Z(:,1), Z(:,1),'*');
xlim([-3.5 3.5]);
 ylim([-3.5 3.5]);
ylabel('Y value');
 xlabel('X value');
end


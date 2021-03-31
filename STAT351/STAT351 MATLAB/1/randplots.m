function randplots(inputArg1,inputArg2)
%RANDPLOTS - creates two figures plotting output vals and histogram of input1 number of random points put in input2 number of bins.
%Generate and plot some random sample; 1- Uniform distribution; 2- Create a histogram ;   MKULTRA https://github.com/31415pi/Spring21_MCECS/

N=inputArg1;
%1
x=rand(1,N);
figure(1);
 plot(x,'b.', 'MarkerSize',10)
 ylabel('Observed output value');
 xlabel('Button push');
% 2
numbins=inputArg2;
figure(2);
hist(x,numbins);
xlim([0 1]);
ylabel('Number (Frequency) of values');
 xlabel('xvalue');
end


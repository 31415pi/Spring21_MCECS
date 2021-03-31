function freak_prop(inputArg1)
%FREAK_PROP Create Frequemcy and Proportion Populations on inputn number of
%samples.
% Generate and plot some random sample; Normal distribution; Create a histogram with Frequency;% Create a histogram with Proportion
%  MKULTRA https://github.com/31415pi/Spring21_MCECS/


N=inputArg1;
x=0.5+0.1*randn(1,N);
%
figure(3);
 plot(x, 'b.', 'MarkerSize',20);
 ylim([0 1]);
ylabel('Observed output value');
 xlabel('Button push');
%
figure(4);
histogram(x,'BinWidth',0.1);
 xlim([0 1]);
ylabel('Frequency (Number of values)');
 xlabel('x value');
%
figure(5);
 histogram(x,'Normalization', 'probability','BinWidth',0.1);
 xlim([0 1]);
ylabel('Fraction (Proportion) of values');
 xlabel('x value');

end


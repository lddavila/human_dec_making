function [fit_object_to_be_returned,gof_to_be_returned,type] = fit_sigmoid(x,y)
disp([x.',y.'])
[fitobject1, gof1]= fit(x.',y.','a*x+b');

[fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');
counter=0;
while gof2.rsquare <0 && counter <100
    [fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');
    counter = counter+1;
end
counter=0;
[fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
while gof3.rsquare <0 && counter <100
    [fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
end
counter=0;
[fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
while gof4.rsquare <0 && counter <100
    [fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
end

[fitobject5, gof5] = fit(x.',y.','a*(x-b)^(2)+c');

if gof3.rsquare >= .6
    plot(fitobject3,x.',y.')
    fit_object_to_be_returned = fitobject3;
    gof_to_be_returned=gof3;
    type = "3 param sigmoid";
elseif gof4.rsquare >= .6
    fit_object_to_be_returned = fitobject4;
    gof_to_be_returned=gof4;
    plot(fitobject4,x.',y.')
    type = "4 param sigmoid";
else
    % gof2.rsquare >= .6
    fit_object_to_be_returned = fitobject2;
    gof_to_be_returned=gof2;
    plot(fitobject2,x.',y.')
    type = "2 param sigmoid";
    % elseif gof1.rsquare > gof5.rsquare
    %     fit_object_to_be_returned = fitobject1;
    %     gof_to_be_returned=gof1;
    %     plot(fitobject1,x.',y.')
    %     type = "Linear";
    % elseif gof5.rsquare > gof1.rsquare
    %     fit_object_to_be_returned = fitobject5;
    %     gof_to_be_returned=gof5;
    %     plot(fitobject5,x.',y.')
    %     type = "Parabolic";
end

end
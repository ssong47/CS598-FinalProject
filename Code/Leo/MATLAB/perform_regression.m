function [yp, mdl] = perform_regression(X, Y)
    mdl = fitlm(X,Y, 'linear');
    yp = predict(mdl, X);
end
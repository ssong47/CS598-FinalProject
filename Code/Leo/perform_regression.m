function [yp, mdl] = perform_regression(X, Y)
    mdl = fitlm(X,Y)
    yp = predict(mdl, X);
end
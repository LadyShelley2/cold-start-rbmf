function value = goal(Y,C,X,lambda)
    C*X;
    Y-C*X;
    (Y-C*X).^2;
    X.^2;
    value = 1.0/2*sum(sum((Y-C*X).^2))+lambda/2*sum(sum(X.^2));
end
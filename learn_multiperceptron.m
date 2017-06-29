function [W,b,E] = learn_multiperceptron(Pmat,Kmat,Tmax)
    N = size(Kmat,2);
    K = size(Pmat,2);

    W = [randn(N,K)/N;zeros(1,K)];
    X = [Kmat,ones(N,1)];
    
    E = zeros(Tmax,1);
    for t=1:Tmax
        %disp(t);
        WX = X*W;
        maxWX = max(WX')';
        P = exp(WX-repmat(maxWX,[1,K]));
        sumP = sum(P')';
        P = P ./ repmat(sumP,[1,K]);
        E(t) = -mean(mean(Pmat.*log(P+1e-10),2));
        disp(E(t));
        dEdW = -X'*(Pmat-P)/(K*N);
        W  = W-1e-8*dEdW;
    end
    b = W(N+1,:);
    W = W(1:N,:);
end
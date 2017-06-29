function Y = isomap_from_dist(D,K,d)
    N = size(D,1);
    
    W = inf*ones(N,N);
    A = zeros(N,N);
    
    for i = 1:N
        disp(i);
        [aux,idx] = sort(D(i,:));
        for k = 2:K+1
            W(i,idx(k)) = aux(k);
            A(i,idx(k)) = 1;
            A(idx(k),i) = 1;
        end
    end
    
    D_ = floyd_warshall(min(W,W'));
    J = eye(N)-ones(N,N)/N;
    [Y,E] = eig(-0.5*J*(D_.^2)*J);
    Y = Y(:,2:d+1);
end
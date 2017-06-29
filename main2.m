J0 = @(A) 1.0-A/pi;
J1 = @(A) (sin(A)+(pi-A).*cos(A))/pi;
J2 = @(A) (3*sin(A).*cos(A)+(pi-A).*(1+2.0*cos(A).^2))/pi;

M = load('mnist_all.mat');

sN = 200;
tN = 200;
L = 1;
J = J2;
N = 2;

X  = [];
for d=0:9
    dirname = strcat('train',int2str(d));
    X  = [X; double(M.(dirname)(1:sN,:))-0.5]; 
end
CX = kron((0:9)',ones([sN,1]));
PX = kron(eye(10),ones([sN,1]));

mX = mean(X,1);
X_c = X - repmat(mX,[size(X,1),1]);

KX = zeros([size(X,1),size(X,1)]);
for i = 1:size(X,1)
    disp(i);
    for j = i:size(X,1)
        KX(i,j) = kernel(X_c(i,:),X_c(j,:),L,N,J);
        KX(j,i) = KX(i,j);
    end
end

[W,b,E] = learn_multiperceptron(PX,KX,3000);



figure;
plot(E);

D = sqrt(repmat(diag(KX),[1,size(X,1)])+repmat(diag(KX)',[size(X,1),1])-2.0*KX);
D = D / max(max(D));

figure;
imshow(D);

Z = isomap_from_dist(D,5,3);

figure;
for i = 0:9
    disp(i);
    idx = (CX == i);
    scatter3(Z(idx,1),Z(idx,2),Z(idx,3),7,CX(idx),'filled','MarkerEdgeColor','k','DisplayName',int2str(i));
    if i == 0
        hold on;
    end
end
colormap(jet);
legend(gca,'show');
hold off;

A = [W;b]';
A = (A-min(min(A)))/(max(max(A))-min(min(A)));
figure;
imshow(kron(A,ones([10,1])));

WX = [KX,ones(size(KX,1),1)]*[W;b];
maxWX = max(WX,[],2);
P = exp(WX-repmat(maxWX,[1,size(PX,2)]));
sumP = sum(P,2);
P = P ./ repmat(sumP,[1,size(PX,2)]);

[a,idx] = max(PX,[],2);
[a,jdx] = max(P,[],2);
disp(100.0*mean(idx==jdx));

Y  = [];
for d=0:9
    dirname = strcat('test',int2str(d));
    Y  = [Y; double(M.(dirname)(1:tN,:))-0.5]; 
end
CY = kron((0:9)',ones([tN,1]));
PY = kron(eye(10),ones([tN,1]));

Y_c = Y - repmat(mX,[size(Y,1),1]);

KY = zeros(size(Y,1),size(KX,2));
for i = 1:size(Y,1)
    disp(i);
    for j = 1:size(KX,2)
        KY(i,j) = kernel(Y_c(i,:),X_c(j,:),L,N,J);
    end
end

WY = [KY,ones(size(KY,1),1)]*[W;b];
maxWY = max(WY,[],2);
P = exp(WY-repmat(maxWY,[1,size(PY,2)]));
sumP = sum(P,2);
P = P ./ repmat(sumP,[1,size(PY,2)]);

[a,idx] = max(PY,[],2);
[a,jdx] = max(P,[],2);
disp(100.0*mean(idx==jdx));

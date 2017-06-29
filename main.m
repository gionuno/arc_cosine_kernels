J0 = @(A) 1.0-A/pi;
J1 = @(A) (sin(A)+(pi-A).*cos(A))/pi;
J2 = @(A) (3*sin(A).*cos(A)+(pi-A).*(1+2.0*cos(A).^2))/pi;

L = 1;
J = J1;
N = 1;

w = 8;
DIR = dir('coil_100');
X = [];
C = [];
for i = 3:length(DIR)
    dirname = strcat('coil_100/',DIR(i).name);
    AUX_DIR = dir(dirname);
    for j = 3:length(AUX_DIR)        
        auxfilename = strcat(dirname,'/',AUX_DIR(j).name);
        aux = double(imread(auxfilename))/255.0;
        mean_aux  = zeros([size(aux,1)/w,size(aux,2)/w,size(aux,3)]);
        d = size(mean_aux);
        kk = 1;
        ll = 1;
        for k = 1:w:size(aux,1)
            ll = 1;
            for l = 1:w:size(aux,2)
                aux3 = aux(k:k+w-1,l:l+w-1,:);
                mean_aux(kk,ll,:)  = mean(mean(aux3));
                ll = ll + 1;
            end
            kk = kk + 1;
        end
        %d = size(aux2);
        X = [X ; reshape(mean_aux,[1,numel(mean_aux)])];
        C = [C ; i-3];
    end
end

mX = mean(X,1);
X_c = X - repmat(mX,[size(X,1),1]);
%X_c = X_c ./ (repmat(sqrt(sum(X_c.^2,2)),[1,size(X,2)])+1e-10);

K = zeros(size(X,1),size(X,1));
for i = 1:size(X,1)
    disp(i);
    for j = i:size(X,1)
        K(i,j) = kernel(X_c(i,:),X_c(j,:),L,N,J);
        K(j,i) = K(i,j);
    end
end

D = sqrt(repmat(diag(K),[1,size(X,1)])+repmat(diag(K)',[size(X,1),1])-2.0*K);
D = D/max(max(D));

figure;
imshow(D);

Y = isomap_from_dist(D,50,3);

figure;
for i = 3:length(DIR)
    disp(DIR(i).name);
    idx = (C == i-3);
    scatter3(Y(idx,1),Y(idx,2),Y(idx,3),7,C(idx),'filled','MarkerEdgeColor','k','DisplayName',DIR(i).name);
    if i == 3
        hold on;
    end
end
colormap(colorcube);
legend(gca,'show');
hold off;
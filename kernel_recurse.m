function k = kernel_recurse(x,y,l,n,J)
    nxny  = 0.0;
    xty = 0.0;
    a   = 0.0;
    if l == 1
        nxny= sqrt(sum(x.^2)*sum(y.^2));
        xty = sum(x.*y);
    elseif l > 1
        nxny= real(sqrt(kernel_recurse(x,x,l-1,n,J)*kernel_recurse(y,y,l-1,n,J)));
        xty = real(kernel_recurse(x,y,l-1,n,J));
    end
    a   = acos(xty/(nxny));
    k   = real((nxny)^n*J(a));
end
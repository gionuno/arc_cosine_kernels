function k = kernel(x,y,l,n,J)
    k = real(kernel_recurse(x,y,l,n,J));
end
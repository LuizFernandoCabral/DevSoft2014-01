def fat n
return 1 if (n==1)
return n*fat(n-1)
end
print fat 20


sample([1 2 3 4], [0.2 0.1 0.1 0.6]);





gwinit(1) %initilize world/state


getdiams = gwstate() %get the worldinfo
getdiams


matr = ones(1); %length is maximum 
alpha = 0.3;
gamma = 0.9;




Q = [getdiams.pos(1) getdiams.pos(2) 3; 1 1 1; 2 2 2 ; 3 3 3];
Q(1,2,:);


%%

for i=1:100
    act = sample([1 2 3 4], [0.25 0.25 0.25 0.25]);
    gwaction(act)
    gwdraw()

end


%%

[a, oa] = chooseaction(Q, 1, 2, [1 2 3 4], [1 1 1 1], 0.5)


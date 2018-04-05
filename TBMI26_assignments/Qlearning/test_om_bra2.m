gwinit(4)
stat = gwstate();
pos_prev = stat.pos;
eps = 0.1;
a_prev = chooseaction(look_up, pos_prev(1), pos_prev(2), [1 2 3 4], [1 1 1 1], eps);
gwdraw()
%%
step=0
isTerminal = stat.isterminal;
while isTerminal == false
step = step + 1;
[a, oa] = chooseaction(look_up, pos_prev(1), pos_prev(2), [1 2 3 4], [1 1 1 1], eps);

act = gwaction(a);


state = gwstate();
pos = state.pos;
isTerminal = state.isterminal;
pos_prev = pos;
state_prev = state;
a_prev = a;

gwdraw()
pos_prev

end

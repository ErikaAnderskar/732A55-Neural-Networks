gwinit(4)
state = gwstate()
pos_prev = state.pos;
eps = 0;
isTerminal = 0;
gwdraw()

%%

while isTerminal == false

[a, oa] = chooseaction(look_up, pos_prev(1), pos_prev(2), [1 2 3 4], [1 1 1 1], 0.2);

act = gwaction(a);

state = gwstate();
pos = state.pos;

pos_prev = pos;
state_prev = state;

isTerminal = state.isterminal();
gwdraw()

end
gwplotallarrows(look_up)

%%

gwplotallarrows(look_up)






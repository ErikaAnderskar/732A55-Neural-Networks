gwinit(3)
state = gwstate()
pos_prev = state.pos;
eps = 0;
isTerminal = 0;
gwdraw()



while isTerminal == false
%r = state.feedback;
%Q_prev = look_up(pos_prev(1),pos_prev(2),a_prev);
%gwplotarrow(pos_prev, a_prev)
%a = sample([1 2 3 4], [0.25 0.25 0.25 0.25])
[a, oa] = chooseaction(look_up, pos_prev(1), pos_prev(2), [1 2 3 4], [1 1 1 1], 0.1);

act = gwaction(a);
%r = act.feedback;
state = gwstate();
pos = state.pos;

%look_up(pos_prev(1), pos_prev(2), a) = ((1-alpha)*Q_prev)+alpha*(r+gamma*max(look_up(pos(1), pos(2), :)));

%var(step) = a;
pos_prev = pos;
state_prev = state;
a_prev = a;
isTerminal = state.isterminal();
gwdraw()

end


%%








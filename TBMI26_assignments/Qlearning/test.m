
%%
%Initilize world/state
gwinit(4);
state_prev = gwstate()
pos_prev = state_prev.pos;
% Initilize lookup table/Qmatrix
look_up = ones(10,15,4)*(-1);

% init values
eps = 0.9;
a_prev = chooseaction(look_up, pos_prev(1), pos_prev(2), [1 2 3 4], [1 1 1 1], eps);
alpha = 0.5;
gamma = 0.5;


var = [];

gwdraw()

%%
look_up(10,:,1) = -100 %init lowest row to -100 for action down
look_up(1,:,2) = -100 %init highest row to -100 for action up
look_up(:,15,3) = -100 %init right row to -100 for action right
look_up(:,1,4) = -100 %init left row to -100 for action left


%%


for epoch = 1:4000
gwinit(4);
state_prev = gwstate();
pos_prev = state_prev.pos;
isTerminal = state_prev.isterminal();
step = 0;
%epoch
while isTerminal == false
step = step + 1;
%r = state.feedback;
Q_prev = look_up(pos_prev(1),pos_prev(2),a_prev);

%a = sample([1 2 3 4], [0.25 0.25 0.25 0.25])
[a, oa] = chooseaction(look_up, pos_prev(1), pos_prev(2), [1 2 3 4], [1 1 1 1], eps);
act = gwaction(a);

% If the robot bumps into a wall --> change action 
while act.isvalid ~= 1 
    [a, oa] = chooseaction(look_up, pos_prev(1), pos_prev(2), [1 2 3 4], [1 1 1 1], eps);
    act = gwaction(a);
end

r = act.feedback;
state = gwstate();
pos = state.pos;
isTerminal = state.isterminal();

look_up(pos_prev(1), pos_prev(2), a) = ((1-alpha)*Q_prev)+alpha*(r+gamma*max(look_up(pos(1), pos(2), :)));

var(step) = a;
pos_prev = pos;
state_prev = state;
a_prev = a;

%gwdraw()
%if 
%    break
%end

end

if mod(epoch, 3900) == 0
    eps = eps - 0.6
end


end
%%



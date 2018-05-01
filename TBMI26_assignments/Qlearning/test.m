
%%
%Initilize world/state
world = 4;
gwinit(world);
state_prev = gwstate()
pos_prev = state_prev.pos;
% Initilize lookup table/Qmatrix
look_up = ones(10,15,4).*(-0.9);

% init values
eps = 0.9;
a_prev = chooseaction(look_up, pos_prev(1), pos_prev(2), [1 2 3 4], [1 1 1 1], eps);
alpha = 0.25;
gamma = 0.9;

trains = 5000;

gwdraw()

%%
look_up(10,:,1) = -100 %init lowest row to -100 for action down
look_up(1,:,2) = -100 %init highest row to -100 for action up
look_up(:,15,3) = -100 %init right row to -100 for action right
look_up(:,1,4) = -100 %init left row to -100 for action left
%%

tic
for epoch = 1:trains
gwinit(world);
state_prev = gwstate();
pos_prev = state_prev.pos;
isTerminal = state_prev.isterminal();
step = 0;

while isTerminal == false
step = step + 1;

[a, oa] = chooseaction(look_up, pos_prev(1), pos_prev(2), [1 2 3 4], [1 1 1 1], eps);
Q_prev = look_up(pos_prev(1),pos_prev(2),a);

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

pos_prev = pos;
state_prev = state;
a_prev = a;

end

if mod(epoch, trains - (trains/10)) == 0
    eps = eps - 0.6;
end


if mod(epoch, 1000) == 0
    epoch
end


end

toc
%%



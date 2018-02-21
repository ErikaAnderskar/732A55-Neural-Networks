
%%
%Initilize world/state
gwinit(1);
state_prev = gwstate()
pos_prev = state_prev.pos
% Initilize lookup table/Qmatrix
look_up = zeros(10,15,4);

% init values
a_prev = 1;
alpha = 0.3;
gamma = 0.9;

var = []
%%


for epoch = 1:10000
state_prev = gwstate();
pos_prev = state_prev.pos;

for step = 1:500
%r = state.feedback;
Q_prev = look_up(pos_prev(1),pos_prev(2),a_prev);

%a = sample([1 2 3 4], [0.25 0.25 0.25 0.25])
[a, oa] = chooseaction(look_up, pos_prev(1), pos_prev(2), [1 2 3 4], [1 1 1 1], 0.5);
 % V�LJA AAAAAAA INTE OA!!!
act = gwaction(oa);
r = act.feedback;
state = gwstate();
pos = state.pos;

look_up(pos_prev(1), pos_prev(2), a) = ((1-alpha)*Q_prev)+alpha*(r+gamma*max(look_up(pos(1), pos(2), :)));

var(step) = oa;
pos_prev = pos;
state_prev = state;
a_prev = oa;

gwdraw()
if state.isterminal ==1
    break
end
end
if mod(epoch, 1) == 0
    gwdraw()
end

gwinit(1);
end
%%





%%

%Sample nr for action that moves the robot, 1=down, 2=up, 3=right and 4=left
a = sample([1 2 3 4], [0.2 0.1 0.1 0.6])

act = gwaction(a);

r = act.feedback

state = gwstate()


%%
look_up(state.pos(1),state.pos(2),k) = r

%%

k = sample([1 2 3 4], [0.2 0.1 0.1 0.6])

act = gwaction(k);

%%
r = act.feedback

state2 = gwstate()

next_state = state2.pos

%%
look_up(state.pos(1),state.pos(2),k) = r


%%

% test choose action

[a, oa] = chooseaction(look_up, pos_prev(1), pos_prev(2), [1 2 3 4], [1 1 1 1], 0.5);


%%

for i=1:300
    [a, oa] = chooseaction(look_up, pos_prev(1), pos_prev(2), [1 2 3 4], [1 1 1 1], 0.5);
    look_up(pos_prev(1), pos_prev(2), a) = ((1-alpha)*Q_prev)+alpha*(r+gamma*max(look_up(pos(1), pos(2), :)));
    gwaction(a);
    state = gwstate();
    pos_prev = state.pos;
    gwdraw()
end
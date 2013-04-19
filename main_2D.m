%% define shape to register
polyshape = [100, 100; 120, 120; 150, 100];	% units are mm, say
origin = mean(polyshape,1);
origintfm = [1, 0, origin(1); 0, 1, origin(2); 0, 0, 1];

%% define point set
npoints = 5;
%truepointset = randompointset(polyshape, npoints);
truepointset = polyshape;
acqpointset = truepointset;

%% simulate initial estimate
maxtransoffset = 10; % mm
maxrotoffset = 10; % degrees

rtr = unitise((rand(2,1)*2)-1)*maxtransoffset;
transtfm = [1, 0, rtr(1); 0, 1, rtr(2); 0, 0, 1];

rangle = ((rand*2)-1)*maxrotoffset;
rottfm = [cosd(rangle), -sind(rangle), 0; sind(rangle), cosd(rangle), 0;...
	0, 0, 1];

% generate initial estimate
initialtfm = origintfm * transtfm * rottfm * inv(origintfm);

regtfm = initialtfm;
regpointset = transformpoints(acqpointset, regtfm);
regshape = transformpoints(polyshape, regtfm);

%% plot
margin = 15;
figure(1);
clf
hold on
grid on
axis equal
xlim([min(polyshape(:,1))-margin, max(polyshape(:,1))+margin]);
ylim([min(polyshape(:,2))-margin, max(polyshape(:,2))+margin]);

% shape
hshape = plot([polyshape(:,1);polyshape(1,1)],...
	[polyshape(:,2);polyshape(1,2)],origin(1),origin(2),'+');

% true point set
htruepts = plot(truepointset(:,1),truepointset(:,2),...
	'o','markerfacecolor','g','markeredgecolor','none');

% reg point set
hregpts = plot(regpointset(:,1),regpointset(:,2),...
	'o','markerfacecolor','r','markeredgecolor','none');
set(hregpts,'xdatasource','regpointset(:,1)',...
	'ydatasource','regpointset(:,2)');

% closest point set
hclosepts = plot(closestpointset(:,1),closestpointset(:,2),...
	'o','markerfacecolor','m','markeredgecolor','none');
set(hclosepts,'xdatasource','closestpointset(:,1)',...
	'ydatasource','closestpointset(:,2)');

% reg shape
hregshape = plot([regshape(:,1);regshape(1,1)],...
	[regshape(:,2);regshape(1,2)],'r');
set(hregshape,'xdatasource','[regshape(:,1);regshape(1,1)]',...
	'ydatasource','[regshape(:,2);regshape(1,2)]');

linkdata off
pause(0.5)
%% register

% find transform that minimises rmse
[regtfm, currentrmse] = minrmse(regpointset,initialtfm,polyshape);

% update reg point set and shape
regpointset = transformpoints(acqpointset,regtfm);
regshape = transformpoints(polyshape,regtfm);

refreshdata

fprintf('The current RMSE is %f\n',currentrmse)
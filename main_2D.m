%% define shape to register
polyshape = [100, 100; 120, 120; 150, 100];     % units are mm, say
origin = mean(polyshape,1);
origintfm = [1, 0, origin(1); 0, 1, origin(2); 0, 0, 1];

%% define point set
npoints = 10;
truepointset = randompointset(polyshape, npoints);
acqpointset = truepointset;

%% simulate initial estimate
maxtransoffset = 0.5;                           % mm
maxrotoffset = 10;                              % degrees

rtr = unitise((rand(2,1)*2)-1)*maxtransoffset;
transtfm = [1, 0, rtr(1); 0, 1, rtr(2); 0, 0, 1];

rangle = ((rand*2)-1)*maxrotoffset;
rottfm = [cosd(rangle), -sind(rangle), 0; sind(rangle), cosd(rangle), 0;...
	0, 0, 1];

% generate initial estimate
initialtfm = origintfm*transtfm*rottfm*inv(origintfm);
initialpointset = transformpoints(acqpointset, initialtfm);

%% register initial estimate
regtfm = initialtfm;					% start at initial transform

% find set of closest points
[closestpointset, dists] = ...
    getclosestpointset(transformpoints(acqpointset, regtfm), polyshape);
rmse = sqrt(mean(dists.^2));

% find transform that minimises rmse

% set regtfm accordingly

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
plot([polyshape(:,1);polyshape(1,1)],[polyshape(:,2);polyshape(1,2)]);

% shape origin
plot(origin(1),origin(2),'o','markerfacecolor','b','markeredgecolor',...
	'none');

% true point set
plot(truepointset(:,1), truepointset(:,2), 'o','markerfacecolor','g',...
	'markeredgecolor','none');

% initial point set
plot(initialpointset(:,1), initialpointset(:,2), 'o','markerfacecolor','r',...
	'markeredgecolor','none');

% closest point set
plot(closestpointset(:,1), closestpointset(:,2), 'o','markerfacecolor','m',...
	'markeredgecolor','none');
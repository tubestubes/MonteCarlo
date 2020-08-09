clear
clc
nl = 20
Xrv1=RandomVariable('Sdistribution','normal','mean',0,'std',1);
Xrv2=RandomVariable('Sdistribution','normal','mean',0,'std',1);
Xrvset = RandomVariableSet('Cmembers',{'Xrv1','Xrv2'},'CXrv',{Xrv1,Xrv2});

% Add two parameters
Xthres = Parameter('value', 0);

% Define Input object
Xinput = Input('CXmembers',{Xrvset, Xthres},...
    'CSmembers',{'Xrvset','Xthres'});

Xmio=Mio('Sfile','rp31.m',...
    'Spath',pwd,...
    'Cinputnames',{'Xrv1' 'Xrv2' 'Xthres'}, ...
    'Coutputnames',{'out'},'Liostructure',true);
% Add the MIO object to an Evaluator object
Xevaluator=Evaluator('CXmembers',{Xmio},'CSmembers',{'Xmio'});

%% Preparation of the Physical Model
% Define the Physical Model
Xmod=Model('Xinput',Xinput,'Xevaluator',Xevaluator);

%%
% Construct the performance function
Xperfun=PerformanceFunction('Scapacity','out','Sdemand','Xthres','Soutputname','Vg1');

% Define a ProbabilisticModel
Xpm=ProbabilisticModel('Xmodel',Xmod,'XPerformanceFunction',Xperfun);

%% Define sampler and compute gradient
% compute gradient
Xgrad=Sensitivity.gradientFiniteDifferences('Xtarget',Xpm,'Coutputname',{'Vg1'});
Xls=LineSampling('Nlines',nl,'Xgradient',Xgrad);
%% Reliability Analysis
output=[]
for i=1:10
 Xpfls = Xpm.computeFailureProbability(Xls);
 output(end+1)=Xpfls.pfhat
end




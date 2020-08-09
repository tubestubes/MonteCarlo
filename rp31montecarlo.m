% correct answer = 1.80 *10^-4

clear
clc
Xrv1=RandomVariable('Sdistribution','normal','mean',0.0,'std',1.0);
Xrv2=RandomVariable('Sdistribution','normal','mean',0.0,'std',1.0);
Xrvset = RandomVariableSet('Cmembers',{'Xrv1','Xrv2'},'CXrv',{Xrv1,Xrv2});
ns = 1000000
% Add parameters
Xthres = Parameter('value', 0);

% Define Input object
Xinput = Input('CXmembers',{Xrvset, Xthres},...
    'CSmembers',{'Xrvset', 'Xthres'});

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

%% Define sampler used in the analysis
% The first sampler used in this analysis 
Xmc=MonteCarlo('Nsamples',ns,'Lintermediateresults',false);

%% Reliability Analysis with plain monte carlo
% Here we test different samplers
output=[]
for i=1:10
 Xpf = Xpm.computeFailureProbability(Xmc);
 output(end+1)=Xpf.pfhat
end
display(output)


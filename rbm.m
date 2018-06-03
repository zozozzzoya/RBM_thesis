% Version 1.000 
%
% Code provided by Geoff Hinton and Ruslan Salakhutdinov 
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our
% web page.
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.

% This program trains Restricted Boltzmann Machine in which
% visible, binary, stochastic pixels are connected to
% hidden, binary, stochastic feature detectors using symmetrically
% weighted connections. Learning is done with 1-step Contrastive Divergence.   
% The program assumes that the following variables are set externally:
% maxepoch  -- maximum number of epochs
% numhid    -- number of hidden units 
% batchdata -- the data that is divided into batches (numcases numdims numbatches)
% restart   -- set to 1 if learning starts from beginning 

% train/test X and Y - transposed masterMatrix!

inputRbm = masterMatrix;

%randomiza split

trainY = Y([1:37],:);
testY = Y([38:46],:);


epsilonw      = 0.1;   % Learning rate for weights 
epsilonvb     = 0.1;   % Learning rate for biases of visible units 
epsilonhb     = 0.1;   % Learning rate for biases of hidden units 
weightcost  = 0.0002;   
initialmomentum  = 0.5;
finalmomentum    = 0.9;

[numcases numdims]=size(inputRbm);

numhid = 800;
maxepoch = 20;
restart = 1;

if restart == 1
  restart=0;
  epoch=1;

% Initializing symmetric weights and biases. 
  vishid     = 0.1*randn(numdims, numhid);
  hidbiases  = zeros(1,numhid);
  visbiases  = zeros(1,numdims);

  poshidprobs = zeros(numcases,numhid);
  neghidprobs = zeros(numcases,numhid);
  posprods    = zeros(numdims,numhid);
  negprods    = zeros(numdims,numhid);
  vishidinc  = zeros(numdims,numhid);
  hidbiasinc = zeros(1,numhid);
  visbiasinc = zeros(1,numdims);
  batchposhidprobs=zeros(numcases,numhid,1);
end

for epoch = epoch:maxepoch,
 fprintf(1,'epoch %d\r',epoch); 
 errsum=0; 

%%%%%%%%% START POSITIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 data = inputRbm(:,:);

 % IT IS ALREADY SOFTMAXED. 
 % (Hinton, 2010 - practicle guide to training RBM) - section 13.1 (page13)
 poshidprobs = 1./(1 + exp(-data*vishid - repmat(hidbiases,numcases,1)));    
 batchposhidprobs(:,:)=poshidprobs;
 posprods    = data' * poshidprobs;
 poshidact   = sum(poshidprobs);
 posvisact = sum(data);
 
%%%%%%%%% END OF POSITIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 poshidstates = poshidprobs > rand(numcases,numhid);

%%%%%%%%% START NEGATIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 negdata = 1./(1 + exp(-poshidstates*vishid' - repmat(visbiases,numcases,1)));
 neghidprobs = 1./(1 + exp(-negdata*vishid - repmat(hidbiases,numcases,1)));    
 negprods  = negdata'*neghidprobs;
 neghidact = sum(neghidprobs);
 negvisact = sum(negdata); 

 %%%%%%%%% END OF NEGATIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 err= sum(sum( (data-negdata).^2 ));
 errsum = err + errsum;

  if epoch>5,
    momentum=finalmomentum;
  else
    momentum=initialmomentum;
  end;

%%%%%%%%% UPDATE WEIGHTS AND BIASES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  vishidinc = momentum*vishidinc + ...
               epsilonw*( (posprods-negprods)/numcases - weightcost*vishid);
  visbiasinc = momentum*visbiasinc + (epsilonvb/numcases)*(posvisact-negvisact);
  hidbiasinc = momentum*hidbiasinc + (epsilonhb/numcases)*(poshidact-neghidact);
  vishid = vishid + vishidinc;
  visbiases = visbiases + visbiasinc;
  hidbiases = hidbiases + hidbiasinc;

%%%%%%%%%%%%%%%% END OF UPDATES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

  fprintf(1, 'epoch %4i error %6.1f  \n', epoch, errsum);
  plot(epoch, errsum, '.'); hold on 
end;

outputsRbm = transpose(negdata);



trainX = outputsRbm([1:37],:);
testX = outputsRbm([38:end],:);


% overallError = loss(finClass, )
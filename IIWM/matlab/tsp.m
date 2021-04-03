function [lendist,dist] = tsp(img)
 % Given a contour find the path that goest through it all
 % approach travelling problem
 
  [Ycnt, Xcnt] = ind2sub(size(img), find(img));
  nStops = length (Xcnt);
  
  % Compute number of trips possible 2 by 2
  idxs = nchoosek(1:nStops,2);
  
  % Computing the distance between the 
  dist = hypot(Xcnt(idxs(:,1)) - Xcnt(idxs(:,2)), ...
             Ycnt(idxs(:,1)) - Ycnt(idxs(:,2)));
  lendist = length(dist);
    
  % Equality Constraints
  Aeq = spones(1:length(idxs)); % Adds up the number of trips
  beq = nStops;
  Aeq = [Aeq;spalloc(nStops,length(idxs),nStops*(nStops-1))]; % allocate a sparse matrix
  for ii = 1:nStops
    whichIdxs = (idxs == ii); % find the trips that include stop ii
    whichIdxs = sparse(sum(whichIdxs,2)); % include trips where ii is at either end
    Aeq(ii+1,:) = whichIdxs'; % include in the constraint matrix
  end
  beq = [beq; 2*ones(nStops,1)];
  
  % binary bounds
  intcon = 1:lendist;
  lb = zeros(lendist,1);
  ub = ones(lendist,1);
  
  % Optimizing
  opts = optimoptions('intlinprog','Display','off');
  [x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,[],[],Aeq,beq,lb,ub,opts);
  plot(Xcnt,Ycnt,'*b')
  segments = find(x_tsp); % Get indices of lines on optimal path
    lh = zeros(nStops,1); % Use to store handles to lines on plot
    lh = updateSalesmanPlot(lh,x_tsp,idxs,Ycnt,Xcnt);
    title('Solution with Subtours');
    tours = detectSubtours(x_tsp,idxs);
    numtours = length(tours); % number of subtours
    fprintf('# of subtours: %d\n',numtours);
    A = spalloc(0,lendist,0); % Allocate a sparse linear inequality constraint matrix
b = [];
while numtours > 1 % repeat until there is just one subtour
    % Add the subtour constraints
    b = [b;zeros(numtours,1)]; % allocate b
    A = [A;spalloc(numtours,lendist,nStops)]; % a guess at how many nonzeros to allocate
    for ii = 1:numtours
        rowIdx = size(A,1)+1; % Counter for indexing
        subTourIdx = tours{ii}; % Extract the current subtour
%         The next lines find all of the variables associated with the
%         particular subtour, then add an inequality constraint to prohibit
%         that subtour and all subtours that use those stops.
        variations = nchoosek(1:length(subTourIdx),2);
        for jj = 1:length(variations)
            whichVar = (sum(idxs==subTourIdx(variations(jj,1)),2)) & ...
                       (sum(idxs==subTourIdx(variations(jj,2)),2));
            A(rowIdx,whichVar) = 1;
        end
        b(rowIdx) = length(subTourIdx)-1; % One less trip than subtour stops
    end

    % Try to optimize again
    [x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,A,b,Aeq,beq,lb,ub,opts);
    
    % Visualize result
    lh = updateSalesmanPlot(lh,x_tsp,idxs,stopsLon,stopsLat);
    
    % How many subtours this time?
    tours = detectSubtours(x_tsp,idxs);
    numtours = length(tours); % number of subtours
    fprintf('# of subtours: %d\n',numtours);
    title('Solution with Subtours Eliminated');
    hold off
end

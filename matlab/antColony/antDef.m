classdef antDef < handle
    
    properties
        loc          % ant location
        xlim         % x-boundaries
        ylim         % y-boundaries
        foodloc      % location of food
        speed        % walking speed of ant
        vision       % distance ant can see other ants that he/she wants to befriend
        foodDesire   % desire for food (weighting term);
        friendDesire % desire for friends (weighting term);
        foundFood    %specified whether an ant has found food, and which location. 0 if havent found 
        maxAntsEating %maximum number of ants that can eat at a single food source
        randMovement % magnitude of small random movements; 
    end
    
    methods (Static)
        
        function getMove(antCurrent,antAll,dt)
            if abs(antCurrent.loc(1))>=1
                velocity=antCurrent.speed*[-1,0]*sign(antCurrent.loc(1)); %if Ant reaches boundary of domain, direct it in the opposite direction
            elseif abs(antCurrent.loc(2))>=1
                velocity=antCurrent.speed*[0,-1]*sign(antCurrent.loc(2)); %if Ant reaches boundary of domain, direct it in the opposite direction
            else
                nNearestFood=antCurrent.getClosestFoodDirection(antCurrent,antAll); %get normal vector in direction of food (if close enough)
                nNearestAnts=antCurrent.getClosestFriendsDirection(antCurrent,antAll); %get normal vector in direction of other ants (if close enough)
                
                vectorRandom=[rand(1,1)*2-1,rand(1,1)*2-1]; %get normal vector in random direction
                nRandom=vectorRandom/(norm(vectorRandom,2)); %normalize vectorRandom

                direction=antCurrent.foodDesire*nNearestFood+antCurrent.friendDesire*nNearestAnts+antCurrent.randMovement*nRandom; %add three vectors together (magnitude*direction) to get direction vector for ant movement
                ndirection=direction/norm(direction,2); %normalize direction vector
                velocity=antCurrent.speed*ndirection; %create velocity vector from direction vector

            end
            antCurrent.loc=antCurrent.loc+velocity*dt;
        end
        
        function [nNearestAnts]=getClosestFriendsDirection(antCurrent,antAll) %get normal vector in direction of nearest friends
            for i=1:length(antAll) %calculate position of all ants (antAll) relative to current ant (antCurrent)
                vectorAntDistance(i,:)=antAll(i).loc-antCurrent.loc; 
            end
            magnitudeAntDistance=(vectorAntDistance(:,1).^2+vectorAntDistance(:,2).^2).^(1/2); %obtain magnitude of each position vector
            magnitudeAntDistance=magnitudeAntDistance(magnitudeAntDistance>0,:); %extract magnitudes that do no include the currentAnt magnitude
            vectorNearbyAntDistance=vectorAntDistance(magnitudeAntDistance<=antCurrent.vision,:); %obtain position vector of ants in the 'vision' of the current ant  (i.e. nearby ants)
            numNearbyAnts=length(vectorNearbyAntDistance(:,1)); %obtain number of ants in the 'vision' of current ant (i.e. number of nearby ants)
            meanVectorNearbyAntDistance=[mean(vectorNearbyAntDistance(:,1)),mean(vectorNearbyAntDistance(:,2))]; %determine the mean vector of the nearby ants
            if numNearbyAnts==0 %if no nearby ants, direct ant to middle of plane
                meanVectorNearbyAntDistance=[(antCurrent.xlim(2)+antCurrent.xlim(1)),(antCurrent.ylim(2)+antCurrent.ylim(1))]/2-antCurrent.loc;
            end
            
            nNearestAnts=meanVectorNearbyAntDistance/norm(meanVectorNearbyAntDistance,2);%n is unit vector in the direction of meanVectorNearbyAntDistance (i.e. nearest friends)
            if norm(meanVectorNearbyAntDistance,2)<0.000001 %if vector is too small, do not divide by small number as in nNearestAnts
                nNearestAnts=meanVectorNearbyAntDistance;
            end
        end
        
        function [nNearestFood]=getClosestFoodDirection(antCurrent,antAll) %get normal vector in direction of nearest food
            vectorFoodDistance=antCurrent.loc-antCurrent.foodloc; %obtain distance from ant location to all food locations
            magnitudeFoodDistance=(vectorFoodDistance(:,1).^2+vectorFoodDistance(:,2).^2).^(1/2); %obtain magnitude of each food distance
            foodsourcenumber=find(magnitudeFoodDistance==min(magnitudeFoodDistance),1);
            locNearestFood=antCurrent.foodloc(foodsourcenumber,:); %find the minimum food location based on minimum magnitude
            vectorNearestFood=locNearestFood-antCurrent.loc; %get position vector from nearest food to ant location
            magnitudeNearestFood=norm(vectorNearestFood,2);  %obtain magnitude of position vector between the ant and nearest food
                        
            if antCurrent.foundFood>0 %if ant has found food, do nothing
                nNearestFood=vectorNearestFood/(magnitudeNearestFood); %n is unit vector in the direction of vectorNearestFood (i.e. nearest food)
            else
                if magnitudeNearestFood>antCurrent.vision %if ant is far from food, keep going toward food
                    nNearestFood=vectorNearestFood/(magnitudeNearestFood);
                elseif magnitudeNearestFood<=antCurrent.vision %if ant is close to food, count how many ants are already eating that food
                    % Comment out these three lines for assignment
                    antCurrent.foundFood=foodsourcenumber;
                    antCurrent.friendDesire=0;
                    nNearestFood=vectorNearestFood/(magnitudeNearestFood);

                    % CODE BELOW HERE
%                     numAntsEating=???;
%                     if numAntsEating < antCurrent.maxAntsEating %if less than maxAntsEating ants, go toward that food and eat it
%                         nNearestFood=???; %continue toward food
%                         antCurrent.foundFood=???;
%                         antCurrent.foodDesire=???;
%                         antCurrent.friendDesire=???;
%                     elseif numAntsEating >= antCurrent.maxAntsEating %if maxAntsEating or more ants, go away from food and search for food in other direction
%                         nNearestFood=???; %go in opposite direction
%                         antCurrent.foodloc(foodsourcenumber,:)=???;
%                     end
                end
            end
                                        
        end
    end
end
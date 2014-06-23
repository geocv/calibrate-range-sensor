function [pBefore,pAfter] = VisualiseResults( SensorTransformsBeforeXYZYPR, SensorTransformsAfterXYZYPR, DATA, COSTFUNS )

disp( 'offset before calibration (m/deg):' )
disp( [SensorTransformsBeforeXYZYPR(:,[1,2,3]), rad2deg( SensorTransformsBeforeXYZYPR(:,[6,5,4]) )] )
disp( 'offset after calibration (m/deg):' )
disp( [SensorTransformsAfterXYZYPR(:,[1,2,3]), rad2deg( SensorTransformsAfterXYZYPR(:,[6,5,4]) )] )
disp( 'offset difference:' )
SensorTransformsAfterXYZYPRDiff=SensorTransformsAfterXYZYPR-SensorTransformsBeforeXYZYPR;
disp( [SensorTransformsAfterXYZYPRDiff(:,[1,2,3]), rad2deg( SensorTransformsAfterXYZYPRDiff(:,[6,5,4]) )] ) 

nSensors = size(SensorTransformsBeforeXYZYPR,1);
nFeatures = size(DATA,1);

costsBefore = zeros( nSensors, nFeatures );
costsAfter = zeros( nSensors, nFeatures );
pBefore = cell(nFeatures,nSensors);
pAfter = cell(nFeatures,nSensors);
for( f=1:nFeatures )
    for( s=1:nSensors )
        pAfter{f,s} = [feval(DATA(f,s).GeoregisterFunction, DATA(f,s), SensorTransformsAfterXYZYPR(s,:) ) ];
        pBefore{f,s} = [feval(DATA(f,s).GeoregisterFunction, DATA(f,s), SensorTransformsBeforeXYZYPR(s,:) ) ];
        costsAfter(s,f) = feval(COSTFUNS{f}, pAfter{f,s});
        costsBefore(s,f) = feval(COSTFUNS{f}, pBefore{f,s});
    end
end

disp( 'costs before (sd m):' )
disp( sqrt(costsBefore) );
disp( 'costs after (sd m):' )
disp( sqrt(costsAfter) );
disp( 'cost difference (sd m):' )
disp( sqrt(costsAfter)-sqrt(costsBefore) );

disp( 'mean per feature before (sd m):' )
disp( mean( sqrt(costsBefore) ) );
disp( 'mean per feature after (sd m):' )
disp( mean( sqrt(costsAfter) ) );
disp( 'mean difference per feature (sd m)' );
disp( mean( sqrt(costsAfter) ) - mean( sqrt(costsBefore) ) );

disp( 'mean per sensor before (sd m):' )
disp( mean( sqrt(costsBefore') )' );
disp( 'mean per sensor after (sd m):' )
disp( mean( sqrt(costsAfter') )' );
disp( 'mean difference per sensor (sd m)' );
disp( mean( sqrt(costsAfter') )' - mean( sqrt(costsBefore') )' );

disp( 'mean cost all features before (sd m)' );
disp( mean( mean( sqrt(costsBefore) )) );
disp( 'mean cost all features after (sd m)' );
disp( mean( mean( sqrt(costsAfter) )) );
disp( 'mean cost difference all features (sd m)' );
disp( mean( mean( sqrt(costsAfter) ))-mean( mean( sqrt(costsBefore) )) );
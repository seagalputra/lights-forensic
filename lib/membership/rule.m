function predicted = rule(degreeCorrelation, degreeTheta)

degreeForgery = max(degreeCorrelation(2), degreeTheta(2));
degreeAuthentic = max(min(1-degreeCorrelation(2), 1-degreeTheta(2)), min(degreeCorrelation(1), degreeTheta(1)));

if (degreeForgery > degreeAuthentic)
    predicted = 0;
else
    predicted = 1;
end

end
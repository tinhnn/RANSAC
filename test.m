for i = 1:200
    x(i) = rand()*100;
    b = (rand()-0.5)*10;
    y(i) = 2*x(i) + b;
end

for i = 201:250
    x(i) = rand()*100;
    y(i) = rand()*200;
end

p = polyfit(x,y,1);
y_1 = polyval(p,x);

fitLineFcn = @(points) polyfit(points(:,1),points(:,2),1);
evalLineFcn = @(model, points) sum((points(:, 2) - polyval(model, points(:,1))).^2,2);
p = RANSAC([x', y'], fitLineFcn, evalLineFcn, 2, 20);
y_2 = polyval(p,x);

figure(1);
plot(x, y, 'o');
hold on;
plot(x, y_1);
plot(x, y_2, 'LineWidth', 1.5, 'Color', 'b');
hold off;
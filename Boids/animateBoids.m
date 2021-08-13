nsteps = size(X, 2)/2;

f = figure();
ax = nexttile;
axis(ax, [0 dims(1) 0 dims(2)]);
hold(ax, 'ON');
l = plot(ax, X(:, 1), X(:, 2), 'ko');

for k = 1:nsteps-1
    xk = X(:, (2*k + [1, 2]));
    l.XData = xk(:, 1);
    l.YData = xk(:, 2);
    pause(1/144)
end
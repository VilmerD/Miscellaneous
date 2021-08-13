% Constants
dims = [1, 1];
vmax = 3e-3;
cs = 4;
ca = 2;
cc = 2;
cd = 1e-5;

n = 60;
x = rand(n, 2).*dims;
v = 2*rand(n, 2) - 1;
v = vmax*v./sqrt(v(:, 1).^2 + v(:, 2).^2);
R = 0.05;

nsteps = 144*60;
k = 0;
X = [];
while k < nsteps
    % New direction
    ds = zeros(n, 2);
    
    xt = x';
    dxmat = repmat(x, 1, n);
    dx = dxmat - xt(:)';
    r = sqrt(dx(:, 1:2:end).^2 - dx(:, 2:2:end).^2);
    far = logical(kron(r > R, [1, 1]));
    nclose = sum(~far, 2);
    
    dxclose = dx;
    dxclose(far) = 0;
    
    % Separation
    rclose = [sum(dxclose(:, 1:2:end), 2), sum(dxclose(:, 2:2:end), 2)];
    rcloseL = sqrt(rclose(:, 1).^2 + rclose(:, 2).^2);
    rcloseL(rcloseL == 0) = 1;
    vsep = rclose.*rcloseL.^(-2);
    ds = ds - vsep*cs;
    
    % Alignment
    vclose = repmat(v, 1, n);
    vclose(far) = 0;
    vbar = [sum(vclose(:, 1:2:end), 2), sum(vclose(:, 2:2:end), 2)]./nclose;
    ds = ds + vbar*ca;
    
    % Cohesion
    xclose = dxmat;
    xclose(far) = 0;
    mclose = [sum(xclose(:, 1:2:end), 2) sum(xclose(:, 2:2:end), 2)]./nclose;
    ds = ds + mclose*cc;
    
    v = v + ds*cd;
    v = vmax*v./sqrt(v(:, 1).^2 + v(:, 2).^2);
    x = x + v;
    x = mod(x, dims);
    X = [X x];
    k = k + 1;
end

animateBoids
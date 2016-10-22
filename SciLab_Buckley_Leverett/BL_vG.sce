// method-of-lines solution to the 1-D Buckley-Leverett equation

// constants and parameters

pathway = pwd() + '\';

g = 9.807;                  // gravitational acceleration, m/sec^2
u_w = 8.9e-4;               // viscosity, Pa*sec
u_n = 8.9e-4;               
rho_w = 1000.0;              // density, kg/m^3
rho_n = 1000.0;              
phi = 0.3; 					// porosity
Q = 1.1574E-04;				// NAPL injection rate, m^3/sec
A = 1.0;					// cross-sectional area
n = 2.5;					// Van Genuchten relationship parameters
m = 1.0 - 1.0/n;
Swr = 0.15;					// residual saturations
Snr = 0.0;
epsilon = 1e-8;             // minimum NAPL saturation to maintain finite relative permeability         

function [Se_w,Se_n,St] = SatEff(S_w,S_n)
	// effective saturation
	Se_w = (S_w - Swr)/(1.0 - Swr);
	Se_n = (S_n - Snr)/(1.0 - Snr);
	St = (S_w + S_n - Swr - Snr)/(1.0 - Swr - Snr);
endfunction

function rel_perm = RelPermWater(S_w,S_n)
    // relative permeability for water
	[Se_w,Se_n,St] = SatEff(S_w,S_n);
	rel_perm = (Se_w.^0.5). * (1.0-(1.0-Se_w.^(1.0/m)).^m).^2.0 + epsilon;
endfunction

function rel_perm = RelPermNAPL(S_w,S_n)
    // relative permeability for NAPL
	[Se_w,Se_n,St] = SatEff(S_w,S_n);	
    rel_perm = ((St-Se_w).^0.5). * ((1.0-Se_w.^(1.0/m)).^m - (1.0-St.^(1.0/m)).^m).^2.0 + epsilon;
endfunction
	
function x = f_n(S_n)
    // fractional flow component for NAPL phase
    d = 1. + RelPermWater(1.0-S_n,S_n)*u_n./(RelPermNAPL(1.0-S_n,S_n)*u_w);
    x = d.^-1;
endfunction

function [ydot]=f(t,y,N_x,dx)
    v1 = 1.0/(A*phi*dx) * Q * (1.0 - f_n(y(1)));
    v2 = 1.0/(A*phi*dx) * Q * (f_n(y(1:$-1)) - f_n(y(2:$)));
    ydot = [v1;v2];           
endfunction

function Sat(L,N_x,t,N_t,S0,L0)
    // solve for the saturation profile of the intruding fluid along a 1-D column as a function of time
    dx = L/N_x;
    // initial conditions
    for i = 1:N_x,
        x(i) = (i-0.5)*dx;
        if x(i) < L0
       	    y0(i) = S0;
        else
       	    y0(i) = 0.0;
	    end        
    end
    t0 = 0.0
    dt = t/N_t;
    for i = 1:N_t
        y = ode(y0,t0,dt,list(f,N_x,dx));
        y0 = y;
    end
    // plot solution
    f1=scf(1);
    f1.color_map = [1 0 0];  
    xtitle('Saturation','x','S');
    plot2d(x,y,style=1);
    // write to file
    a_out = [x y];
    file_id = pathway + 'flowpath.txt'
    deletefile(file_id);  
    write(file_id,a_out,'(e11.5,2x,e11.5)');  
endfunction



% This is Go Nuts 1

% Objective function
f=[21,22.5,22.5,24.5,23,25.5,1500,2000,3000];
% coefficients of the objective function

% Constraints Matrix:
% From row 1 to row 5 max capacity and demand constraints
% From row 6 to row 11 non-negativity constraints

A=zeros(17,9); % creates a 11x6 matrix full of zeros
A(1,1)=1;A(1,2)=1;
A(2,3)=1;A(2,4)=1;
A(3,5)=1;A(3,6)=1;
A(4,1)=-1;A(4,3)=-1;A(4,5)=-1;
A(5,2)=-1;A(5,4)=-1;A(5,6)=-1;
A(6,1)=-1;
A(7,2)=-1;
A(8,3)=-1;
A(9,4)=-1;
A(10,5)=-1;
A(11,6)=-1;
A(12,1)=1;
A(12,2)=1;
A(12,7)=-425;
A(13,3)=1; 
A(13,4)=1; 
A(13,8)=-400;
A(14,5)=1;
A(14,6)=1;
A(14,9)=-750;
A(15,7)=1;A(16,8)=1;A(17,9)=1;

% Right-hand side coefficients
b=[425,400,750,-550,-450,0,0,0,0,0,0,0,0,0,1,1,1];

% Call linprog
x = linprog(f,A,b);

% Preliminary step to tell intlinprog
% which are the integer variables
intcon=1:9;

% Call intlinprog
[xx,fval,exitflag,output] = intlinprog(f,intcon,A,b);



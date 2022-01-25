'''
  variables
    x1: xGe     x2: xKe     x3: xGt     x4: xKt     x5: xGn     x6: xKn
    y1: (yE) p1open     y2: (yT) p2open     y3: (yN) p3open

    G: Ginko      K: Kola
    E: Ethiopia   T: Tanzania   N: Nigeria

  objective f.
    min x1*21 + x2*22.5 + x3*22.5 + x4*24.5 + x5*23 + x6*25.5 + y1*1500 + y2*2000 + y3*3000

  st
    CAPABILITY
    x1 + x2 <= 425
    x3 + x4 <= 400
    x5 + x6 <= 750
    DEMAND
    x1 + x3 + x5 >= 550
    x2 + x4 + x6 >= 450
    LINKING
    x1 + x2 - y1*425 <= 0
    x3 + x4 - y2*400 <= 0
    x5 + x6 - y3*750 <= 0

  bounds
    x1,..,x6 >= 0
'''
import pandas as pd

from pulp import *
'''  PuLP is an LP modeler written in python. PuLP can generate MPS or LP files
     and call GLPK[1], COIN CLP/CBC[2], CPLEX[3], GUROBI[4] and MOSEK[5] to solve linear problems.'''

# Definisco una Classe 'Linear Programming Problem' con l'obiettivo di 'Minimizzare' la funzione obiettivo
prob = LpProblem('Model_2', LpMinimize)  # Creates an LP Problem ---> LpMinimize  or  LpMaximize

# Aggiungo al problema le variabili
x1 = LpVariable('x1', lowBound=0, cat='Integer')  # Variabile Intera >= 0
'''
  name:     The name of the variable used in the output, e.g. 'x1'
  upBound:  The upper bound on this variable's range.
            Default is positive infinity.
  lowBound: The lower bound on this variable's range.
            Default is negative infinity,
  cat:      Integer, Binary or Continuous(default)
'''

x2 = LpVariable('x2', lowBound=0, cat='Integer')  
x3 = LpVariable('x3', lowBound=0, cat='Integer')
x4 = LpVariable('x4', lowBound=0, cat='Integer')
x5 = LpVariable('x5', lowBound=0, cat='Integer')
x6 = LpVariable('x6', lowBound=0, cat='Integer')
y1 = LpVariable('y1', cat='Binary')               # Variabile Binaria
y2 = LpVariable('y2', cat='Binary')
y3 = LpVariable('y3', cat='Binary')


# obj function
prob += x1*21 + x2*22.5 + x3*22.5 + x4*24.5 + x5*23 + x6*25.5 + y1*1500 + y2*2000 + y3*3000

# constraints                     # CAPACITÀ PRODUTTIVA (max unità per Paese)
prob += x1 + x2 <= 425            # Etiopia       425
prob += x3 + x4 <= 400            # Tanzania      400
prob += x5 + x6 <= 750            # Nigeria       750
                                  
                                  # DOMANDA, somma dei 3 Paesi
prob += x1 + x3 + x5 >= 550       # Ginko         550
prob += x2 + x4 + x6 >= 450       # Kola          450

                                  # COSTI FISSI se viene prodotta 1+ unità
prob += x1 + x2 - y1*425 <= 0     # Etiopia       1500
prob += x3 + x4 - y2*400 <= 0     # Tanzania      2000
prob += x5 + x6 - y3*750 <= 0     # Nigeria       3000


# solve problem
status = prob.solve(solver=PULP_CBC_CMD(msg=0))
#  "PULP_CBC_CMD:   il solver
#   (msg=0)":       per far sì che il solver NON stampi i log

'''Param 
      solver:  Optional: the specific solver to be used, defaults to the default solver.

    v_solvers = [PULP_CBC_CMD, GLPK_CMD, COIN_CMD, PYGLPK, CPLEX_CMD, CPLEX_PY, GUROBI, GUROBI_CMD, MOSEK, XPRESS, COINMP_DLL, CHOCO_CMD, MIPCL_CMD, SCIP_CMD]
    _all_solvers = [
        PULP_CBC_CMD,       # 1° default
        GLPK_CMD,           # 2° default
        COIN_CMD,           # 3° default
        PYGLPK,
        CPLEX_CMD,
        CPLEX_PY,
        GUROBI,
        GUROBI_CMD,
        MOSEK,
        XPRESS,
        COINMP_DLL,
        CHOCO_CMD,
        MIPCL_CMD,
        SCIP_CMD,
    ]
'''

# print results
data = {
  'Ginko': [int(value(x1)), value(x3), value(x5)],
  'Kola': [value(x2), value(x4), value(x6)],
  'Plant': [value(y1), value(y2), value(y3)],
}
df = pd.DataFrame(data, index=['Ethiopia', 'Tanzania', 'Nigeria'])
print(prob.name + ' (with Fixed Costs) ==> Costs:', value(prob.objective), '$')
print(df)



'''
  Shadow Prices:
    The change in optimal value of the objective function per unit increase in the right-handside for a constraint, given everything else remain unchanged.
    e.g. Represent changes in total costs per increase in production capacity
  
  Slack:
    slack > 0, then not-binding || slack = 0, then binding ==> Changing binding constraint, changes solution

  How to print Shadow Prices and Slacks:
    o = [{'name':name, 'shadow price':c.pi, 'slack': c.slack} for name, c in prob.constraints.items()]
    print(pd.DataFrame(o))
'''

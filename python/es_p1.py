'''
  Variables
    x1: xGe     x2: xKe     x3: xGt     x4: xKt     x5: xGn     x6: xKn

  objective f.
    min 21*x1 + 22.5*x2 + 22.5*x3 + 24.5*x4 + 23*x5 + 25.5*x6

  st
    CAPABILITY
    x1 + x2 <= 425
    x3 + x4 <= 400
    x5 + x6 <= 750
    DEMAND
    x1 + x3 + x5 >= 550
    x2 + x4 + x6 >= 450

  bounds
    x1,..,x6 >= 0

'''


from pulp import *
import pandas as pd

prob = LpProblem('Model_1', LpMinimize)
x1 = LpVariable('x1', lowBound=0, cat='Integer')
x2 = LpVariable('x2', lowBound=0, cat='Integer')
x3 = LpVariable('x3', lowBound=0, cat='Integer')
x4 = LpVariable('x4', lowBound=0, cat='Integer')
x5 = LpVariable('x5', lowBound=0, cat='Integer')
x6 = LpVariable('x6', lowBound=0, cat='Integer')

# obj function
prob += x1*21 + x2*22.5 + x3*22.5 + x4*24.5 + x5*23 + x6*25.5

# constraints
prob += x1 + x2 <= 425
prob += x3 + x4 <= 400
prob += x5 + x6 <= 750

prob += x1 + x3 + x5 >= 550
prob += x2 + x4 + x6 >= 450

# solve problem
status = prob.solve(PULP_CBC_CMD(msg=0))

# print results
data = {
  'Ginko': [int(value(x1)), value(x3), value(x5)],
  'Kola': [value(x2), value(x4), value(x6)]
}
df = pd.DataFrame(data, index=['Ethiopia', 'Tanzania', 'Nigeria'])
print('Model 1 ==> Costs:', value(prob.objective), '$')
print(df)

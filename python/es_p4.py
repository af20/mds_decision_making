'''
  variables
    x1: xGe     x2: xKe     x3: xGt     x4: xKt     x5: xGn     x6: xKn
    y1: (yE) p1open     y2: (yT) p2open     y3: (yN) p3open

  objective f.
    min x1*21 + x2*22.5 + x3*22.5 + x4*24.5 + x5*23 + x6*25.5

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

    (new) MIN CAPABILITY
    x1 + x2 - y1*100 >= 0
    x3 + x4 - y2*250 >= 0
    x5 + x6 - y3*600 >= 0

    (new) MAX N° PLANTS
    y1 + y2 + y3 <= 2

  bounds
    x1,..,x6 >= 0
'''

from pulp import *
import pandas as pd

prob = LpProblem('Model_4', LpMinimize)
x1 = LpVariable('x1', lowBound=0, cat='Integer')
x2 = LpVariable('x2', lowBound=0, cat='Integer')
x3 = LpVariable('x3', lowBound=0, cat='Integer')
x4 = LpVariable('x4', lowBound=0, cat='Integer')
x5 = LpVariable('x5', lowBound=0, cat='Integer')
x6 = LpVariable('x6', lowBound=0, cat='Integer')
y1 = LpVariable('y1', lowBound=0, cat='Binary')
y2 = LpVariable('y2', lowBound=0, cat='Binary')
y3 = LpVariable('y3', lowBound=0, cat='Binary')


# obj function
prob += x1*21 + x2*22.5 + x3*22.5 + x4*24.5 + x5*23 + x6*25.5# + y1*1500 + y2*2000 + y3*3000

# constraints
prob += x1 + x2 <= 425
prob += x3 + x4 <= 400
prob += x5 + x6 <= 750

prob += x1 + x3 + x5 >= 550
prob += x2 + x4 + x6 >= 450

prob += x1 + x2 - y1*425 <= 0
prob += x3 + x4 - y2*400 <= 0
prob += x5 + x6 - y3*750 <= 0

prob += y1 + y2 + y3 <= 2


# solve problem
status = prob.solve(PULP_CBC_CMD(msg=0))

# print results
data = {
  'Ginko': [int(value(x1)), value(x3), value(x5)],
  'Kola': [value(x2), value(x4), value(x6)],
  'Plant': [value(y1), value(y2), value(y3)],
}
df = pd.DataFrame(data, index=['Ethiopia', 'Tanzania', 'Nigeria'])
print(prob.name + ' (2 Max Plants) ==> Costs:', value(prob.objective), '$')
print(df)

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
prob += x1 + x2 <= 425, 'Capability Ethiopia'
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
print(prob.name + ' ==> Costs:', value(prob.objective), '$')
print(df)


'''
  Shadow Prices:
    The change in optimal value of the objective function per unit increase in the right-handside for a constraint, given everything else remain unchanged.
    e.g. Represent changes in total costs per increase in production capacity

    The Shadow Price corresponds to the exchange rate of the Linear Programming model’s optimal value compared to the marginal modification of the right hand side (RHS) of the constraint. 
    It is understood that a marginal modification allows the conservation of the optimal base of the problem (identical original basic variables in the case of the Simplex Method) 
    or the geometry of the problem (maintain the original active constraints).

  Slack:
    slack > 0, then not-binding || slack = 0, then binding ==> Changing binding constraint, changes solution

  How to print Shadow Prices and Slacks:
    o = [{'name':name, 'shadow price':c.pi, 'slack': c.slack} for name, c in prob.constraints.items()]
    print(pd.DataFrame(o))
'''
"""We calculate the minimal covering rectangle of four points, and then calculate all regions covered by the rectangle"""
import matplotlib as mpl
import matplotlib.pyplot as plt
from math import floor

# chunkX = floor(X / 16.0)
# chunkY = floor(Y / 16.0)

# chunk to region
# regionX = floor(chunkX / 32.0)
# regionZ = floor(chunkZ / 32.0)

# enter input points
points = []
for i in range(4):
    s = input()
    s_ = s.split()
    if len(s_) == 2:
        points.append(((int(s_[0])), int(s_[1])))
    else:
        raise Exception("Wrong input format")

y_sorted_points = sorted(points, key=lambda pair: pair[1], reverse=True)

# first two are the top two vertices
top_v = y_sorted_points[:2]
# second two are the bottom two vertices
bottom_v = y_sorted_points[2:]

top_v = sorted(top_v, key=lambda pair: pair[0])
bottom_v = sorted(bottom_v, key=lambda pair: pair[0])

p1 = bottom_v[0]
p4 = bottom_v[1]

p2 = top_v[0]
p3 = top_v[1]

# these are the vertices in order
ls = [p1, p2, p3, p4]

# we now plot the vertices in order
ls.append(ls[0])
plt.plot([l[0] for l in ls], [l[1] for l in ls], 'b')

# calculate minimal covering rectangle
all_x = sorted([p[0] for p in ls])
all_y = sorted([p[1] for p in ls])

least_x = all_x[0]
most_x = all_x[-1]

least_y = all_y[0]
most_y = all_y[-1]

print(least_x, least_y)
print(most_x, most_y)

q1 = (least_x, least_y)
q2 = (least_x, most_y)
q3 = (most_x, most_y)
q4 = (most_x, least_y)

# minimum covering rectangle
min_c_rect = [q1, q2, q3, q4, q1]
plt.plot([l[0] for l in min_c_rect], [l[1] for l in min_c_rect], 'r')
plt.show()




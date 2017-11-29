import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


sc_data = pd.read_csv('Small_Car_Data.csv')
df = pd.DataFrame(sc_data)

print(df.describe())



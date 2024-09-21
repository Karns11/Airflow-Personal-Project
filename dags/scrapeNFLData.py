
import nfl_data_py as nfl

import pandas as pd



def scrape_weekly_data(csv_name):

    weekly_data = nfl.import_weekly_data(years=range(2023, 2024))

    num_columns = weekly_data.shape[1]

    weekly_data.to_csv(csv_name, index=False)

    print('saved to db. Num cols = ', num_columns)

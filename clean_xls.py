import xlrd
import json
from collections import defaultdict


if __name__ == '__main__':

    for year in range(2011, 2016):
        wb = xlrd.open_workbook('./data/irs/{}-irs.xls'.format(year))
        print(wb.sheet_names())

        """Sheet 1"""
        sh = wb.sheet_by_index(0)
        columns = list()

        for col_ind in range(sh.ncols):
            col_val = '###'.join([sh.row_values(3)[col_ind], sh.row_values(4)[col_ind]])
            columns.append(col_val)

        # irs_list = defaultdict(list)
        # for row in range(6, sh.nrows):
        #     zero_val = sh.row_values(row)[0]
        #     if isinstance(zero_val, str) and '**' in zero_val:
        #         break
        #
        #     if not isinstance(zero_val, str):
        #         for ind, val in enumerate(sh.row_values(row)):
        #             irs_list[columns[ind]].append(val)

        print(year, len(columns))

        # json_file = open('./data/{}-irs.json'.format(year), 'w')
        # json_file.write(json.dumps(irs_list))
        # json_file.close()

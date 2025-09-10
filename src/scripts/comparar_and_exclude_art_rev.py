import os
import glob
import pandas as pd
from tabulate import tabulate
from pathlib import Path
pathparent = str(Path(os.getcwd()).parents[0])
print("pathparent ", pathparent)


path_rev = os.path.join(pathparent, 'dados')
lstfiles = glob.glob(path_rev + '/*')
lstCols = ['Author(s) ID', 'Title', 'Index Keywords']
for cc, pathfile in enumerate(lstfiles):
    print(f"# {cc} >> {pathfile}")
    if '.xlsx' in pathfile:
        xls = pd.ExcelFile(pathfile)
        name_sheet = list(xls.sheet_names)[0]
        print("reading sheet >> ", name_sheet)
        # Carregar a planilha específica
        dfxls = pd.read_excel(pathfile, sheet_name= name_sheet)
        # print(dfxls.columns)
        # print(dfxls.haead())
        # Exibe o DataFrame
        print(tabulate(dfxls[lstCols].head(3), headers = 'keys', tablefmt = 'psql', floatfmt=".2f"))
        # filtrar por aqueles que não foram lidos 
import pandas as pd
import datetime

def timeseries_to_pandas(ts,ind):
    #ind=datetime.datetime.fromtimestamp(ind)
    x=len(ts)
    print(x)
    if x>1:
        print(x)
        ts_dict={}
        for i in range(0,x):
            j=str(i)
            print(ts)
            dict_u={j:ts[i]}
            print(dict_u)
            ts_dict.update(dict_u)
    
        df=pd.DataFrame(data=ts_dict,index=ind)
    else:
        df=pd.DataFrame(data=ts,index=ind)
    return df

def spectra_to_pandas(frequency,spectra):
    df=pd.DataFrame(data=spectra,index=frequency)
    df.indexname='(Hz)'
    df.columns=['PM']
    return df.T
    
    


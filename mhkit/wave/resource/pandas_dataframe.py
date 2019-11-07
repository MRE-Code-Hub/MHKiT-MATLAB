import pandas as pd
import datetime

def timeseries_to_pandas(ts,ind,x):
    #ind=datetime.datetime.fromtimestamp(ind)
    #x=len(ts)
    #print(x)
    if x>1:
        #print(ts)
        ts=list(map(list,zip(*ts)))
        #print(ind)
        df=pd.DataFrame(data=ts,index=ind)
        
    else:
        
        df=pd.DataFrame(data=ts,index=ind)
        
    return df

def spectra_to_pandas(frequency,spectra,x):
    if x>1:
        #print(ts)
        ts=list(map(list,zip(*spectra)))
        #print(ind)
        df=pd.DataFrame(data=ts,index=frequency)
        #df.indexname='(Hz)'
        
    else:
        df=pd.DataFrame(data=spectra.T,index=frequency)
        df.indexname='(Hz)'
        c_name=['PM']
    return df

def lis(li,app):
    li.append(app)
    return li
    
    


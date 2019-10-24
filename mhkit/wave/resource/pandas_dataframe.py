import pandas as pd
import datetime

def timeseries_to_pandas(ts,ind,x):
    #ind=datetime.datetime.fromtimestamp(ind)
    #x=len(ts)
    #print(x)
    if x>1:
        #print(x)
        #ts_dict={}
        #for i in range(0,x):
            #j=str(i)+'i'
            #print(ts)
            #dict_u={j:ts[i]}
            
            #ts_dict.update(dict_u)
        #print(ts_dict['1'])
        #df=pd.DataFrame(data=ts_dict,index=ind)
        ts=list(map(list,zip(*ts)))
        df=pd.DataFrame(data=ts,index=ind)
        print(df)
        #df.columns=['OS','OSS']
        #print(df.columns)
    else:
        
        df=pd.DataFrame(data=ts,index=ind)
        
    return df

def spectra_to_pandas(frequency,spectra):
    df=pd.DataFrame(data=spectra.T,index=frequency)
    df.indexname='(Hz)'
    c_name=['PM']
    for i in range(0,len(df.columns)-1):
        c_name.append('PM')
    df.columns=c_name
    return df.T
    
    


import pandas as pd


def timeseries_to_pandas(ts,ind):
    df=pd.DataFrame(data=ts,index=ind)
    return df

def spectra_to_pandas(frequency,spectra):
    df=pd.DataFrame(data=spectra,index=frequency)
    df.indexname='(Hz)'
    df.columns=['PM']
    return df
    
    


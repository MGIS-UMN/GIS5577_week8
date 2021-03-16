# -*- coding: utf-8 -*-
"""
Created on Tue Mar 16 17:26:19 2021

@author: dahaynes
"""


import psycopg2



def CreateConnection(theConnectionDict):
    """
    This method will get a connection. Need to make sure that the DB is set correctly.
    """
    
    connection = psycopg2.connect(host=theConnectionDict['host'], database=theConnectionDict['db'], user=theConnectionDict['user'], port=theConnectionDict['port'])

    return connection

def ExecuteQuery(pgCon, query):
    
    
    pgCur = pgCon.cursor() 
    try:
        pgCur.execute(query)
    except:
        print("ERROR...", query)
    
    return pgCur

def WriteToFile(outFilePath, outString, writeMode='wb'):
    """
    dfadf
    """
    with open(outFilePath, writeMode) as fout:
         fout.write(outString)
         
         
         
myConnection = {"host": "localhost", "db": "research", "port": 5432, "user": "david", "password": "XXX"}
con = CreateConnection(myConnection)  


cur = ExecuteQuery(con, "SELECT ST_AsTiff(rast, 'LZW') as rast from glc2000 where rid=1")

for img in cur:
    WriteToFile('c:\work\glc2000.tif', img[0], 'wb')
    
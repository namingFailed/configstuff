#TODO make this ignore all other environments except for quotation
#
import sys
import os

def wordCount(lines, sl, el):
    # put those lines together
    wc=0
    for i in lines[sl+1:el+1]:
            wc+= len(i.split())
    print "Words: ",wc
def endTag(name,intendType, linenum, TYPES, CODES):
    if intendType == "docStart":
        Tagtype=CODES[len(CODES)-1]
    else:
        Tagtype=intendType
    poss=[]
    for i in range(len(linenum)):
        if TYPES[linenum[linenum.keys()[i]][1]]<=TYPES[Tagtype]:
            poss.append(linenum[linenum.keys()[i]][0])
    closest=-1
    if not poss == None: 
        for i in poss:
            if i > linenum[name][0]:
                if closest == -1:
                    closest = i-1
                elif closest > i:
                    closest = i-1
                else:
                    continue
    if closest == -1:
        intendType=CODES[TYPES[Tagtype]-1]
        closest= endTag(name, intendType, linenum, TYPES, CODES)
    return closest
doc = sys.argv[1]
try:
    fdoc=open(doc, "r")
except IOError as e:
    print e
    sys.exit(0)
lines=fdoc.readlines()
linenum={}

TYPES={"docend":0,"Chapter":1,"Section":2,"Subsection":3,"Subsubsection":4,"docStart":5} 
CODES = {v:k for k, v in TYPES.items()}

inDoc=False
inEnv=False

for i in range(len(lines)):
    #if comment ignore
    if lines[i].startswith("%"):
        continue
    if lines[i].find("\\begin{document}")!=-1:
        linenum["DocStart"] = [i, "docStart"]
        inDoc=True
    if lines[i].find("\\chapter{")!=-1:
        chapterName=lines[i][9:-2]
        linenum[chapterName] = [i, "Chapter"]
    if lines[i].find("\\section{")!=-1:
        linenum[lines[i][9:-2]] = [i, "Section"]
    if lines[i].find("\\subsection{")!=-1:
        linenum[lines[i][12:-2]] = [i, "Subsection"]
    if lines[i].find("\\subsubsection{")!=-1:
        linenum[lines[i][15:-2]] = [i, "Subsubsection"]
    if lines[i].find("\\end{document}")!=-1:
            linenum["DocEnd"]=[i, "docend"]
            inDoc=False

for i in (linenum.keys()):
    if i == "DocStart":
        print "doc starts at ", linenum[i][0], " and ends at ", linenum["DocEnd"][0]
        print "The text before any sub part starts at ", linenum[i][0], "and ends at ", endTag("DocStart", linenum["DocStart"][1], linenum, TYPES, CODES)
    elif i == "DocEnd":
        continue
    else:
        start = linenum[i][0]
        end = endTag(i,linenum[i][1], linenum,TYPES, CODES)
        print i, " starts at ", linenum[i][0], " and ends at ", endTag(i,linenum[i][1], linenum,TYPES, CODES)
        wordCount(lines,start, end)

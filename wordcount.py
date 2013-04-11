#TODO make this ignore all other environments except for quotation
#
import sys
import os
import operator
def lowest(l):
    low=-1
    lowpair=None
    for i in l:
        if low == -1:
            low = i[0]
            lowpair=i
        elif low > i[0]:
            low = i[0]
            lowpair=i
        else:
            continue
    return lowpair
def wordCount(lines, sl, el):
    # put those lines together
    wc=0
    for i in lines[sl+1:el+1]:
            wc+= len(i.split())
    return wc
def wcWithgaps (lines, sl, el, linenum, TYPES, CODES):
    #list the intervening envs
    gaplist = []
    for i in range(len(linenum.keys())):
        if linenum[linenum.keys()[i]][0] > sl and linenum[linenum.keys()[i]][0] < el:
            if linenum[linenum.keys()[i]][1] == "envstart":
                eel = endTag(linenum.keys()[i], "envstart", linenum, TYPES, CODES)
                gaplist.append([linenum[linenum.keys()[i]][2], eel])
    if not len(gaplist)==0:
        wc=0
        while len(gaplist)>0: 
            #take the gap closest to start
            lp=lowest(gaplist)
            if lp[0] < sl :
                gaplist.remove(lp)
                continue
            #wordCount Start to lowest gap
            wc+=wordCount(lines,sl, lp[0])
            #remove section
            gaplist.remove(lp)
            sl=lp[1]
        print "words: ", wc

        #calculate th good parts

def endTag(name,intendType, linenum, TYPES, CODES):
    if intendType == "docStart":
        Tagtype=CODES[len(CODES)-2]
    elif intendType == "envstart":
        Tagtype = "envend"
    elif intendType == "envend":
        return linenum[name][2]
    else:
        Tagtype=intendType
    poss=[]
    for i in range(len(linenum)):
        if 0<=TYPES[linenum[linenum.keys()[i]][1]]<=TYPES[Tagtype]:
            poss.append(linenum[linenum.keys()[i]][2])
        elif TYPES[linenum[linenum.keys()[i]][1]] == TYPES[Tagtype]:
            poss.append(linenum[linenum.keys()[i]][2])
    closest=-1
    if not poss == None: 
        for i in poss:
            if i > linenum[name][2]:
                if closest == -1:
                    closest = i-1
                elif closest > i:
                    closest = i-1
                else:
                    continue
   # print poss
   # print closest
   # print "tt :"+Tagtype+ " it :"+intendType
    if (poss == None or closest == -1) and Tagtype=="envend":
        print "ERROR There is a begin environment without a close"
        return -1
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

TYPES={"docend":0,"Chapter":1,"Section":2,"Subsection":3,"Subsubsection":4,"docStart":5,"envend":-1,"envstart":-1 }
CODES = {v:k for k, v in TYPES.items()}

inDoc=False
inEnv=False
envcount=0

for i in range(len(lines)):
    #if comment ignore
    if lines[i].startswith("%"):
        continue
    if lines[i].find("\\begin{")!=-1:
        if lines[i].find("\\begin{document}")!=-1:
            linenum["DocStart"] = [i, "docStart", i+1]
            inDoc=True
        elif lines[i].find("\\begin{quotation}")!=-1:
            continue
        else:
            linenum["EnvStart",envcount]=[i, "envstart", i+1]
            envcount+=1
    if lines[i].find("\\chapter{")!=-1:
        chapterName=lines[i][9:-2]
        linenum[chapterName] = [i, "Chapter", i+1]
    if lines[i].find("\\section{")!=-1:
        linenum[lines[i][9:-2]] = [i, "Section", i+1]
    if lines[i].find("\\subsection{")!=-1:
        linenum[lines[i][12:-2]] = [i, "Subsection", i+1]
    if lines[i].find("\\subsubsection{")!=-1:
        linenum[lines[i][15:-2]] = [i, "Subsubsection", i+1]
    if lines[i].find("\\end{")!=-1:
        if lines[i].find("\\end{document}")!=-1:
            linenum["DocEnd"]=[i, "docend", i+1]
            inDoc=False
        elif lines[i].find("\\end{quotation}")!=-1:
            continue
        else:
            linenum["EnvEnd",envcount]=[i, "envend", i+1]
            envcount+=1
for i in (linenum.keys()):
    if i == "DocStart":
        end = endTag("DocStart", linenum["DocStart"][1], linenum, TYPES, CODES)
        print "doc starts at ", linenum[i][2], " and ends at ", linenum["DocEnd"][2]
        print "The text before any sub part starts at ", linenum[i][2], "and ends at ", end
    elif i == "DocEnd" or i[0].find("EnvEnd")!=-1 or i[0].find("EnvStart")!=-1:
        continue
    else:
        start = linenum[i][2]
        end=endTag(i,linenum[i][1], linenum,TYPES, CODES)
        print i, " starts at ", linenum[i][2], " and ends at ", end 
        wcWithgaps(lines,start, end, linenum, TYPES, CODES)
